//
//  HuffPuffGameObject.m
//  HuffPuff
//
//  Created by Angad Singh on 1/29/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffGameObject.h"


@implementation HuffPuffGameObject

@synthesize view, pan, tap, pinch, rotate;


-(id)init{
	return self;
}

- (void)translate:(UIGestureRecognizer *)gesture{

// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
//          if the object is in the palette, it will be moved in the game area
	
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gesture;
	if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) 
	{
		UIImageView *img = panGesture.view;
		CGPoint translation = [panGesture translationInView:img.superview];		
		[img setCenter:CGPointMake(img.center.x + translation.x, img.center.y + translation.y)];
		[panGesture setTranslation:CGPointZero inView:img.superview];
	}
}

- (void)rotate:(UIGestureRecognizer *)gesture{
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture
	
	UIRotationGestureRecognizer *rotateGesture = (UIRotationGestureRecognizer*)gesture;
	if(rotateGesture.state == UIGestureRecognizerStateBegan || rotateGesture.state == UIGestureRecognizerStateChanged)
	{
		UIImageView *img = rotateGesture.view;
		img.transform = CGAffineTransformRotate(img.transform, rotateGesture.rotation);
		rotateGesture.rotation = 0;
	}
}

- (void)zoom:(UIGestureRecognizer *)gesture{
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture
	
	UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer *) gesture;
	if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) 
	{
		UIImageView *img = pinchGesture.view;
		img.transform = CGAffineTransformScale(img.transform, pinchGesture.scale, pinchGesture.scale);
		pinchGesture.scale = 1;
	}
}

-(void)removeGestureRecognizers
{
	[[self view] removeGestureRecognizer:tap];
	[[self view] removeGestureRecognizer:pinch];
	[[self view] removeGestureRecognizer:rotate];
	[[self view] removeGestureRecognizer:pan];
}

-(HuffPuffModel*)getModel{
	return [self model];
}


@end
