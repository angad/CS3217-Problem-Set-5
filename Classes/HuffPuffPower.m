//
//  HuffPuffPower.m
//  PS3Re
//
//  Created by Angad Singh on 2/25/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffPower.h"

@implementation HuffPuffPower
@synthesize image, view, power;

-(id)initPath:(NSString*)img
{
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	powerSprite = [[NSMutableArray alloc] init];
	power = 0;
	
	CGImageRef imageToSplit = [UIImage imageNamed:img].CGImage;
	double width = 500;
	double height = 21;
	int j;
	//Power increase sprite
	for (j=0; j<75; j++) {
		width -= 5;
			CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, 0, width, height));
			[powerSprite addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
	}
	//Power decrease sprite
	for (j=0; j<75; j++) {
		width += 5;
		CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, 0, width, height));
		[powerSprite addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
	}
	
	view.frame = CGRectMake(200, 550, 500, 21);
	view.userInteractionEnabled = YES;
	
	view.animationImages = powerSprite;
	view.animationDuration = 3;
	//view.animationRepeatCount = 1;

	x = 1;  //Factor with which to increase or decrease the power
	
	//Timer callback for the animation
	[NSTimer scheduledTimerWithTimeInterval:3.0/150.0
									 target:self
								   selector:@selector(powerCounter:)
								   userInfo:nil
									repeats:YES];
	[view startAnimating];
	return self;
}

-(void)powerCounter:(NSTimer *)timer {
	
	/*if (![view isAnimating]) {
		power = 0;
		[view startAnimating];
		return;
	}*/
	
	power +=x;
	//NSLog(@"power : %i", power);
	if (power == 75) {
		x = -1;
	}
	if (power == 0) {
		x = 1;
	}
}


@end