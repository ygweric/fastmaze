//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import "GameLayer.h"
#import "MazeGenerator.h"
#import "CCSpriteBatchNode.h"
#import "CCSpriteFrameCache.h"
#import "CCSprite.h"
#import "CGPointExtension.h"
#import "MazeCell.h"
#import "Entity.h"
#import "Constants.h"

@interface GameLayer ()
@property (nonatomic, retain) MazeGenerator *mazeGenerator;
@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, assign) Entity *playerEntity;
@property (nonatomic, assign) Entity *desireEntity;
@property (nonatomic, assign) Entity *currentStart;
@property (nonatomic, assign) Entity *currentEnd;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regenerateMaze) name:kRegenerateMazeNotification object:nil];
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

- (void)loadGeneratedMaze
{
    // determine our maze center
    CGPoint mazeCenter = ccp((_mazeGenerator.size.width)/2, (_mazeGenerator.size.height)/2);
    // find our center cell
//    MazeCell *centerCell = [_mazeGenerator cellForPosition:mazeCenter];
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
//    [self setPosition:ccpAdd(ccpAdd(position_, diff),ccp(0,diff.y/2))];
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

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{

}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
    // we also handle touches for map movement
    // simply move the layer around by the diff of this move and the last
    UITouch *touch = [touches anyObject];
    // get our GL location
    CGPoint location = [[CCDirector sharedDirector]
            convertToGL:[touch locationInView:touch.view]
    ];
    CGPoint previousLocation = [[CCDirector sharedDirector]
            convertToGL:[touch previousLocationInView:touch.view]
    ];
    // create the difference
    CGPoint diff = ccp(location.x - previousLocation.x, location.y - previousLocation.y);
    // add the diff to the current position
    [self setPosition:ccp(position_.x + diff.x, position_.y + diff.y)];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // get our GL location
    CGPoint location = [[CCDirector sharedDirector]
            convertToGL:[touch locationInView:touch.view]
    ];
    if ([_mazeGenerator isPositionInMaze:ccpSub(location, position_)]) {
        [_playerEntity beginMovement];
        //开始查找
        [_mazeGenerator searchUsingDepthFirstSearch:_playerEntity.position endingAt:_desireEntity.position movingEntity:_playerEntity];     
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mazeGenerator release];
    [super dealloc];
}
@end