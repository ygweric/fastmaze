//
//  DialogUtil.h
//  fastmaze
//
//  Created by Eric on 13-2-5.
//
//

#import <Foundation/Foundation.h>

@interface DialogUtil : NSObject
+(UIActivityIndicatorView*)showWaitDialog;
+(void)unshowWaitDialog:(UIActivityIndicatorView*)spinner;

+(CCLabelBMFont*)showWaitLable:(CCNode*)layer;
+(void)unshowWaitLable:(CCLabelBMFont*)waitLable;
@end
