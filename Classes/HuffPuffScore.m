//
//  HuffPuffScore.m
//  PS3Re
//
//  Created by Angad Singh on 2/26/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffScore.h"


@implementation HuffPuffScore


@synthesize image, view, pan;

-(id)initPath:(NSString*)img
{
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	
	view.frame = CGRectMake(40, 10, 70, 30);
	return self;
}


@end
