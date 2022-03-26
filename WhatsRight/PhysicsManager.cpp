//
//  PhysicsManager.cpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-03-25.
//

#include "PhysicsManager.hpp"

PhysicsManager::PhysicsManager(){
    gravity = new b2Vec2(0, 0);
    world = new b2World(*gravity);
};
PhysicsManager::~PhysicsManager(){
    if(gravity) delete gravity;
    if(world) delete world;
};

void PhysicsManager::Update(float elapsedTime){
    
};

void PhysicsManager::RemoveBody(const GameObject&){
    
};

void PhysicsManager::CreateBody(const GameObject&){
    
}
