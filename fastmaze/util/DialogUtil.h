//
//  DialogUtil.h
//  fastmaze
//
//  Created by Eric on 13-2-5.
//
//

#import <Foundation/Foundation.h>

@interface DialogUtil : NSObject
+(DialogUtil*)share;
-(UIActivityIndicatorView*)showWaitDialog;
-(void)unshowWaitDialog:(UIActivityIndicatorView*)spinner;

-(CCLabelBMFont*)showWaitLable:(CCNode*)layer;
-(void)unshowWaitLable:(CCLabelBMFont*)waitLable;
- (void) showLoading:(UIView*)parentView;
- (void) unshowLoading;
@end
