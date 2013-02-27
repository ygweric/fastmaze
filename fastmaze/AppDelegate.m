//
//  AppDelegate.m
//  fastmaze
//
//  Created by Eric on 13-2-24.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "cocos2d.h"
#import "MenuLayer.h"

#import "AppDelegate.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (NSString *)adWhirlApplicationKey {
    return KEY_AD_ADWHIRL;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [CCDirector sharedDirector];
}

-(void)showRateAlert{
    UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"Rate Fast Maze" message:@"If you enjoy playing Fast Maze, would you mind taking a moment to rate it? It won't take more than a minute.\n Thanks for your support!" delegate:self cancelButtonTitle:@"No,Thanks" otherButtonTitles:@"Rate It Now",@"Remind Me Later", nil]autorelease];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [MobClick event:@"notRate"];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=597108795"]];
            [MobClick event:@"rateByAlert"];
            break;
        case 2:
            [MobClick event:@"rateLater"];
            break;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    [MobClick startWithAppkey:@"xxx"];
#else
    [MobClick startWithAppkey:KEY_UMENG];
#endif
    [ [ UIApplication sharedApplication ] setIdleTimerDisabled:YES ] ;
    // init app configure
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    if (![def boolForKey:HAVE_SETTED]) {
        //首次游戏的初始化
        [def setBool:YES forKey:HAVE_SETTED];
        [def setBool:YES forKey:UDF_AUDIO];
        [def setBool:YES forKey:UDF_MUSIC];
        [def setInteger:1 forKey:UDF_MAZESIZE];
        
        [def setInteger:0 forKey:UFK_TOTAL_LAUNCH_COUNT];
        [def setDouble:([[NSDate date]timeIntervalSince1970]+kRATE_DAYS) forKey:UFK_NEXT_ALERT_RATE_TIME];
    }else{
        [SysConfig setNeedAudio: [def boolForKey:UDF_AUDIO]];
        [SysConfig setNeedMusic: [def boolForKey:UDF_MUSIC]];
        [SysConfig setMazeSize:[def integerForKey:UDF_MAZESIZE]];
    }
    if ([SysConfig needMusic]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gamebg.mp3" loop:YES];
    }

    /*
    //提醒评分
     第三次启动提醒，以后每隔5天提醒一次
     以后不再提醒为5*2天不在提醒
    */
    NSLog(@"rate---launchCount:%d,next:%f,curr:%f",[def integerForKey:UFK_TOTAL_LAUNCH_COUNT],[def doubleForKey:UFK_NEXT_ALERT_RATE_TIME],[[NSDate date]timeIntervalSince1970]);
    if ([def objectForKey:UFK_TOTAL_LAUNCH_COUNT] ) {
        [def setInteger:([def integerForKey:UFK_TOTAL_LAUNCH_COUNT]+1) forKey:UFK_TOTAL_LAUNCH_COUNT];
        if ([def integerForKey:UFK_TOTAL_LAUNCH_COUNT]>kRATE_FIRST_TIME) {
            [self showRateAlert];
            [def removeObjectForKey:UFK_TOTAL_LAUNCH_COUNT];
        }
    }else{
        double nextAlert= [def doubleForKey:UFK_NEXT_ALERT_RATE_TIME];
        if (nextAlert<[[NSDate date]timeIntervalSince1970]) {
            [self showRateAlert];
            [def setDouble:([[NSDate date]timeIntervalSince1970]+kRATE_DAYS) forKey:UFK_NEXT_ALERT_RATE_TIME];
        }
    }
    
   
    
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:YES];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
//	[window_ addSubview:navController_.view];

	// make main window visible
	[window_ makeKeyAndVisible];

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [MenuLayer scene]];

    //请求广告
    AdWhirlView *adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    [[CCDirector sharedDirector].view addSubview:adWhirlView];
    
	return YES;
}
//设置广告条宽度
- (void)adWhirlDidReceiveAd:(AdWhirlView *)adView {
    [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                    context:nil];
    
    [UIView setAnimationDuration:0.7];
    
    CGSize adSize = [adView actualAdSize];
    CGRect newFrame = adView.frame;
    CGSize winsize=[CCDirector sharedDirector].winSize;
    newFrame.size = adSize;
    newFrame.origin.x = (winsize.width - adSize.width)/ 2;
    
    adView.frame = newFrame;
    
    [UIView commitAnimations];
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//support ios 6+
-(BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end
