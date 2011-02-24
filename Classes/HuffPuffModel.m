//
//  HuffPuffModel.m
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffModel.h"

@implementation HuffPuffModel

@synthesize xy, width, height, frame, angle, scale, mass, transform, path, inGamearea;

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self)
	{
		frame = [decoder decodeCGRectForKey:@"frame"];
		transform = [decoder decodeCGAffineTransformForKey:@"transform"];
		path = [decoder decodeObjectForKey:@"path"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeCGRect:frame forKey:@"frame"];
	[coder encodeObject:path forKey:@"path"];
	[coder encodeCGAffineTransform:transform forKey:@"transform"];
}


@end
