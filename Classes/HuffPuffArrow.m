//
//  HuffPuffArrow.m
//  PS3Re
//
//  Created by Angad Singh on 2/24/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffArrow.h"


@implementation HuffPuffArrow

@synthesize image, view, pan;

-(id)initPath:(NSString*)img
{
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	
	view.frame = CGRectMake(200, 300, 74, 430);
	view.userInteractionEnabled = YES;
	
	pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(directionArrow:)];
	[view addGestureRecognizer:pan];
	
	return self;
}

-(void)directionArrow:(UIGestureRecognizer *)gesture
{
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gesture;
	if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) 
	{
		UIImageView *img = panGesture.view;
		CGPoint translation = [panGesture translationInView:img.superview];		
		
		//Transforming the X-Coordinates of translation to rotation, after dividing by a factor of 100
		img.transform = CGAffineTransformRotate(img.transform, translation.x/100);
		[panGesture setTranslation:CGPointZero inView:img.superview];
	}
}

@end
