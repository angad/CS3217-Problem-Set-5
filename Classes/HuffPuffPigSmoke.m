//
//  HuffPuffPigSmoke.m
//  PS3Re
//
//  Created by Angad Singh on 2/25/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffPigSmoke.h"


@implementation HuffPuffPigSmoke

@synthesize image, view;

-(id)initPath:(NSString*)img

{
	[super init];
	/*pigSprite = [[NSMutableArray alloc]init];
	double origin_x = 0;
	double origin_y = 0;
	int i, j;
	for (j=0; j<2; j++) {
		origin_y = 80*j;
		for (i=0; i<5; i++) 
		{
			origin_x =80 * i;
			NSLog(@"%f %f", origin_x, origin_y);
			CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(origin_x, origin_y, 80, 80));
			[pigSprite addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
		}
		origin_x = 0;
	}*/
	CGImageRef imageToSplit = [UIImage imageNamed:img].CGImage;
	CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, 0, 80, 80));
	image = [UIImage imageWithCGImage:partOfImageAsCG];
	view = [[UIImageView alloc] initWithImage:image];
	
	//view.animationImages = pigSprite;
	//view.animationDuration = 1.5;
	//view.animationRepeatCount = 5;
	view.frame = CGRectMake(500, 400, 80, 80);
//	[view startAnimating];
	return self;
}

+(void)generateSprite:(NSString *)img{

}

@end
