//
//  Copyright © Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <chrono>
#include "GLESRenderer.hpp"
#include "PhysicsManager.hpp"
#include "objloader.hpp"
#include <vector>

// These are GL indices for uniform variables used by GLSL shaders.
// You can add additional ones, for example for a normal matrix,
//  textures, toggles, or for any other data to pass on to the shaders.


// These are GL indices for vertex attributes
//  (e.g., vertex normals, texture coordinates, etc.)
enum
{
    ATTRIB_VERTEX,
    // ### insert additional vertex data here
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer () {
    GLKView *theView;   // used to access view properties (e.g., its size)
    GLESRenderer glesRenderer;  // our GLES renderer object
    GLuint programObject;   // GLSL shader program that has the vertex and fragment shaders
    std::chrono::time_point<std::chrono::steady_clock> lastTime;

    // GL variables to associate with uniforms
    GLKMatrix4 mvp;
    // ### add additional ones (e.g., texture IDs, normal matrices, etc.) here
    GLKMatrix3 normalMatrix;
    GLuint crateTexture;
    
    // global lighting parameters
    glm::vec4 specularLightPosition;
    glm::vec4 specularComponent;
    GLfloat shininess;
    glm::vec4 ambientComponent;
    glm::vec4 diffuseLightPosition;
    glm::vec4 diffuseComponent;
    

    // GL vertex data (minimum X,Y,Z location)
    float *vertices;
    // ### add additional vertex data (e.g., vertex normals, texture coordinates, etc.) here
    float *normals, *texCoords;
    int *indices, numIndices;
    GameObject *g;
    
    std::vector<glm::vec3> modelVertices;
    std::vector<glm::vec2> modelUvs;
    std::vector<glm::vec3> modelNormals;
    std::vector<int> modelIndices;
    float obstacleRotation;
    float obstacleRotationSpeed;
    
    GameObject *obstacles[3];
    
    PhysicsManager physics;

    int rNum[3];
}

@end

@implementation Renderer

@synthesize isRed;
// ### add any other properties that need to be synthesized
@synthesize isRotating;

@synthesize rotAngle;

@synthesize reset;

@synthesize zoom;

@synthesize position;

@synthesize panRotation;

@synthesize transX;
@synthesize transY;

@synthesize transObstacle;
@synthesize transCounter;
@synthesize speedChangeCounter;
@synthesize speedCap;
@synthesize score;
@synthesize gameTime;
@synthesize timeStamp;
@synthesize invulnTimer;
@synthesize isInvuln;
@synthesize youLost;
@synthesize highScore;
@synthesize pauseGame;

- (void)dealloc
{
    glDeleteProgram(programObject);
}

- (void)loadModels
{
//    numIndices = glesRenderer.GenSquare(1.0f, &vertices, &indices);
    // ### instead of a cube, you can load any other model
    //numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
}

- (void)setup:(GLKView *)view
{
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    if (![self setupShaders])
        return;

    // ### you should also load any textures needed here (you can use the setupTexture method below to load in a JPEG image and assign it to a GL texture)
    crateTexture = [self setupTexture:@"crate.jpg"];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, crateTexture);
    glUniform1i(glesRenderer.uniforms[UNIFORM_TEXTURE], 0);

    glClearColor ( 0.0f, 0.0f, 0.0f, 0.0f ); // background color
    glEnable(GL_DEPTH_TEST);
    lastTime = std::chrono::steady_clock::now();
    
    //physics = PhysicsManager();
    
    float *vertices;
    // ### add additional vertex data (e.g., vertex normals, texture coordinates, etc.) here
    float *normals, *texCoords;
    int *indices, numIndices;
    
