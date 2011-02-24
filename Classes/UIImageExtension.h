//
//  UIImageExtension.h
//  HuffPuff
//
//  Created by Angad Singh on 1/30/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (NSCoding)
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end

