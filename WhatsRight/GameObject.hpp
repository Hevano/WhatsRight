#ifndef GameObject_hpp
#define GameObject_hpp

#include <stdlib.h>
#include <OpenGLES/ES3/gl.h>
#include <glm/glm.hpp>
#include "GLESRenderer.hpp"

class GameObject
{
public:
    GLuint[] vbos;
    GLuint texture;
    std::vector<unsigned int> attribArrays;
    GLuint idxBuf;
    int numIndices;

    GLKVector3 position;
    GLKVector3 scale;
    GLKQuaternion rotation;

    GameObject();

    glm::mat4 modelMatrix();
    void setScale(glm::vec3 scale);
    void setRotation(glm::quat rotation);
    void setPosition(glm::vec3 position);
};

#endif /* GameObject_hpp */