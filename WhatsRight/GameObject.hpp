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
  
    GameObject(int numIndices, float *vertices, float *normals, float *texCoords, int *indices);

    void setScale(glm::vec3 scale);
    void setRotation(glm::quat rotation);
    void setPosition(glm::vec3 position);
    
    float *m_vertices;
    // ### add additional vertex data (e.g., vertex normals, texture coordinates, etc.) here
    float *m_normals, *m_texCoords;
    int *m_indices, m_numIndices;

    glm::vec3 m_position;
    glm::vec3 m_scale;
    glm::quat m_rotation;
    glm::mat4 m_modelMatrix;
    
    
private:
    glm::mat4 updateModelMatrix();
    
    
};

#endif /* GameObject_hpp */
