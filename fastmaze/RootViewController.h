//
//  RootViewController.h
//  toddlermaze
//
//  Created by Jonny Brannum on 1/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"
enum GameStatePP {
    kGameStatePlaying,
    kGameStatePaused
};

@interface RootViewController : UIViewController<AdWhirlDelegate> {

}
@property(nonatomic,retain) AdWhirlView *adWhirlView;
@property(nonatomic) enum GameStatePP state;
@end
