//
//  UIImageExtension.m
//  HuffPuff
//
//  Created by Angad Singh on 1/30/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "UIImageExtension.h"


@implementation UIImage (NSCoding)
- (id)initWithCoder:(NSCoder *)decoder {
	NSData *pngData = [decoder decodeObjectForKey:@"PNGRepresentation"];
	[self autorelease];
	self = [[UIImage alloc] initWithData:pngData];
	return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:UIImagePNGRepresentation(self) forKey:@"PNGRepresentation"];
}
@end