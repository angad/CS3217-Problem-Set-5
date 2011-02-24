//
//  GameController.m
//  PS3Re
//
//  Created by Angad Singh on 2/21/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "GameController.h"


@implementation GameController

static NSString *borderType = @"borderType";

-(id)initWithGameArea:(UIView*)g Palette:(UIView*)p
{	
	storage = [[HuffPuffStorage alloc] init];
	objects = [[NSMutableArray alloc] init];
	models = [[NSMutableArray alloc] init];
	gamearea = g;
	palette = p;
	
	[gamearea setBackgroundColor:([UIColor redColor])];
	
	int i;
	for (i=0; i<objects.count; i++) 
	{
		[[[objects objectAtIndex:i] view] removeFromSuperview];
	}
	
	pig = [[HuffPuffPig alloc] initPath:@"pig.png" gamearea:gamearea palette:palette];
	block = [[HuffPuffBlock alloc]initPath:@"block1.png" gamearea:gamearea palette:palette];
	wolf = [[HuffPuffWolf alloc]initPath:@"wolfs.png" gamearea:gamearea palette:palette];
	
	
	
	[palette addSubview:[pig view]];
	[palette addSubview:[block view]];
	[palette addSubview:[wolf view]];
	return self;
}

-(void)removeAllGestureRecognizers
{	
	[pig removeGestureRecognizers];
	[wolf removeGestureRecognizers];
	[block removeGestureRecognizers];
}

-(void)gameStart{
	space = [[ChipmunkSpace alloc] init];
	//NSLog(@"%f %f %f %f", gamearea.frame.origin.x, gamearea.frame.origin.y, gamearea.frame.size.width, gamearea.frame.size.height);
	//NSLog(@"%f %f %f %f", gamearea.bounds.origin.x, gamearea.bounds.origin.y, gamearea.bounds.size.width, gamearea.bounds.size.height);
	CGRect spaceBounds = CGRectMake(0, 0, 1024, 480);
	[space addBounds:spaceBounds thickness:10.0f elasticity:1.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	space.gravity = cpvmult(cpv(0.0, 1.0), 100.0f);
	
	power = [[HuffPuffPower alloc] initPath:@"breath-bar.png"];
	arrow = [[HuffPuffArrow alloc]initPath:@"direction-arrow.png"];
	
	[gamearea addSubview:[arrow view]];
	[gamearea addSubview:[power view]];
	
	int i;
	[wolf gameSetup];
	for (i=0; i<objects.count; i++) {
		[space add:[objects objectAtIndex:i]];
		//NSLog(@"%@", [[[objects objectAtIndex:i] view] tag]);
	}
}

+(void)addObject:(id)newObject{
	[objects addObject:newObject];
}

+(void)wolfWind:(CGRect)frame
{
	wind = [[HuffPuffWind alloc] initPath:@"windblow.png"];
	frame.origin.x += 80;
	frame.size.width = 108;
	frame.size.height = 108;
	
	[[wind view] setFrame:frame];

	//Get impulse direction from arrow
	[wind body].pos = [wind view].center;
	CGFloat radians = atan2f(arrow.view.transform.b, arrow.view.transform.a); 
	//CGFloat degrees = (radians * 180 / M_PI);

	//getting power from power meter
	[[wind body] applyImpulse: cpvmult(cpv(cos(radians), -sin(radians)), power.power * 50) offset:cpv(0,0)];

	[space add:wind];
	[gamearea addSubview:[wind view]];
	[[wind view] startAnimating];
	[NSTimer scheduledTimerWithTimeInterval:1.0
									 target:self
								   selector:@selector(windStopped:)
								   userInfo:nil
									repeats:NO];
}

+ (void)windStopped:(NSTimer*)theTimer
{
	[[wind view] removeFromSuperview];
	[space remove:wind];
}

-(void)reset{
	int i;
	for (i=0; i<objects.count; i++) 
	{
		[space remove:[objects objectAtIndex:i]];
	}	
	[objects release];
	objects = [[NSMutableArray alloc] init];
}

-(void)saveModel{
	int i;
	HuffPuffModel *model;
	for (i=0; i<objects.count; i++) 
	{
		model = [[objects objectAtIndex:i]getModel];
		[models addObject: model];
	}
	
	NSString *fileName = @"save";
	BOOL a = [HuffPuffStorage writeToFile:models :fileName];
	NSLog(@"%i", a);
}

-(void)loadModel{
	NSString *fileName = @"save";
	models = [HuffPuffStorage loadFile:fileName];
}

- (bool)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
	return TRUE;
}

- (void)postSolveCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	if(!cpArbiterIsFirstContact(arbiter)) return;
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
}

- (void)separateCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
}

-(void)viewDidAppear:(BOOL)animated{
	// Set up the display link to control the timing of the animation.
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	displayLink.frameInterval = 1;
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)update {
	// Step (simulate) the space based on the time since the last update.
	cpFloat dt = displayLink.duration*displayLink.frameInterval;
	[space step:dt];
	
	// This sets the position and rotation of the button to match the rigid body.
	int i;
	for (i=0; i<objects.count; i++) {
		[[objects objectAtIndex:i] updatePosition];
	}
	[wind updatePosition];
}

@end
