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
    m_rotation = 0.0f;
    
    updateModelMatrix();
    
    m_numIndices = numIndices;
    m_vertices = vertices;
    m_normals = normals;
    m_texCoords = texCoords;
    m_indices = indices;
}

void GameObject::setRotation(float rotation){
    m_rotation = rotation;
    updateModelMatrix();
}

void GameObject::setPosition(glm::vec3 position){
    m_position = std::move(position);
    //m_body->SetTransform(b2Vec2(position.x, position.z), 0);
    updateModelMatrix();
}

void GameObject::setScale(glm::vec3 scale){
    m_scale = std::move(scale);
    updateModelMatrix();
}

glm::mat4 GameObject::updateModelMatrix(){
    glm::mat4 model = glm::translate(glm::mat4(1.0f), m_position);
    model = glm::rotate(model, glm::radians(m_rotation), glm::normalize(glm::vec3(0.5f, -1.2f, 0.8f)));
    model = glm::scale(model, m_scale);
    m_modelMatrix = model;
    return model;
}
