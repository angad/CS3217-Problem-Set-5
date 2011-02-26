//
//  HuffPuffWind.h
//  PS3Re
//
//  Created by Angad Singh on 2/24/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuffPuffGameObject.h"

@interface HuffPuffWind : HuffPuffGameObject <ChipmunkObject> {
	NSMutableArray *windSprite;

}
-(void)updatePosition;
-(id)initPath:(NSString *)img;
@end
