//
//  GameObject.cpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-23.
//

#include "GameObject.hpp"

GameObject::GameObject(int numIndices, float *vertices, float *normals, float *texCoords, int *indices) {
    m_position = glm::vec3(0.0f);
    m_scale = glm::vec3(1.0f);
    m_rotation = glm::quat(glm::vec3(0.0f));
    
    updateModelMatrix();
    
    m_numIndices = numIndices;
    m_vertices = vertices;
    m_normals = normals;
    m_texCoords = texCoords;
    m_indices = indices;
}

glm::mat4 GameObject::updateModelMatrix(){
    glm::mat4 model = glm::translate(glm::mat4(1.0f), m_position)
    * glm::toMat4(m_rotation);
    glm::scale(model, m_scale);
    m_modelMatrix = model;
    return model;
}
