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

	//CGPoint xy;
//	double angle;
//	double scale;
//	double height;
//	double width;
//	double mass;
//	
//	BOOL inGamearea;
}

//@property (readonly) CGPoint xy;
//@property (readonly) double angle;
//@property (readonly) double scale;
//@property (readonly) double height;
//@property (readonly) double width;
//@property (readonly) double mass;
//@property (readonly) BOOL inGamearea;
@property (assign) NSString *path;
@property (assign) CGRect frame;
@property (assign) CGAffineTransform transform;

@end
