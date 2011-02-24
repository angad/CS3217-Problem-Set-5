//
//  HuffPuffGameObject.h
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//

//  Abstract class
//  GameObject.h
// 
// You can add your own prototypes in this file
//

#import <UIKit/UIKit.h>
#import "HuffPuffModel.h"
#import "ObjectiveChipmunk.h"

// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

@interface HuffPuffGameObject : UIViewController {
}

@property (nonatomic, readonly) GameObjectType objectType;

//Chipmunk
@property (readonly) ChipmunkBody *body;
@property (readonly) NSSet *chipmunkObjects;
@property (readonly) int touchShapes;
@property (readonly) ChipmunkShape *shape;

//GameObject's resources
@property (readonly) UIImageView *view;
@property (readonly) UIScrollView *gamearea;
@property (readonly) UIView *palette;
@property (readonly) UIImage *image;
@property (readonly) HuffPuffModel *model;

//Gesture recognizers
@property (readonly) UIRotationGestureRecognizer *rotate;
@property (readonly) UIPinchGestureRecognizer *pinch;
@property (readonly) UITapGestureRecognizer *tap;
@property (readonly) UITapGestureRecognizer *doubleTap;
@property (readonly) UIPanGestureRecognizer *pan;

@property (readonly) int flag;	

- (void)translate:(UIGestureRecognizer *)gesture;
// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
//          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIGestureRecognizer *)gesture;
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIGestureRecognizer *)gesture;
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture

// You will need to define more methods to complete the specification. 

@end