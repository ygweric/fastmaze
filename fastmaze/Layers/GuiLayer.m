//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "GuiLayer.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
#import "CCDirector.h"
#import "CGPointExtension.h"
#import "Constants.h"

@implementation GuiLayer
- (id)init
{
    self = [super init];
    CCMenuItemFont* regenerateMaze = [CCMenuItemFont itemFromString:@"Regenerate Maze" target:self selector:@selector(regenerateMaze)];
    CCMenu *menu = [CCMenu menuWithItems:regenerateMaze, nil];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [menu setPosition:ccp(winSize.width/2, 20)];
    [menu alignItemsHorizontally];
    [self addChild:menu];
    return self;
}

- (void)regenerateMaze
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRegenerateMazeNotification object:self];
}
@end