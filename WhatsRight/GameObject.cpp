//
//  GameObject.m
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-16.
//
#include "GameObject.hpp"
#include <glm/gtc/quaternion.hpp>
#include <glm/gtx/quaternion.hpp>
#include "GLESRenderer.hpp"

#define BUFFER_OFFSET(i) ((char*)NULL+ (i))

GameObject::GameObject (int numIndices, float *vertices, float *normals, float *texCoords, int *indices) {
    position = glm::vec3(0.0f);
    scale = glm::vec3(1.0f);
    rotation = glm::quat(glm::vec3(0.0f));
    this->numIndices = numIndices;

    //Generate and fill buffers
    glGenBuffers(2, vbos);

    glBindBuffer(GL_ARRAY_BUFFER, vbos[0]);
    glBufferData(GL_ARRAY_BUFFER, 24*3*sizeof(vertices[0]), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer ( 0, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), BUFFER_OFFSET(0) );
    glEnableVertexAttribArray ( 0 );

    glVertexAttrib4f ( 1, 1.0f, 0.0f, 0.0f, 1.0f );

    glBindBuffer(GL_ARRAY_BUFFER, vbos[1]);
    glBufferData(GL_ARRAY_BUFFER, 24*3*sizeof(vertices[0]), normals, GL_STATIC_DRAW);
    glVertexAttribPointer ( 2, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), BUFFER_OFFSET(0) );
    glEnableVertexAttribArray ( 2 );
    
    
    glGenBuffers(1, &idxBuf);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, idxBuf);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, numIndices*sizeof(indices[0]), indices, GL_STATIC_DRAW);
}

glm::mat4 GameObject::getModelMatrix(){
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

