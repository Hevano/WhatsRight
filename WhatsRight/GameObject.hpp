#ifndef GameObject_hpp
#define GameObject_hpp

#include <stdlib.h>
#include <OpenGLES/ES3/gl.h>
#include <glm/glm.hpp>
#include <glm/gtc/quaternion.hpp>
#include <glm/gtx/quaternion.hpp>
#include <vector>
#include "GLESRenderer.hpp"


class GameObject
{
public:
    GLuint vbos[2];
    GLuint texture;
    std::vector<unsigned int> attribArrays;
    GLuint idxBuf;
    int numIndices;

    glm::vec3 position;
    glm::vec3 scale;
    glm::quat rotation;
    glm::mat4 modelMatrix;
    
    GameObject(GLESRenderer *renderer);

    glm::mat4 getModelMatrix();
    void setScale(glm::vec3 scale);
    void setRotation(glm::quat rotation);
    void setPosition(glm::vec3 position);
};

#endif /* GameObject_hpp */
