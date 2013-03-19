//
//  DialogUtil.m
//  fastmaze
//
//  Created by Eric on 13-2-5.
//
//

#import "DialogUtil.h"
#import "TKLoadingView.h"
@implementation DialogUtil{
    TKLoadingView *loading;
    UIView *view;
}
static DialogUtil* instance;
+(DialogUtil*)share{
    if (!instance) {
        instance=[[DialogUtil alloc]init];
    }
    return instance;
}
-(UIActivityIndicatorView*)showWaitDialog{
    UIActivityIndicatorView* spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    spinner.color = [UIColor whiteColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    CGSize winsize=[[CCDirector sharedDirector] winSize];
    spinner.center=ccp(winsize.width/2, winsize.height/2);
    [[[CCDirector sharedDirector] view] addSubview:spinner ];
    return spinner;
}
-(void)unshowWaitDialog:(UIActivityIndicatorView*)spinner{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

-(CCLabelBMFont*)showWaitLable:(CCNode*)layer{
    CCLabelBMFont* waitLable=[CCLabelBMFont labelWithString:@"Loading... ..." fntFile:@"futura-48.fnt"];
    [layer addChild:waitLable z:1000];
    CGSize winsize=[[CCDirector sharedDirector] winSize];
	waitLable.position = ccp(winsize.width/2, winsize.height/2);
    waitLable.scale=0.5;
    return waitLable;
}
-(void)unshowWaitLable:(CCLabelBMFont*)waitLable{
    [waitLable removeFromParentAndCleanup:YES];
}
#pragma mark - custome wait dialog
- (void) showLoading:(UIView*)parentView{
    if(loading==nil){
        loading  = [[TKLoadingView alloc] initWithTitle:@"设置中..."];
        [loading startAnimating];
        loading.center = CGPointMake(parentView.bounds.size.width/2 - 40, parentView.bounds.size.height/2  + 40);
    }
    loading.lWidth = 200;
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(40, 40, 280, 440)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:loading];
    }
    [parentView addSubview:view];
}
- (void) unshowLoading
{
    [view removeFromSuperview];
}

@end
