//
//  HuffPuffWind.m
//  PS3Re
//
//  Created by Angad Singh on 2/24/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffWind.h"


@implementation HuffPuffWind

@synthesize view, image, body, chipmunkObjects, shape;

-(id)initPath:(NSString *)img
{
	[super init];
	CGImageRef imageToSplit = [UIImage imageNamed:img].CGImage;
	windSprite = [[NSMutableArray alloc]init];
	
	int i =0;
	double object_y = 0;
	double object_x = 0;
	for (i=0; i<4; i++) {
		object_x = (112 * i);
		CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(object_x, object_y, 112, 104));
		[windSprite addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
	}
	
	CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, 0, 108, 108));
	image = [UIImage imageWithCGImage:partOfImageAsCG];
	view = [[UIImageView alloc] initWithImage:image];
	view.animationImages = windSprite;
	view.animationDuration = 2;
	view.animationRepeatCount = 1;
	
	cpFloat mass = 5.0;
	cpFloat moment = cpMomentForCircle(mass, 5, 10, cpv(0, 0));
	body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
	body.pos = cpv(54, 54);

	shape = [ChipmunkCircleShape circleWithBody:body radius:54 offset:cpv(0,0)];
	shape.elasticity = 0.3;
	shape.friction = 0.3;
	shape.collisionType = [HuffPuffWind class];
	shape.data = self;
	chipmunkObjects = [ChipmunkObjectFlatten(body, shape, nil) retain];
	
	view.userInteractionEnabled = YES;
	return self;
}

-(void)updatePosition{
	view.transform = body.affineTransform;
	view.center = [body world2local:body.pos];
}
@end