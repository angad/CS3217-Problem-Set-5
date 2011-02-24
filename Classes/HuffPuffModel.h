//
//  HuffPuffModel.h
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HuffPuffModel : NSObject {
	
	CGRect frame;
	CGAffineTransform transform;
	NSString *path;

	CGPoint xy;
	double angle;
	double scale;
	double height;
	double width;
	double mass;

	BOOL inGamearea;
}

@property CGPoint xy;
@property double angle;
@property double scale;
@property double height;
@property double width;
@property double mass;
@property CGRect frame;
@property CGAffineTransform transform;
@property BOOL inGamearea;
@property NSString *path;

@end
