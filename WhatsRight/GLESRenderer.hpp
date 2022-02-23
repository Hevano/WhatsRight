//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef GLESRenderer_hpp
#define GLESRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>
#include "glm/glm.hpp"
#include "GameObject.hpp"

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
    GLint uniforms[NUM_UNIFORMS];
    float aspect;
    char *LoadShaderFile(const char *shaderFileName);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint LoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);

    int GenCube(float scale, float **vertices, float **normals,
                float **texCoords, int **indices);
    int GenSquare(float scale, float **vertices, int **indices);
    void DrawCube(float x, float y, float z);
    void DrawGameObject(GameObject *obj);
};

#endif /* GLESRenderer_hpp */
