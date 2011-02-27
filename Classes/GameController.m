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
NSString *level;
static int score;
static int windReset = 0;
static double pigHealth;
static int pigDead;
static int blocksCount;
static double strawStrength;
static double woodStrength;
static double metalStrength;
static double stoneStrength;
static HuffPuffWolf *wolf;

static UIView *gamearea;
static HuffPuffPower *power;
static HuffPuffWind *wind;
static HuffPuffPigSmoke *smoke;
static HuffPuffPigHealth *health;

static HuffPuffArrow *arrow;
ChipmunkSpace *space;
static NSMutableArray *models;
static NSMutableArray *objects;

-(id)initWithGameArea:(UIView*)g Palette:(UIView*)p score:(UILabel*)s
{	
	score = 0;
	scoreLabel = s;
	scoreLabel.text = [NSString stringWithFormat:@"%i", score];
	
	pigDead = 0;
	storage = [[HuffPuffStorage alloc] init];
	objects = [[NSMutableArray alloc] init];
	models = [[NSMutableArray alloc] init];
	gamearea = g;
	palette = p;
	blocksCount = 0;
	
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

-(void)updateScore{
	scoreLabel.text = [NSString stringWithFormat:@"%i", score];	
}

-(void)removeAllGestureRecognizers
{	
	//Removes all Gesture recongnizers from the objects
	[pig removeGestureRecognizers];
	[wolf removeGestureRecognizers];
	[block removeGestureRecognizers];
}

-(void)gameStart{
	//Game Setup
	//Physics Engine Initialization
	//Collision Handlers initialization
	//Add static game elemnts - power and direction
	//Add objects to physics space
	
	pigHealth = 800;
	strawStrength = 200;
	woodStrength = 600;
	metalStrength = 800;
	stoneStrength = 1000;
	health = [[HuffPuffPigHealth alloc]initPath:@"health.png"];
	[gamearea addSubview:[health view]];
	
	scoreImg = [[HuffPuffScore alloc] initPath:@"score.png"];
	[gamearea addSubview:[scoreImg view]];
	
	space = [[ChipmunkSpace alloc] init];
	CGRect spaceBounds = CGRectMake(0, 0, 1024, 648);
	[space addBounds:spaceBounds thickness:10.0f elasticity:1.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	space.gravity = cpvmult(cpv(0.0, 1.0), 100.0f);
	int i;
	
	//Collision Handler for wind and Pig
	[space addCollisionHandler:self
						 typeA:[HuffPuffPig class] typeB:[HuffPuffWind class]
						 begin:@selector(beginCollision:space:)
					  preSolve:nil
					 postSolve:@selector(windCollidesPig:space:)
					  separate:@selector(separateCollision:space:)
	 ];
	
	//Collision handler for wind and border
	[space addCollisionHandler:self
						 typeA:[HuffPuffWind class] typeB:borderType
						 begin:@selector(beginCollision:space:)
					  preSolve:nil
					 postSolve:@selector(windPassesThroughBorder:space:)
					  separate:@selector(separateCollision:space:)
	 ];
	
	for (i=0; i<objects.count; i++) {
		
		//Adding Collision Handlers for Pig and all types of blocks
		if ([[[objects objectAtIndex:i] class] isEqual:[HuffPuffBlock class]]) 
		{
			[space addCollisionHandler:self
								 typeA:[HuffPuffPig class] typeB:[[[objects objectAtIndex:i] shape] collisionType]
								 begin:@selector(beginCollision:space:)
							  preSolve:nil
							 postSolve:@selector(blockCollidesPig:space:)
							  separate:@selector(separateCollision:space:)
			 ];
		
		//Adding collision handler for wind and all types of blocks
			[space addCollisionHandler:self
								 typeA:[HuffPuffWind class] typeB:[[[objects objectAtIndex:i] shape] collisionType]
								 begin:@selector(beginCollision:space:)
							  preSolve:nil
							 postSolve:@selector(blockCollidesWind:space:)
							  separate:@selector(separateCollision:space:)
			 ];
		}
	}
	
	power = [[HuffPuffPower alloc] initPath:@"breath-bar.png"];
	arrow = [[HuffPuffArrow alloc]initPath:@"direction-arrow.png"];
	
	[gamearea addSubview:[arrow view]];
	[gamearea addSubview:[power view]];
	
	[wolf addTap];
	[self addObjectsSpace];
}

-(void)addObjectsSpace{
	int i;
	for (i=0; i<objects.count; i++) {
		[space addPostStepCallback:self selector:@selector(addObjToSpace:) key:[objects objectAtIndex:i]];
	}
}

-(void)addObjToSpace:(id)obj
{
	[space add:obj];
}

+(void)addObject:(id)newObject{
	//add an object to the game
	if ([[newObject class] isEqual:[HuffPuffBlock class]]) {
		blocksCount++;
		NSString *obj = [NSString stringWithFormat:@"%i", blocksCount];
		[newObject dataset:obj];
	}
 
	[objects addObject:newObject];
}

+(void)wolfWind:(CGRect)frame
{
	//Wolf releases wind
	//Adds wind to Physics engine space
	//Gives wind an impulse and direction based on the arrow and power meter
	
	wind = [[HuffPuffWind alloc] initPath:@"windblow.png"];
	frame.origin.x += 80;
	frame.size.width = 108;
	frame.size.height = 108;
	
	[[wind view] setFrame:frame];

	//Get impulse direction from arrow
	[wind body].pos = [wind view].center;
	CGFloat radians = atan2f(arrow.view.transform.b, arrow.view.transform.a); 

	//getting power from power meter
	[[wind body] applyImpulse: cpvmult(cpv(cos(radians), -sin(radians)), power.power * 50) offset:cpv(0,0)];

	//Add wind to physics engine
	[space add:wind];
	windReset = 0;
	//Add wind to view
	[gamearea addSubview:[wind view]];
	
	//Startanimating
	[[wind view] startAnimating];
	[wolf removeTap];
	//Timer callback for the wind's existance
	[NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(windStopped:)
								   userInfo:nil
									repeats:NO];
}

+ (void)windStopped:(NSTimer*)theTimer
{
	//Removes wind from physics engine and view
	if (windReset!=1) {
		[[wind view] removeFromSuperview];
		[space remove:wind];
		[wolf addTap];
		windReset = 0;
	}
}

-(void)updateHealth{
	double height = 155.0 / 800.0 * pigHealth;
	[[health view] setFrame:CGRectMake(10, 10, 21, height)];
}

-(void)removeBlock:(ChipmunkShape*)shape
{
	int i;
	for (i=0; i<objects.count; i++) {
		if([[[objects objectAtIndex:i] shape] isEqual:shape])
		{
			[space addPostStepRemoval:[objects objectAtIndex:i]];
			[[[objects objectAtIndex:i] view] removeFromSuperview];
			[objects removeObjectAtIndex:i];
		}
	}
}

- (bool)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
	return TRUE;
}

- (void)windCollidesPig:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	
	//When wind collides with Pig
	
	if(!cpArbiterIsFirstContact(arbiter)) return;
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	//smoke.view.frame = pig.view.frame;
	if (impulse > pigHealth) {
		score++;
		[self updateScore];
		//[space addPostStepCallback:self selector:@selector(removeObjFromSpace:) key:pig];
		[space addPostStepRemoval:pig];
		[[pig view] removeFromSuperview];
		pigDead = 1;
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(nextLevel:)
									   userInfo:nil
										repeats:NO];
		[self updateHealth];
	}
	else
	{
		pigHealth -=impulse;
		[self updateHealth];
	}
}

