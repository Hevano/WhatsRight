//
//  GameObject.m
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-16.
//
#import "GameObject.h"
#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GameObject () {
    
}

@end

@implementation GameObject

@synthesize vbo;
@synthesize texture;

@synthesize position;
@synthesize scale;
@synthesize rotation;

- (GLKMatrix4)modelMatrix{
    
}
- (void)setScale:(GLKVector3)scale{
    
}
- (void)setRotation:(GLKQuaternion)rotation{
    
}
- (void)setPosition:(GLKVector3)position{
    
}
