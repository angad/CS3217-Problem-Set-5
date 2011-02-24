//
//  HuffPuffBlock.m
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//
#import "HuffPuffBlock.h"
#import "GameController.h"

@implementation HuffPuffBlock

@synthesize flag, view, objectType, gamearea, palette, image, model, body, chipmunkObjects, rotate, pinch, tap, pan, doubleTap, shape;

-(id)initPath:(NSString*)img gamearea:(UIScrollView*)g palette:p
{
	[super init];
	objectType = kGameObjectBlock;
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	model = [[HuffPuffModel alloc]init];	

	cpFloat mass = 1.0;
	cpFloat moment = cpMomentForBox(mass, 88, 88);
	body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
	body.pos = cpv(10, 10);
	
	shape = [ChipmunkPolyShape boxWithBody:body width:30 height:130];
	shape.elasticity = 0.3;
	shape.friction = 0.3;
	shape.collisionType = [HuffPuffBlock class];
	shape.data = self;
	chipmunkObjects = [ChipmunkObjectFlatten(body, shape, nil) retain];
	
	view.tag = @"block1.png";
	view.userInteractionEnabled = YES;
	view.frame = CGRectMake(200, 10, 50, 50);
	
	//updating the model
	[model setFrame:view.frame];
	[model setTransform:view.transform];
	[model setInGamearea:NO];
	[model setPath:img];
	
	counter = 1;
	flag = 0;
	gamearea = g;
	palette = p;
	
	pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
	tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];

	[view addGestureRecognizer:tap];
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
	if (flag==0) {
		if ([gamearea pointInside:view.frame.origin withEvent:nil])
		{
			CGPoint newOrigin = [palette convertPoint:gesture.view.frame.origin toView:gamearea];
			gesture.view.frame = CGRectMake(newOrigin.x, newOrigin.y, 30, 130);
			[gamearea addSubview:gesture.view];
			[model setInGamearea:YES];
			//regenerating the block in the palette
			HuffPuffBlock *newBlock = [[HuffPuffBlock alloc] initPath:@"block1.png" gamearea:gamearea palette:palette];
			[palette addSubview:[newBlock view]];
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
	[model	setTransform:pinchGesture.view.transform];
	[super zoom:gesture];
}

-(void)tap:(UIGestureRecognizer*)gesture
{	
	NSMutableArray *images = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"block1.png"],
							  [NSString stringWithFormat:@"block2.png"],
							  [NSString stringWithFormat:@"block3.png"],
							  [NSString stringWithFormat:@"block4.png"],nil];
	UIImage *imag = [UIImage imageNamed:[images objectAtIndex:counter]];
	//NSLog(@"Tapped %@", [images objectAtIndex:counter]);
	
	[view setTag:[images objectAtIndex:counter]];
	counter++;
	if (counter == 4) {
		counter = 0;
	}
	[view setImage:imag];
}

-(void)doubleTap:(UIGestureRecognizer*)gesture
{
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
	[[self view] removeGestureRecognizer:tap];
	[[self view] removeGestureRecognizer:pinch];
	[[self view] removeGestureRecognizer:rotate];
	[[self view] removeGestureRecognizer:pan];
}

-(HuffPuffModel*)getModel{
	return [self model];
}


@end;