-(void)removeObjFromSpace:(id)obj
{
	[space remove:obj];
}

-(void)windPassesThroughBorder:(cpArbiter*)arbiter space:(ChipmunkSpace*)space{
	
	//When wind collides with the border, it should die
	if(!cpArbiterIsFirstContact(arbiter)) return;
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	
	cpShape *a, *b;
	cpArbiterGetShapes(arbiter, &a, &b);

	NSMutableString *type = b->collision_type;
	
	if ([type isEqual:borderType]) {
		[[wind view] removeFromSuperview];
		[space addPostStepRemoval:wind];
		[wolf addTap];
		windReset = 1;
	}
}

- (void)blockCollidesPig:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	if(!cpArbiterIsFirstContact(arbiter)) return;
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	
	cpShape *a, *b;
	cpArbiterGetShapes(arbiter, &a, &b);

	if (impulse > pigHealth) {
		score++;
		[self updateScore];
		[space addPostStepRemoval:pig];
		[[pig view] removeFromSuperview];
		pigDead = 1;
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(nextLevel:)
									   userInfo:nil
										repeats:NO];
		[self updateHealth];
	}
	
	NSMutableString *type = b->collision_type;
	//NSString *t = [type substringToIndex:9];
	if ([type isEqual:@"block1.png"]) {
		//straw object
		impulse/=2.0;
	}
	
	if ([type isEqual:@"block2.png"]) {
		//wood block
	}
	
	if ([type isEqual:@"block3.png"]) {
		//metal block
		impulse*=1.5;
	}
	
	if ([type isEqual:@"block4.png"]) {
		//stone block
		impulse*=2;
	}
	pigHealth -=impulse;

	[self updateHealth];
}

