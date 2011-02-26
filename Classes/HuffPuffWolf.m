//
//  HuffPuffWolf.m
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//
#import "HuffPuffWolf.h"
#import "GameController.h"

@implementation HuffPuffWolf
@synthesize flag, view, objectType, gamearea, palette, image, model, body, chipmunkObjects, rotate, pinch, tap, doubleTap, pan, shape;

-(id)initPath:(NSString*)img gamearea:(UIScrollView*)g palette:(UIView*)p
{
	//Getting wolfImage from sprite
	wolfSprite = [[NSMutableArray alloc]init];
	CGImageRef imageToSplit = [UIImage imageNamed:img].CGImage;
	double origin_x = 0;
	double origin_y = 0;
	int i, j;
	
	
	for (j=0; j<3; j++) {
		origin_y = 150*j;
		for (i=0; i<5; i++) 
		{
			origin_x =225 * i;
			CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(origin_x, origin_y, 225, 150));
			[wolfSprite addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
		}
		origin_x = 0;
	}
	
	cpFloat mass = 1.0;
	cpFloat moment = cpMomentForBox(mass, 88, 88);
	body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
	body.pos = cpv(10,10);
	
	CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, 0, 225, 150));
	image = [UIImage imageWithCGImage:partOfImageAsCG];
	view = [[UIImageView alloc] initWithImage:image];
	
	view.animationImages = wolfSprite;
	view.animationDuration = 1.5;
	view.animationRepeatCount = 1;

	model = [[HuffPuffModel alloc]init];
	
	view.userInteractionEnabled = YES;
	view.frame = CGRectMake(100, 10, 60, 60);
	palette = p;
	flag =0;
	gamearea = g;
	objectType = kGameObjectWolf;
	
	shape = [ChipmunkPolyShape boxWithBody:body width:225 height:150];
	shape.elasticity = 0.3;
	shape.friction = 0.3;
	shape.collisionType = [HuffPuffWolf class];
	shape.data = self;
	chipmunkObjects = [ChipmunkObjectFlatten( body, shape, nil) retain];
	
	//Updating the model
	[model setFrame:view.frame];
	[model setTransform:view.transform];
	[model setPath:img];

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

-(void)addTap{
	tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(animate:)];
	tap.numberOfTapsRequired = 1;
	[view addGestureRecognizer:tap];
}

-(void)removeTap{
	[[self view] removeGestureRecognizer:tap];
}

-(void)animate:(UIGestureRecognizer *)gesture
{
	[GameController wolfWind:[view frame]];
	[view startAnimating];
}

-(void)translate:(UIGestureRecognizer *)gesture
{
	if (flag==0) {
		
		if ([gamearea pointInside:view.frame.origin withEvent:nil])
		{
			[gamearea addSubview:gesture.view];
			CGPoint newOrigin = [palette convertPoint:gesture.view.frame.origin toView:gamearea];
			gesture.view.frame = CGRectMake(newOrigin.x, newOrigin.y, 225, 150);
			[GameController addObject:self];
		}
		
		rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
		pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
		doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)] ;
		doubleTap.numberOfTapsRequired = 2;
		[view addGestureRecognizer:doubleTap];
		[view addGestureRecognizer:rotate];
		[view addGestureRecognizer:pinch];
		flag = 1;
	}
	[model setFrame:gesture.view.frame];
	[model setTransform:gesture.view.transform];
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
	HuffPuffWolf *newWolf = [[HuffPuffWolf alloc] initPath:@"wolfs.png" gamearea:gamearea palette:palette];
	[palette addSubview:[newWolf view]];
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

@end;