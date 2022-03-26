//
//  PhysicsManager.cpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-03-25.
//

#include "PhysicsManager.hpp"

class CContactListener : public b2ContactListener
{
public:
    PhysicsManager *manager;
    void BeginContact(b2Contact* contact) {};
    void EndContact(b2Contact* contact) {};
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        b2WorldManifold worldManifold;
        contact->GetWorldManifold(&worldManifold);
        b2PointState state1[2], state2[2];
        b2GetPointStates(state1, state2, oldManifold, contact->GetManifold());
        if (state2[0] == b2_addState)
        {
            manager->hitDetected = true;
        }
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {};
};

PhysicsManager::PhysicsManager(){
    gravity = new b2Vec2(0, 0);
    world = new b2World(*gravity);
    totalElapsedTime = 0;
    
};
PhysicsManager::~PhysicsManager(){
    if(gravity) delete gravity;
    if(world) delete world;
};

void PhysicsManager::Update(float elapsedTime){
    if (world)
        {
            while (elapsedTime >= MAX_TIMESTEP)
            {
                world->Step(MAX_TIMESTEP, NUM_VEL_ITERATIONS, NUM_POS_ITERATIONS);
                elapsedTime -= MAX_TIMESTEP;
            }
            
            if (elapsedTime > 0.0f)
            {
                world->Step(elapsedTime, NUM_VEL_ITERATIONS, NUM_POS_ITERATIONS);
            }
        }
};

void PhysicsManager::RemoveBody(const GameObject& g){
    //world->DestroyBody(g.body)
};

void PhysicsManager::CreateBody(const GameObject& g){
    
}

bool PhysicsManager::WasHitDetected(){
    if(hitDetected){
        hitDetected = false;
        return true;
    } else{
        return false;
    }
}