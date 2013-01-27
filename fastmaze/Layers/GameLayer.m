//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import "GameLayer.h"


@interface GameLayer ()


@end

@implementation GameLayer
@synthesize mazeGenerator = _mazeGenerator;
@synthesize playerEntity = _playerEntity;
@synthesize desireEntity=_desireEntity;
@synthesize currentStart = _currentStart;
@synthesize currentEnd = _currentEnd;
@synthesize batchNode = _batchNode;


- (id)init
{
    self = [super init];
    self.isTouchEnabled = YES;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"walls.plist"];
    self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"walls.png"];
    [self addChild:_batchNode];
    self.mazeGenerator = [[[MazeGenerator alloc] initWithBatchNode:_batchNode] autorelease];
    [self regenerateMaze];
    return self;
}

- (void)regenerateMaze
{
    [self removeAllChildrenWithCleanup:YES];
    [_batchNode removeAllChildrenWithCleanup:YES];
    [self addChild:_batchNode];
    _currentStart = nil;
    _currentEnd = nil;
    _playerEntity = nil;
    _desireEntity=nil;
    [self setPosition:ccp(0, 0)];
    [_mazeGenerator createUsingDepthFirstSearch];
    [self loadGeneratedMaze];
}
- (void)showMazeAnswer
{
    [_playerEntity beginMovement];
    //开始查找
    [_mazeGenerator searchUsingDepthFirstSearch:_currentStart.position endingAt:_currentEnd.position movingEntity:_playerEntity];
    _mazeGenerator.playerEntity=_playerEntity;
}


- (void)loadGeneratedMaze
{
    // determine our maze center
    CGPoint mazeCenter = ccp((_mazeGenerator.size.width)/2, (_mazeGenerator.size.height)/2);
    // find our center cell
    self.playerEntity = [Entity spriteWithFile:@"entity.png"];
    //set player position
    CGPoint rbMaze = ccp((_mazeGenerator.size.width), 0);
    MazeCell* rbCell= [_mazeGenerator cellForPosition:rbMaze];
    [_playerEntity setPosition:rbCell.position];
    [self addChild:_playerEntity];
    
    self.desireEntity = [Entity spriteWithFile:@"entity.png"];
    //set player position
    CGPoint ltMaze = ccp(0,(_mazeGenerator.size.height));
    MazeCell* ltCell= [_mazeGenerator cellForPosition:ltMaze];
    [_desireEntity setPosition:ltCell.position];
    [self addChild:_desireEntity];
    
    
    
    // determine the window center
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint winCenter = ccp(winSize.width/2, winSize.height/2);
    // determine the difference between the two
    CGPoint diff = ccpSub(winCenter, mazeCenter);
    // add the difference to our current position to center the maze
    [self setPosition:ccpAdd(position_, ccp(diff.x, diff.y/2))];
    
    
    //创建&放置start点
    if (_currentStart == nil) {
        _currentStart = [Entity spriteWithFile:@"entity.png"];
        [_currentStart setColor:ccRED];
        [self addChild:_currentStart];
    }
    [_currentStart setPosition:_playerEntity.position];
    
    //创建&放置end点
    if (_currentEnd == nil) {
        _currentEnd = [Entity spriteWithFile:@"entity.png"];
        [_currentEnd setColor:ccGREEN];
        [self addChild:_currentEnd];
    }
    [_currentEnd setPosition:_desireEntity.position];
    
}
#if 1
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{

    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector]
                        convertToGL:[touch locationInView:touch.view]
                        ];
    CGPoint endPosition = ccpSub(location, self.position);
    if (endPosition.x>0
        && endPosition.y>0
        && endPosition.x<_mazeGenerator.size.width
        && endPosition.y<_mazeGenerator.size.height) {
        if ([_mazeGenerator showShotPath:_playerEntity.position endingAt:endPosition ]) {
            [_mazeGenerator showShotPath:_currentStart.position endingAt:endPosition movingEntity:_playerEntity];
            if ([_mazeGenerator isDesirePosition:endPosition desirePosition:_currentEnd.position]) {
                 NSLog(@"great!!! you win!!!!!");
            }
            
        }
    } else {
        NSLog(@"touch is out of the maze..");
    }
    
   
}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector]
            convertToGL:[touch locationInView:touch.view]
    ];
//    [_mazeGenerator movingEntity:_playerEntity position:location];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}
#endif
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mazeGenerator release];
    [super dealloc];
}
@end