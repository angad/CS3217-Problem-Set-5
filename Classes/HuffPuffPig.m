//
//  HuffPuffPig.m
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//
#import "HuffPuffPig.h"
#import "GameController.h"

@implementation HuffPuffPig

@synthesize flag, view, objectType, gamearea, palette, image, model, body, chipmunkObjects, rotate, pinch, tap, pan, doubleTap, shape;

-(id)initPath:(NSString*)img gamearea:(UIScrollView*)g palette:(UIView*)p
{
	//initializes Pig with UIImage, View and Model
	[super init];
	objectType = kGameObjectPig;
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	model = [[HuffPuffModel alloc]init];
	
	//Physics Engine
	cpFloat mass = 1.0;
	cpFloat moment = cpMomentForBox(mass, 88, 88);
	body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
	
	shape = [ChipmunkPolyShape boxWithBody:body width:88 height:88];
	shape.elasticity = 0.3;
	shape.friction = 1.0;
	shape.collisionType = [HuffPuffPig class];
	shape.data = self;
	chipmunkObjects = [ChipmunkObjectFlatten(body, shape, nil) retain];

	//using tag to store objecttype information
	view.userInteractionEnabled = YES;
	view.frame = CGRectMake(10, 10, 55, 55);

	//updating the model
	[model setFrame:view.frame];
	[model setTransform:view.transform];
	[model setInGamearea:NO];
	[model setPath:img];
	
	flag = 0;
	gamearea = g;
	palette = p;
	
	//attaching Pan Gesture recognizer
	pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
	[view addGestureRecognizer:pan];
	
	return self;
}

-(id)initWithView:(UIImageView*)obj gamearea:(UIScrollView*)g palette:(UIView*)p
{
	[super init];
	
	view = obj;
	view.userInteractionEnabled = YES;
	[model setFrame:view.frame];
	
	flag = 0;
	gamearea = g;
	palette = p;
	
	pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
	[view addGestureRecognizer:pan];
	
	return self;
}

-(void)translate:(UIGestureRecognizer *)gesture
{
	if (flag==0)
	{
		if ([gamearea pointInside:view.frame.origin withEvent:nil])
		{
			//when the object enters the gamearea, add it to that
			CGPoint newOrigin = [palette convertPoint:gesture.view.frame.origin toView:gamearea];
			view.frame = CGRectMake(newOrigin.x, newOrigin.y, 88, 88);
			body.pos = view.center;
			[gamearea addSubview:view];
			[model setInGamearea:YES];
			[GameController addObject:self];
		}
		
		rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
		pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
		doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
		doubleTap.numberOfTapsRequired = 2;
		[view addGestureRecognizer:doubleTap];
		[view addGestureRecognizer:rotate];
		[view addGestureRecognizer:pinch];
		
		flag = 1;
	}
	[model setFrame: view.frame];
	[model setTransform:view.transform];
	[super translate:gesture];
	body.pos = view.center;
}

-(void)rotate:(UIGestureRecognizer *)gesture
{
	UIRotationGestureRecognizer *rotateGesture = (UIRotationGestureRecognizer*)gesture;
	[model setTransform:rotateGesture.view.transform];
	CGFloat radians = atan2f(view.transform.b, view.transform.a); 
	body.angle = radians;
	[super rotate:gesture];
}

-(void)zoom:(UIGestureRecognizer *)gesture
{
	UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer*)gesture;
	[model setTransform:pinchGesture.view.transform];
	[super zoom:gesture];
}

-(void)doubleTap:(UIGestureRecognizer*)gesture
{
	HuffPuffPig *newPig = [[HuffPuffPig alloc] initPath:@"pig.png" gamearea:gamearea palette:palette];
	[palette addSubview:[newPig view]];
	[gesture.view removeFromSuperview];
}

-(void)updatePosition{
	[model setTransform:body.affineTransform];
	view.transform = body.affineTransform;
	view.center = [body world2local:body.pos];
}

-(void)removeGestureRecognizers
{
	[[self view] removeGestureRecognizer:doubleTap];
	[[self view] removeGestureRecognizer:pinch];
	[[self view] removeGestureRecognizer:rotate];
	[[self view] removeGestureRecognizer:pan];
}

-(HuffPuffModel*)getModel{
	return [self model];
}

@end
