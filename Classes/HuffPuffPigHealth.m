//
//  HufPuffPigHealth.m
//  PS3Re
//
//  Created by Angad Singh on 2/26/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffPigHealth.h"


@implementation HuffPuffPigHealth

@synthesize image, view;

-(id)initPath:(NSString*)img
{
	image = [UIImage imageNamed:img];
	view = [[UIImageView alloc] initWithImage:image];
	
	view.frame = CGRectMake(10, 10, 21, 155);
	
	return self;
}
@end
