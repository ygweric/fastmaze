//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "MazeCell.h"
#import "CGPointExtension.h"
#import "CCSpriteBatchNode.h"

@interface MazeCell ()
@property (nonatomic, assign) CCSprite *northWall;
@property (nonatomic, assign) CCSprite *southWall;
@property (nonatomic, assign) CCSprite *westWall;
@property (nonatomic, assign) CCSprite *eastWall;
@property (nonatomic, assign) CCSpriteBatchNode *batch;
@property (nonatomic, retain) CCSprite *horiz;
@property (nonatomic, retain) CCSprite *vert;
- (void)setupWalls;
@end

@implementation MazeCell
@synthesize index     = _index;
@synthesize visited   = _visited;
@synthesize neighbors = _neighbors;
@synthesize walls      = _walls;
@synthesize northWall = _northWall;
@synthesize southWall = _southWall;
@synthesize westWall = _westWall;
@synthesize eastWall = _eastWall;
@synthesize batch = _batch;
@synthesize horiz = _horiz;
@synthesize vert = _vert;


- (id)initWithIndex:(NSNumber *)index andBatchNode:(CCSpriteBatchNode *)batch
{
    self = [super init];
    self.batch = batch;
    [self useBatchNode:batch];
    self.index = index;
    self.visited = NO;
    self.neighbors = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
    self.walls = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
    self.horiz = [CCSprite spriteWithSpriteFrameName:@"horiz.png"];
    self.vert = [CCSprite spriteWithSpriteFrameName:@"vert.png"];
    [self setupWalls];
    return self;
}

- (void)setupWalls
{
    _northWall = [CCSprite spriteWithTexture:[_batch texture] rect:_horiz.textureRect];
    [_northWall setPosition:ccp(position_.x, position_.y + 16)];
    [_northWall setColor:ccc3(130, 130, 130)];
    [self addChild:_northWall];

    _southWall = [CCSprite spriteWithTexture:[_batch texture] rect:_horiz.textureRect];
    [_southWall setPosition:ccp(position_.x, position_.y - 16)];
    [_southWall setColor:ccc3(130, 130, 130)];
    [self addChild:_southWall];

    _westWall = [CCSprite spriteWithTexture:[_batch texture] rect:_vert.textureRect];
    [_westWall setPosition:ccp(position_.x - 16, position_.y)];
    [_westWall setColor:ccc3(130, 130, 130)];
    [self addChild:_westWall];

    _eastWall = [CCSprite spriteWithTexture:[_batch texture] rect:_vert.textureRect];
    [_eastWall setPosition:ccp(position_.x + 16, position_.y)];
    [_eastWall setColor:ccc3(130, 130, 130)];
    [self addChild:_eastWall];
}

- (void)addNeighbor:(MazeCell *)neighbor
{
    [self.neighbors setObject:neighbor forKey:neighbor.index];
}

- (void)removeWall:(MazeCell *)neighbor
{
    CCSprite *wall = [self wallForNeighbor:neighbor];
    if (wall != nil) {
        [self removeChild:wall cleanup:YES];
        if ([wall isEqual:_westWall]) {
            _westWall = nil;
        } else if ([wall isEqual:_eastWall]) {
            _eastWall = nil;
        } else if ([wall isEqual:_northWall]) {
            _northWall = nil;
        } else if ([wall isEqual:_southWall]) {
            _southWall = nil;
        }
    }
}

- (CCSprite *)wallForNeighbor:(MazeCell *)neighbor
{
    CCSprite *wall = nil;
    if (neighbor.position.x < position_.x) {
        wall = _westWall;
    } else if (neighbor.position.x > position_.x) {
        wall = _eastWall;
    } else if (neighbor.position.y > position_.y) {
        wall = _northWall;
    } else if (neighbor.position.y < position_.y) {
        wall = _southWall;
    }
    return wall;
}

- (void)dealloc
{
    [_neighbors release];
    [_walls release];
    [_index release];
    [_horiz release];
    [_vert release];
    [super dealloc];
}
@end