- (void)blockCollidesWind:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	if(!cpArbiterIsFirstContact(arbiter)) return;

	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	cpShape *a, *b;
	cpArbiterGetShapes(arbiter, &a, &b);
	
	NSMutableString *type = b->collision_type;
	if ([type isEqual:@"block1.png"]) {
		//straw block
		if (impulse > strawStrength) {
			[self removeBlock:b->data];
			cpVect t = [[wind body] vel];
			//wind's speed decreases by half
			[[wind body] setVel:cpvsub(t, cpvmult(t, 0.5))];
		}
	}
	
	if ([type isEqual:@"block2.png"]) {
		//wood block
		if (impulse > woodStrength) {
			[self removeBlock:b->data];
			cpVect t = [[wind body] vel];
			//wind's speed decreases by 0.7
			[[wind body] setVel:cpvsub(t, cpvmult(t, 0.7))];
		}
		impulse*=1;
	}
	
	if ([type isEqual:@"block3.png"]) {
		//metal block
		if (impulse > metalStrength) {
			[self removeBlock:b->data];
			cpVect t = [[wind body] vel];
			//wind's speed decreases by 0.8
			[[wind body] setVel:cpvsub(t, cpvmult(t, 0.8))];
		}
		impulse*=2;
	}
	
	if ([type isEqual:@"block4.png"]) {
		//stone block
		if (impulse > stoneStrength) {
			[self removeBlock:b->data];
			cpVect t = [[wind body] vel];
			//wind's speed decreases by 0.9
			[[wind body] setVel:cpvsub(t, cpvmult(t, 0.9))];
		}
	}
}

-(void)nextLevel:(NSTimer*)timer{
	//Loads the next level for the game
	//[space remove:pig];

	//I am currently re-loading the level that the user just created.
	//When I have more time, I will design levels in the level designer,
	//and save the levels and their names in an NSArray
	//then load the models based on the names in the NSArray whenever the pig dies
	[self loadNextLevel:level];
	
	//Resetting the poor pig
	pigDead = 0;
	pigHealth = 800;
	[self updateHealth];
}


