//
//  HuffPuffViewController.h
//  HuffPuff
//
//  Created by Angad Singh on 1/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuffPuffPig.h"
#import "HuffPuffWolf.h"
#import "HuffPuffBlock.h"
#import "GameController.h"


@interface HuffPuffViewController : UIViewController {
	IBOutlet UIScrollView *gamearea;
	IBOutlet UIView *palette;
	IBOutlet UIButton *start;
	IBOutlet UIButton *reset;
	IBOutlet UIButton *load;
	IBOutlet UIButton *save;
	
	IBOutlet UILabel *score;
	
	GameController *gc;
}

- (IBAction)buttonPressed:(UIButton *)sender;

@end