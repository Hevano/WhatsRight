//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef GLESRenderer_hpp
#define GLESRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>
#include <glm/glm.hpp>
#include "GameObject.hpp"

// These are GL indices for uniform variables used by GLSL shaders.
// You can add additional ones, for example for a normal matrix,
//  textures, toggles, or for any other data to pass on to the shaders.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    // ### insert additional uniforms here
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_PASSTHROUGH,
    UNIFORM_SHADEINFRAG,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
};

class GLESRenderer
{
    
public:
    GLESRenderer();
    char *LoadShaderFile(const char *shaderFileName);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint LoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);

    int GenCube(float scale, float **vertices, float **normals,
                float **texCoords, int **indices);
    int GenSquare(float scale, float **vertices, int **indices);

    void DrawGameObject(GameObject *obj);

    GLint uniforms[NUM_UNIFORMS];
    glm::mat4 projectionMat;
    glm::mat4 viewMat;
};


#endif /* GLESRenderer_hpp */