    //numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
    auto path = [[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"cube.obj"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"cube.obj"] pathExtension]] cStringUsingEncoding:1];
    bool res = loadOBJ(path, modelVertices, modelUvs, modelNormals, modelIndices);
    numIndices = modelVertices.size();
    g = new GameObject(numIndices, (float*) (&modelVertices[0].x), (float*) (&modelNormals[0].x), (float*) (&modelUvs[0].x), (int*) (&modelIndices[0]));
    //physics.CreateBody(*(g));
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
    //g = new GameObject(numIndices, vertices, normals, texCoords, indices);
    g->m_textureId = 0; //Set object texture;
    
    for (int i = 0; i < sizeof(obstacles)/sizeof(*obstacles); i++)  {
        printf("%d\n", i);
        obstacles[i] = new GameObject(numIndices, vertices, normals, texCoords, indices);
        //physics.CreateBody(*(obstacles[i]));
    }
 
    
    //Lighting
    specularComponent = glm::vec4(0.8f, 0.1f, 0.1f, 1.0f);
    specularLightPosition = glm::vec4(0.0f, 0.0f, 1.0f, 1.0f);
    shininess = 1000.0f;
    ambientComponent = glm::vec4(0.5f, 0.5f, 0.5f, 1.0f);
    diffuseLightPosition = glm::vec4(0.0f, 0.0f, 1.0f, 1.0f);
    diffuseComponent = glm::vec4(0.0f, 1.0f, 0.0f, 1.0f);
    
    transObstacle = -15;
    transCounter = 0.0005f;
    speedChangeCounter = 0;
    speedCap = 0.01f;
    score = 0;
    position.x = 0;
    gameTime = 0;
    invulnTimer = 1000;
    timeStamp = 0;
    isInvuln = false;
    youLost = false;
    pauseGame = false;
    
    for (int i=0; i<3; i++) {
        rNum[i] = rand()%5+1;
    }
    
    obstacleRotation = 0.0f;
    obstacleRotationSpeed = 15.0f;
    
}

- (void)update
{
   
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;
    
    gameTime += elapsedTime;

    //physics.Update(elapsedTime);
    // Function used when a collision occurs
    bool hitDetected = false;
    for (int i = 0; i < 3; i++)  {
        glm::vec3 pos = obstacles[i]->m_position;
        
        if((g->m_position.x + 0.5 > pos.x && pos.x > g->m_position.x
            - 0.5) && pos.y == g->m_position.y){
            hitDetected = true;
        }
    }
    
    if( hitDetected ) {
        if(gameTime >= timeStamp)isInvuln = false;
        if(!isInvuln){
            position.x -= 1;
            isInvuln = true;
            timeStamp = gameTime + invulnTimer;
            if (position.x <= -3) {
                youLost = true;
                if (score > highScore) {
                    highScore = score;
                }
                position.x = 0;
                score = 0;
                transCounter = 0.0005f;
                pauseGame = true;
                printf("Game Over\n");
            }
        }
    }
    
    if (pauseGame == false) {
        // Variable for Score - Add to UI
        score += int(elapsedTime) / 30;
    }
    
    //printf("Score: %d \n", score );
    
    // ### do any other updating (e.g., changing the rotation angle of an auto-rotating cube) here
    if (isRotating)
    {
        rotAngle += 0.001f * elapsedTime;
        if (rotAngle >= 360.0f)
            rotAngle = 0.0f;
    }
    
    if(reset){
        reset = false;
        rotAngle = 0.0f;
        panRotation.x = 0;
        panRotation.y = 0;
        zoom = -5.0f;
        position.x = -1.5;
        position.y = 0;
        //reset position
    }
    
    if (pauseGame == false) {
        transObstacle -= (0.003f + transCounter) * elapsedTime;
    }
    
    //float lastRNum = rNum[0];
    
    // Game logic to move obstacles and change the speed over time
    if(transObstacle < -14){
        transObstacle = 4;
        for (int i=0; i<3; i++) {
            rNum[i] = rand()%5+1;
            if(i != 0){
                if (abs(rNum[i-1] - rNum[i]) <= 2) {
                    rNum[i] = rNum[i] + 3;
                }
            }
        }
        
        // Used to cap speed at a certain point.
        // speedChangeCounter changes speed based off how many loops the obstacles ran through.
        if (speedCap >= transCounter) {
            speedChangeCounter += 1;
            if (speedChangeCounter >= 3) {
                transCounter += 0.0005f;
                speedChangeCounter = 0;
                printf("transCounter:  %.6f \n", transCounter);
            }
        }
        
    }

    // Set up a perspective view
    //mvp = GLKMatrix4Translate(GLKMatrix4Identity, position.x, position.y, zoom);
    // ### add any other transformations here (e.g., adding a rotation for a cube, or setting up a normal matrix for the shader)
    mvp = GLKMatrix4Rotate(mvp, rotAngle, 0.0, 1.0, 0.0 );
    mvp = GLKMatrix4Rotate(mvp, panRotation.x, 0.0, 0.0, 1.0);
    mvp = GLKMatrix4Rotate(mvp, panRotation.y, 0.0, 1.0, 0.0);
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);
    
    g->setPosition(glm::vec3(position.x, position.y, 0));
   
    obstacleRotation += obstacleRotationSpeed;
    for (int i = 0; i < sizeof(obstacles)/sizeof(*obstacles); i++)  {
        obstacles[i]->setPosition(glm::vec3(transObstacle+rNum[i], i-1, 0));
        obstacles[i]->setRotation(obstacleRotation);
    }
    
    glesRenderer.aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
}

