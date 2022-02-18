//
//  GameObject.m
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-16.
//
#import "GameObject.h"
#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include "GLESRenderer.hpp"

@interface GameObject () {
    position = GLKVector3();
    scale = GLKVector3();
    rotation = GLKQuaternion();
    uniforms = GLint[];

    //load model
    float *vertices;
    float *normals, *texCoords;
    int *indices, numIndices;
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
    //create buffer


    //Format of vertices in the buffer
    struct glVertStruct {
        GLfloat position[3];
        GLfloat color[4];
        GLfloat normal[3];
    };
    struct glVertStruct vertBuf[24]; // <-- the model data goes here

    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertBuf), vertBuf, GL_STATIC_DRAW);
    glVertexAttribPointer ( 0, 3, GL_FLOAT,
                           GL_FALSE, sizeof ( vertBuf[0] ),
                           (void *)offsetof(glVertStruct, position) ); //Defines space in the buffer that position takes up
    glEnableVertexAttribArray ( 0 );
    glVertexAttribPointer ( 1, 4, GL_FLOAT,
                           GL_FALSE, sizeof ( vertBuf[0] ),
                           (void *)offsetof(glVertStruct, color) ); //Defines space in the buffer that color takes up
    glEnableVertexAttribArray ( 1 );
    glVertexAttribPointer ( 2, 3, GL_FLOAT,
                           GL_FALSE, sizeof ( vertBuf[0] ),
                           (void *)offsetof(glVertStruct, normal) ); //Defines space in the buffer that normal takes up
    glEnableVertexAttribArray ( 2 );
    
    //load texture
}

@end

@implementation GameObject

@synthesize vbo;
@synthesize texture;

@synthesize position;
@synthesize scale;
@synthesize rotation;

- (GLKMatrix4)modelMatrix{
    
}
- (void)setScale:(GLKVector3)scale{
    
}
- (void)setRotation:(GLKQuaternion)rotation{
    
}
- (void)setPosition:(GLKVector3)position{
    
}
