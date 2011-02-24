//
//  HuffPuffPig.h
//  HuffPuff
//
//  Created by Angad Singh on 1/28/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuffPuffGameObject.h"
#import "HuffPuffModel.h"

@interface HuffPuffPig : HuffPuffGameObject <ChipmunkObject> {	
}

-(id)initPath:(NSString *)img gamearea:(UIScrollView *)g palette:(UIView*)p;
-(id)initWithView:(UIImageView*)obj gamearea:(UIScrollView*)g palette:(UIView*)p;
-(void)updatePosition;
-(void)removeGestureRecognizers;
-(void)translate:(UIGestureRecognizer *)gesture;
-(void)rotate:(UIGestureRecognizer *)gesture;
-(void)zoom:(UIGestureRecognizer *)gesture;


@end
