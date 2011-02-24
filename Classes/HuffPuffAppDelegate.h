//
//  HuffPuffAppDelegate.h
//  HuffPuff
//
//  Created by Angad Singh on 1/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuffPuffViewController;

@interface HuffPuffAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HuffPuffViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HuffPuffViewController *viewController;

@end

