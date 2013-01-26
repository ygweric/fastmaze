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
@synthesize gameLayer=_gameLayer;
@synthesize myjoystick=_myjoystick;

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
    
    _myjoystick=[CCJoyStick initWithBallRadius:25 MoveAreaRadius:65 isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
    [_myjoystick setBallTexture:@"Ball.png"];
    [_myjoystick setDockTexture:@"Dock.png"];
    [_myjoystick setStickTexture:@"Stick.jpg"];
    [_myjoystick setHitAreaWithRadius:100];
    
    _myjoystick.position=ccp(100,100);
    _myjoystick.delegate=self;
    [self addChild:_myjoystick];
    
    return self;
}

- (id)initWithGameLayer:(GameLayer*)gameLayer
{
    self = [self init];
    self.gameLayer=gameLayer;
    return self;
}

- (void)regenerateMaze
{
    [_gameLayer regenerateMaze];
}
- (void)showMazeAnswer
{
    [_gameLayer showMazeAnswer];
}

#pragma mark -joystick
- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
	if (sender==_myjoystick) {
		NSLog(@"angle:%f power:%f direction:%f,%f",angle,power,direction.x,direction.y);
        DIRECTION dir=-1;
        BOOL hasMoved=NO;
        if (ABS(direction.x)>ABS(direction.y)) {
            if (direction.x >MIN_DISTANCE_PERCENT) {
                dir=kRIGHT;
            }else if(direction.x <-MIN_DISTANCE_PERCENT){
                dir=kLEFT;
            }
            if (dir>0) {
                hasMoved =[_gameLayer.mazeGenerator movingEntity:_gameLayer.playerEntity direction:dir];
            }
            
        }
        if(!hasMoved){
            if (direction.y >MIN_DISTANCE_PERCENT) {
                dir=kUP;
            }else if(direction.y <-MIN_DISTANCE_PERCENT){
                dir=kDOWN;
            }
            if (dir>0) {
                hasMoved =[_gameLayer.mazeGenerator movingEntity:_gameLayer.playerEntity direction:dir];
            }
        }
        if (!hasMoved) {
            NSLog(@"you can't move at this direction:%d",dir);
        }
//        if (dir>0) {
//            //power在0-0.8中间时候，只移动一步，
//            //大于0.8,则移动两步
////            for (int i=0; i<((power*10)/9)+1; i++) {
////                [_gameLayer.mazeGenerator movingEntity:_gameLayer.playerEntity direction:dir];
////            }
//            [_gameLayer.mazeGenerator movingEntity:_gameLayer.playerEntity direction:dir];
//            
//        }
        
        
        
        
		
	}
}

- (void) onCCJoyStickActivated:(CCNode*)sender
{
	if (sender==_myjoystick) {
		[_myjoystick setBallTexture:@"Ball_hl.png"];
		[_myjoystick setDockTexture:@"Dock_hl.png"];
	}
}
- (void) onCCJoyStickDeactivated:(CCNode*)sender
{
	if (sender==_myjoystick) {
		[_myjoystick setBallTexture:@"Ball.png"];
		[_myjoystick setDockTexture:@"Dock.png"];
	}
}

@end