-(void)loadNextLevel:(NSString*)fileName
{
	models = [HuffPuffStorage loadFile:fileName];
	int i;
	HuffPuffModel *model;
	
	for (i=0; i<objects.count; i++)
	{
		if (![[[objects objectAtIndex:i] class] isEqual:[HuffPuffPig class]]) {
			[[[objects objectAtIndex:i] view] removeFromSuperview];
			[space addPostStepRemoval:[objects objectAtIndex:i]];
		}
	}
	
	[objects release];
	objects = [[NSMutableArray alloc] init];
	[objects addObject:wolf];
	[gamearea addSubview:[wolf view]];
	
	for (i=0; i<models.count; i++) 
	{
		model = [models objectAtIndex:i];
		
		if ([model.path isEqual:@"wolfs.png"]) {
			continue;
		}
		
		if ([model.path isEqual:@"pig.png"]) 
		{
			[pig release];
			pig = [[HuffPuffPig alloc] initPath:model.path gamearea:gamearea palette:palette];
			pig.view.frame = model.frame;
			[[pig body] setPos:cpv(pig.view.center.x, pig.view.center.y)];
			pig.view.transform = model.transform;
			[gamearea addSubview:[pig view]];
			[objects addObject:pig];
		}
		else 
		{
			HuffPuffBlock* newBlock = [[HuffPuffBlock alloc] initPath:model.path gamearea:gamearea palette:palette];
			newBlock.view.frame = model.frame;
			[[newBlock body] setPos:cpv(newBlock.view.center.x, newBlock.view.center.y)];
			newBlock.view.transform = model.transform;
			[gamearea addSubview:[newBlock view]];
			[objects addObject:newBlock];
		}
	}
	[self addObjectsSpace];
}

-(void)setLevel:(NSString*)l
{
	level = l;
	[level retain];
}


- (void)separateCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
}

-(void)viewDidAppear:(BOOL)animated{
	//Set up the display link to control the timing of the animation.
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	displayLink.frameInterval = 1;
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)update {
	//Step (simulate) the space based on the time since the last update.
	cpFloat dt = displayLink.duration*displayLink.frameInterval;
	[space step:dt];
	
	//This sets the position and rotation of the button to match the rigid body.
	int i;
	for (i=0; i<objects.count; i++) {
		[[objects objectAtIndex:i] updatePosition];
	}
	[wind updatePosition];
	smoke.view.frame = pig.view.frame;
}

//Level Designer Button responders
-(void)reset{
	int i;
	for (i=0; i<objects.count; i++) 
	{
		[space remove:[objects objectAtIndex:i]];
	}	
	[objects release];
	objects = [[NSMutableArray alloc] init];
}

-(void)saveModel:(NSString*)fileName
{
	int i;
	HuffPuffModel *model;
	models = [[NSMutableArray alloc] init];
	for (i=0; i<objects.count; i++) 
	{
		model = [[objects objectAtIndex:i]getModel];
		[models addObject: model];
	}
	
	[HuffPuffStorage writeToFile:models:fileName];
}

-(void)loadModel:(NSString*)fileName
{
	models = [HuffPuffStorage loadFile:fileName];
	int i;
	HuffPuffModel *model;
	
	for (i=0; i<objects.count; i++)
	{
		[[[objects objectAtIndex:i] view] removeFromSuperview];
		[space addPostStepRemoval:[objects objectAtIndex:i]];
	}
	
	[objects release];
	objects = [[NSMutableArray alloc] init];
	[objects addObject:wolf];
	
	for (i=0; i<models.count; i++) 
	{
		model = [models objectAtIndex:i];
		
		if ([model.path isEqual:@"wolfs.png"]) {
			continue;
		}
		
		if ([model.path isEqual:@"pig.png"]) 
		{
			[pig release];
			pig = [[HuffPuffPig alloc] initPath:model.path gamearea:gamearea palette:palette];
			pig.view.frame = model.frame;
			[[pig body] setPos:cpv(pig.view.center.x, pig.view.center.y)];
			pig.view.transform = model.transform;
			[gamearea addSubview:[pig view]];
			[objects addObject:pig];
		}
		else 
		{
			HuffPuffBlock* newBlock = [[HuffPuffBlock alloc] initPath:model.path gamearea:gamearea palette:palette];
			newBlock.view.frame = model.frame;
			[[newBlock body] setPos:cpv(newBlock.view.center.x, newBlock.view.center.y)];
			newBlock.view.transform = model.transform;
			[gamearea addSubview:[newBlock view]];
			[objects addObject:newBlock];
		}
	}
	[self addObjectsSpace];
}

@end
