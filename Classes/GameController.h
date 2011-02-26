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
#import "HuffPuffPower.h"
#import "HuffPuffPigSmoke.h"
#import "HuffPuffScore.h"
#import "HuffPuffPigHealth.h"
#import "HuffPuffStorage.h"

@interface GameController : NSObject {

	CADisplayLink *displayLink;
	
	HuffPuffPig *pig;
	HuffPuffBlock *block;
	HuffPuffScore *scoreImg;
	
	UIView *palette;
	HuffPuffModel *pigM;
	HuffPuffModel *wolfM;
	HuffPuffModel *block1M;
	HuffPuffStorage *storage;

	UILabel *scoreLabel;
}

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
+(void)wolfWind:(CGRect)frame;
+(void)windStopped:(NSTimer *)theTimer;
@end
