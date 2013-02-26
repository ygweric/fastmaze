//
//  DialogUtil.m
//  fastmaze
//
//  Created by Eric on 13-2-5.
//
//

#import "DialogUtil.h"

@implementation DialogUtil

+(UIActivityIndicatorView*)showWaitDialog{
    UIActivityIndicatorView* spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    spinner.color = [UIColor whiteColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    CGSize winsize=[[CCDirector sharedDirector] winSize];
    spinner.center=ccp(winsize.width/2, winsize.height/2);
//    [[[CCDirector sharedDirector] openGLView] addSubview:spinner ];
    return spinner;
}
+(void)unshowWaitDialog:(UIActivityIndicatorView*)spinner{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

+(CCLabelBMFont*)showWaitLable:(CCNode*)layer{
    CCLabelBMFont* waitLable=[CCLabelBMFont labelWithString:@"Loading... ..." fntFile:@"futura-48.fnt"];
    [layer addChild:waitLable z:1000];
    CGSize winsize=[[CCDirector sharedDirector] winSize];
	waitLable.position = ccp(winsize.width/2, winsize.height/2);
    waitLable.scale=0.5;
    return waitLable;
}
+(void)unshowWaitLable:(CCLabelBMFont*)waitLable{
    [waitLable removeFromParentAndCleanup:YES];
}

@end
