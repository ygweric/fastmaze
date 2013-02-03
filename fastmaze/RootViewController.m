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
@synthesize state = _state, adWhirlView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
     NSLog(@"RootViewController----initWithNibName----");
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
        
        self.state = kGameStatePlaying;
	}
	return self;
 }
 


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
     NSLog(@"RootViewController----viewDidLoad----");
     //1

     //2
     self.adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
     //3
     self.adWhirlView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
     
     //4
     [adWhirlView updateAdWhirlConfig];
     //5
     CGSize adSize = [adWhirlView actualAdSize];
     //6
     CGSize winSize = [CCDirector sharedDirector].winSize;
     //7
     self.adWhirlView.frame = CGRectMake((winSize.width/2)-(adSize.width/2),winSize.height-adSize.height,winSize.width,adSize.height);
     //8
     self.adWhirlView.clipsToBounds = YES;
     //9
     [self.view addSubview:adWhirlView];
     //10
     [self.view bringSubviewToFront:adWhirlView];
     //11
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
    NSLog(@"RootViewController-------viewDidUnload----");
    if (adWhirlView) {
        [adWhirlView removeFromSuperview];
        [adWhirlView replaceBannerViewWith:nil];
        [adWhirlView ignoreNewAdRequests];
        [adWhirlView setDelegate:nil];
        self.adWhirlView = nil;
    }
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.adWhirlView.delegate = nil;
    self.adWhirlView = nil;
    
    [super dealloc];
}
#pragma mark adwhirl

- (NSString *)adWhirlApplicationKey {
    return _MY_AD_WHIRL_APPLICATION_KEY;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


-(void)adjustAdSize {
	//1
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.2];
	//2
	CGSize adSize = [adWhirlView actualAdSize];
	//3
	CGRect newFrame = adWhirlView.frame;
	//4
	newFrame.size.height = adSize.height;
    
   	//5
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //6
	newFrame.size.width = winSize.width;
	//7
	newFrame.origin.x = (self.adWhirlView.bounds.size.width - adSize.width)/2;
    
    //8
	newFrame.origin.y = (winSize.height - adSize.height);
	//9
	adWhirlView.frame = newFrame;
	//10
	[UIView commitAnimations];
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlVieww {
    //1
    [adWhirlView rotateToOrientation:UIInterfaceOrientationLandscapeLeft];
	//2
    [self adjustAdSize];
    
}
 
#pragma mark -
- (void)adWhirlWillPresentFullScreenModal {
    if (self.state == kGameStatePlaying) {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic]; 
        [[CCDirector sharedDirector] pause];
    }
}

- (void)adWhirlDidDismissFullScreenModal {
    if (self.state == kGameStatePaused)
        return;
    else {
        self.state = kGameStatePlaying;
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[CCDirector sharedDirector] resume];   
    }
}
@end

