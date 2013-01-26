//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "GameLayer.h"
#import "CCJoyStick.h"

@interface GuiLayer : CCLayer<CCJoyStickDelegate>

@property (assign,nonatomic) GameLayer* gameLayer;
@property(nonatomic,readonly)CCJoyStick *myjoystick;

- (id)initWithGameLayer:(GameLayer*)gameLayer;
@end