//
//  PhysicsManager.hpp
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-03-25.
//

#ifndef PhysicsManager_hpp
#define PhysicsManager_hpp

#include <Box2D/Box2D.h>
#include "GameObject.hpp"

#endif /* PhysicsManager_hpp */

const float MAX_TIMESTEP = 1.0f/60.0f;
const int NUM_VEL_ITERATIONS = 10;
const int NUM_POS_ITERATIONS = 3;

class PhysicsManager{
public:
    bool hitDetected;
    
    
    PhysicsManager();
    ~PhysicsManager();
    
    void Update(float elapsedTime);
    void CreateBody(const GameObject&);
    void RemoveBody(const GameObject&);
    bool WasHitDetected();
    
private:
    b2World *world;
    b2Vec2 *gravity;
    float totalElapsedTime;
    
};
