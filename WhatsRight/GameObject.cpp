//
//  GameObject.cpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-23.
//

#include "GameObject.hpp"
#include "glm/gtc/quaternion.hpp"
#include "glm/gtx/quaternion.hpp"

GameObject::GameObject(int numIndices, float *vertices, float *normals, float *texCoords, int *indices) {
    position = glm::vec3(0.0f);
    scale = glm::vec3(1.0f);
    rotation = glm::quat(glm::vec3(0.0f));
    
    updateModelMatrix();
    
    this->numIndices = numIndices;
    this->vertices = vertices;
    this->normals = normals;
    this->texCoords = texCoords;
    this->indices = indices;
}

glm::mat4 GameObject::updateModelMatrix(){
    glm::mat4 model = glm::translate(glm::mat4(1.0f), position)
    * glm::toMat4(rotation);
    glm::scale(model, scale);
    modelMatrix = model;
    return model;
}
void GameObject::setScale(glm::vec3 newScale){
    scale = newScale;
};
void GameObject::setRotation(glm::quat newRotation){
    rotation = newRotation;
};
void GameObject::setPosition(glm::vec3 newPosition){
    position = newPosition;
};
