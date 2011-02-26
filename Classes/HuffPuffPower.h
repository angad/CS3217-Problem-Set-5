//
//  HuffPuffPower.h
//  PS3Re
//
//  Created by Angad Singh on 2/25/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuffPuffGameObject.h"

@interface HuffPuffPower : HuffPuffGameObject {

	NSMutableArray *powerSprite;
	int power;
	int x;
}

@property (readonly) int power;
-(id)initPath:(NSString *)img;
@end
