//
//  RootViewController.m
//  toddlermaze
//
//  Created by Jonny Brannum on 1/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"

@implementation RootViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
     NSLog(@"RootViewController----initWithNibName----");
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
     NSLog(@"RootViewController----viewDidLoad----");
	[super viewDidLoad];  
 }

-(BOOL)shouldAutorotate{
    NSLog(@"RootViewController--------shouldAutorotate");
    NSLog(@"RootViewController-----shouldAutorotate--self.view.bounds.size width:%f,height:%f",self.view.bounds.size.width,self.view.bounds.size.height);
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
     NSLog(@"RootViewController--------supportedInterfaceOrientations");
    NSLog(@"RootViewController-----supportedInterfaceOrientations--self.view.bounds.size width:%f,height:%f",self.view.bounds.size.width,self.view.bounds.size.height);
    return UIInterfaceOrientationMaskLandscapeLeft;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
     NSLog(@"RootViewController--------shouldAutorotateToInterfaceOrientation");
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

