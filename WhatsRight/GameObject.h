//
//  GameObject.h
//  WhatsRight
//
//  Created by Evano Hirabe on 2022-02-16.
//

#ifndef GameObject_h
#define GameObject_h
#import <GLKit/GLKit.h>

@interface GameObject : NSObject

// To give an interface to Swift for variables, they need to be Objective-C properties. You can add additional ones, such as a toggle variable for auto-rotating a cube.
@property GLuint vbo;
@property GLuint texture;
@property GLint[] uniforms;

@property GLKVector3 position;
@property GLKVector3 scale;
@property GLKQuaternion rotation;

- (GLKMatrix4)modelMatrix;
- (void)setScale:(GLKVector3)scale;
- (void)setRotation:(GLKQuaternion)rotation;
- (void)setPosition:(GLKVector3)position;
@end

#endif /* GameObject_h */
