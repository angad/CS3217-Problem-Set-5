//
//  HuffPuffViewController.m
//  HuffPuff
//
//  Created by Angad Singh on 1/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffViewController.h"

@implementation HuffPuffViewController

const CGFloat backgroundWidth = 1600.0; 
const CGFloat backgroundHeight = 668.0; 
const CGFloat groundWidth = 1600; 
const CGFloat groundHeight = 100.0;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


//setup the basic game details
-(void)envSetup{
	
	//load the images into UIImage objects
	UIImage *bgImage = [UIImage imageNamed:@"back.png"]; 
	UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
	
	//place each of them in an UIImageView 
	UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
	UIImageView *ground = [[UIImageView alloc] initWithImage:groundImage];
	CGFloat groundY = gamearea.frame.size.height - groundHeight; 
	CGFloat backgroundY = groundY - backgroundHeight;
	
	//the frame property holds the position and size of the views 
	//the CGRectMake method’s arguments are : x position, y position, width, 
	//height 
	background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight); 
	ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
	
	//add these views as subviews of the gamearea. gamearea will retain them 
	[gamearea addSubview:background]; 
	[gamearea addSubview:ground];
	
	//set the content size so that gamearea is scrollable 
	//otherwise it defaults to the current window size 
	CGFloat gameareaHeight = backgroundHeight + groundHeight; 
	CGFloat gameareaWidth = backgroundWidth;
	[gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
	
	[background release];
	[ground release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad { 
	
	[super viewDidLoad];
	[self envSetup];
	
//------Game Objects initialization------//
	gc = [[GameController alloc]initWithGameArea:gamearea Palette:palette score:score];
}

-(void)save{
	[gc saveModel];
}

-(void)load{
	[gc loadModel];
}

-(void)start{	
	[palette removeFromSuperview];
	[start removeFromSuperview];
	[load removeFromSuperview];
	[reset removeFromSuperview];
	[save removeFromSuperview];
	[gamearea setFrame:CGRectMake(0, 0, 1500, 768)];
	[gc viewDidAppear:TRUE];
	[gc gameStart];

	//Game duration
	[NSTimer scheduledTimerWithTimeInterval:60.0
									 target:self
								   selector:@selector(gameOver:)
								   userInfo:nil
									repeats:NO];
	[gc removeAllGestureRecognizers];
}

-(void)gameOver:(NSTimer *)timer{
	
	//Tried adding the game over image but doesnt work :(
	
	//So at the end of the game the screen just goes blank
	UIImage *end = [UIImage imageNamed:@"gameover.png"];
	UIImageView *gameOverScreen = [[UIImageView alloc] initWithImage:end];
	gameOverScreen.frame = CGRectMake(50,50,100,200);
	[gamearea setHidden:TRUE];
	[[self view] addSubview:gameOverScreen];
}

-(void)reset{
	//reset
	[self.view addSubview:palette];
	[gc reset];
	[gc release];
	[self viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (IBAction)buttonPressed:(UIButton *)sender { 
	NSString *buttonTitle = [[sender titleLabel] text];

	if ([buttonTitle isEqual:@"Save"]) {
		[self save];
	}
	if ([buttonTitle isEqual:@"Load"]) {
		[self load];
	}
	if ([buttonTitle isEqual:@"Reset"]) {
		[self reset];
	}
	if ([buttonTitle isEqual:@"Start"]) {
		[self start];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	// Set up the display link to control the timing of the animation.
}
	
@end
