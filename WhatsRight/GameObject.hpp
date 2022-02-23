//
//  GameObject.hpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-23.
//

#ifndef GameObject_hpp
#define GameObject_hpp

#include <stdio.h>
#include "glm/glm.hpp"
#include "glm/gtc/quaternion.hpp"
#include "glm/gtx/quaternion.hpp"



class GameObject
{
public:
    float *vertices;
    // ### add additional vertex data (e.g., vertex normals, texture coordinates, etc.) here
    float *normals, *texCoords;
    int *indices, numIndices;

    glm::vec3 position;
    glm::vec3 scale;
    glm::quat rotation;
    glm::mat4 modelMatrix;
    
    GameObject(int numIndices, float *vertices, float *normals, float *texCoords, int *indices);

    void setScale(glm::vec3 scale);
    void setRotation(glm::quat rotation);
    void setPosition(glm::vec3 position);
    
private:
    glm::mat4 updateModelMatrix();
};

#endif /* GameObject_hpp */
