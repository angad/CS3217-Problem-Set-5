//
//  HuffPuffController.m
//  HuffPuff
//
//  Created by Angad Singh on 1/29/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffController.h"

@implementation HuffPuffController

-(id)init
{
	t=[[HuffPuffStorage alloc]init];
	return self;
}

-(void)save{
	[t writeToFile];
}

-(void)addObject:(CGPoint)c:(CGFloat)a{
	[t addObject:c:a];
}

@end
