//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>

@interface Renderer : NSObject

// To give an interface to Swift for variables, they need to be Objective-C properties. You can add additional ones, such as a toggle variable for auto-rotating a cube.
@property bool isRed;
@property bool isRotating;
@property float rotAngle;
@property float zoom;
@property bool reset;
@property float transX;
@property float transY;
@property GLKVector2 panRotation;
@property GLKVector2 position;

- (void)setup:(GLKView *)view;
- (void)loadModels;
- (void)update;
- (void)draw:(CGRect)drawRect;
- (void)rotate:(float)xAxis secondAxis:(float)yAxis thirdAxis:(float)zAxis;
- (void)translate:(float)xAxis secondAxis:(float)yAxis thirdAxis:(float)zAxis;
@end

#endif /* Renderer_h */


