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
    CCMenuItemFont* showMazeAnswer = [CCMenuItemFont itemFromString:@"show maze answer" target:self selector:@selector(showMazeAnswer)];
    
    
    CCMenu *menu = [CCMenu menuWithItems:regenerateMaze,showMazeAnswer, nil];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [menu setPosition:ccp(winSize.width/2, winSize.height- 40)];
    [menu alignItemsHorizontallyWithPadding:50];
    [self addChild:menu];
    return self;
}

- (void)regenerateMaze
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiRegenerateMaze object:self];
}
- (void)showMazeAnswer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiShowMazeAnswer object:self];
}
@end