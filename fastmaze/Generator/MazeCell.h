//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "CCSprite.h"

@class CCSprite;

static const CGPoint kNorth = {0, 32};
static const CGPoint kSouth = {0, -32};
static const CGPoint kWest = {-32, 0};
static const CGPoint kEast = {32, 0};

@interface MazeCell : CCSprite
- (id)initWithIndex:(NSNumber *)index andBatchNode:(CCSpriteBatchNode *)batch;
- (void)addNeighbor:(MazeCell *)neighbor;
- (void)removeWall:(MazeCell *)neighbor;

- (CCSprite *)wallForNeighbor:(MazeCell *)neighbor;

@property (nonatomic, assign) CCSprite *northWall;
@property (nonatomic, assign) CCSprite *southWall;
@property (nonatomic, assign) CCSprite *westWall;
@property (nonatomic, assign) CCSprite *eastWall;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, assign) BOOL visited;
@property (nonatomic, retain) NSMutableDictionary *neighbors;
@property (nonatomic, retain) NSMutableDictionary *walls;
@end