- (void)rotate:(float)xAxis secondAxis:(float)yAxis thirdAxis:(float)zAxis;
{
    panRotation.x = xAxis * M_PI / 180;
    panRotation.y = zAxis * M_PI / 180;
}

- (void)translate:(float)xAxis secondAxis:(float)yAxis thirdAxis:(float)zAxis;
{
    position.x = xAxis;
    position.y = yAxis;
}

- (void)draw:(CGRect)drawRect;
{
    // Lighting uniforms
    glUniform1i(glesRenderer.uniforms[UNIFORM_LIGHT_SHININESS], shininess);
    glUniform4fv(glesRenderer.uniforms[UNIFORM_LIGHT_SPECULAR_POSITION], 1, (const float*) &specularLightPosition);
    glUniform4fv(glesRenderer.uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT], 1, (const float*) &specularComponent);
    glUniform4fv(glesRenderer.uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT], 1, (const float*) &ambientComponent);
    glUniform4fv(glesRenderer.uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION], 1, (const float*) &diffuseLightPosition);
    glUniform4fv(glesRenderer.uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT], 1, (const float*) &diffuseComponent);
    
    glUniformMatrix3fv(glesRenderer.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glUseProgram ( programObject );
    
    //glesRenderer.DrawCube(0, position.y * 1.5, 0);
    //glesRenderer.DrawCube(0, 0, 0);
    
    
    
    glesRenderer.DrawGameObject(g);
    for (int i = 0; i < sizeof(obstacles)/sizeof(*obstacles); i++) {
        glesRenderer.DrawGameObject(obstacles[i]);
    }
}


- (bool)setupShaders
{
    // Load shaders
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    programObject = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0)
        return false;
    
    // Set up uniform variables
    glesRenderer.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    glesRenderer.uniforms[UNIFORM_MODELVIEW_MATRIX] = glGetUniformLocation(programObject, "modelViewMatrix");
    glesRenderer.uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    glesRenderer.uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(programObject, "texSampler");
    glesRenderer.uniforms[UNIFORM_LIGHT_SPECULAR_POSITION] = glGetUniformLocation(programObject, "specularLightPosition");
    glesRenderer.uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION] = glGetUniformLocation(programObject, "diffuseLightPosition");
    glesRenderer.uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT] = glGetUniformLocation(programObject, "diffuseComponent");
    glesRenderer.uniforms[UNIFORM_LIGHT_SHININESS] = glGetUniformLocation(programObject, "shininess");
    glesRenderer.uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT] = glGetUniformLocation(programObject, "specularComponent");
    glesRenderer.uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT] = glGetUniformLocation(programObject, "ambientComponent");
    glesRenderer.uniforms[UNIFORM_USE_TEXTURE] = glGetUniformLocation(programObject, "useTexture");

    return true;
}


// Load in and set up texture image (adapted from Ray Wenderlich)
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

@end

