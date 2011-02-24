//
//  GameController.h
//  PS3Re
//
//  Created by Angad Singh on 2/21/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CADisplayLink.h>

#import "HuffPuffModel.h"
#import "HuffPuffPig.h"
#import "HuffPuffWolf.h"
#import "HuffPuffBlock.h"
#import "HuffPuffWind.h"
#import "HuffPuffArrow.h"
#import "HuffPuffStorage.h"
#import "HuffPuffPower.h"

@interface GameController : NSObject {

	CADisplayLink *displayLink;
	
	HuffPuffPig *pig;
	HuffPuffWolf *wolf;
	HuffPuffBlock *block;
	
	
	UIView *palette;
	HuffPuffModel *pigM;
	HuffPuffModel *wolfM;
	HuffPuffModel *block1M;
	HuffPuffStorage *storage;
}

static HuffPuffPower *power;
static UIView *gamearea;
static HuffPuffWind *wind;
static HuffPuffArrow *arrow;
static ChipmunkSpace *space;
static NSMutableArray *models;
static NSMutableArray *objects;

-(id)initWithGameArea:(UIView *)g Palette:(UIView *)p;
+(void)addObject:(id)newObject;
-(void)viewDidAppear:(BOOL)animated;
-(void)removeAllGestureRecognizers;
-(void)saveModel;
-(void)loadModel;
-(bool)beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)separateCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)postSolveCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space;
-(void)update;

@end
