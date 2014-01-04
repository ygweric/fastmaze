//
// @author Eric Yang <ygweric@gmail.com> 
//         1/21/12
//

#import "GameScene.h"
#import "GameLayer.h"


@implementation GameScene
@synthesize guiLayer;
- (id)init
{
    self = [super init];
    GameLayer* gameLayer=[[[GameLayer alloc] init] autorelease];
    [self addChild:gameLayer];
    guiLayer=[[[GuiLayer alloc] initWithGameLayer:gameLayer] autorelease];
    gameLayer.guiLayer=guiLayer;
    guiLayer.anchorPoint=ccp(0.0, 0.0);
    [self addChild:guiLayer];
    return self;
}
@end