//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import "MazeGenerator.h"
#import "CGPointExtension.h"
#import "CCActionInterval.h"
#import "MazeCell.h"
#import "CCActionInstant.h"
#import "Entity.h"
#import "CCSpriteBatchNode.h"

@interface MazeGenerator ()
@property (nonatomic, assign) float complexity;
@property (nonatomic, assign) float density;
@property (nonatomic, assign) CCSpriteBatchNode *batch;
@end

@implementation MazeGenerator
@synthesize size       = _size;
@synthesize complexity = _complexity;
@synthesize density    = _density;
@synthesize grid       = _grid;
@synthesize batch = _batch;


- (id)initWithBatchNode:(CCSpriteBatchNode *)batch
{
    self = [super init];
    self.batch = batch;
    self.size = CGSizeMake(900, 600);
    self.complexity = 0.9f;
    self.density = 0.5f;

    return self;
}
//制定position的cell索引
- (NSNumber *)createIndex:(CGPoint)position
{
    return [NSNumber numberWithFloat:position.x + position.y * self.size.width];
}

// create the grid and assign the grid neighbors
- (void)generateGrid
{
    self.grid = [[[NSMutableDictionary alloc] initWithCapacity:(NSUInteger) (self.size.width * self.size.height / 32)] autorelease];
    for (NSUInteger x = 0; x <= self.size.width; x+=32) {
        for (NSUInteger y = 0; y <= self.size.height; y+=32) {
            MazeCell *cell = [[[MazeCell alloc] initWithIndex:[self createIndex:ccp(x, y)] andBatchNode:_batch] autorelease];
            [cell setPosition:ccp(x, y)];
            [self.grid setObject:cell forKey:cell.index];
        }
    }
    for (NSUInteger x = 0; x <= self.size.width; x+=32) {
        for (NSUInteger y = 0; y <= self.size.height; y+=32) {
            [self addToNeighbors:[self.grid objectForKey:[self createIndex:ccp(x, y)]]];
        }
    }
}
//cell所有的邻居添加cell邻居关系
- (void)addToNeighbors:(MazeCell *)cell
{
    [[self.grid objectForKey:[self createIndex:ccpAdd(cell.position, kNorth)]] addNeighbor:cell];
    [[self.grid objectForKey:[self createIndex:ccpAdd(cell.position, kSouth)]] addNeighbor:cell];
    [[self.grid objectForKey:[self createIndex:ccpAdd(cell.position, kWest)]] addNeighbor:cell];
    [[self.grid objectForKey:[self createIndex:ccpAdd(cell.position, kEast)]] addNeighbor:cell];
}

- (void)createUsingDepthFirstSearch
{
    [self generateGrid];
//    return;
    // we are going to iterate till every cell has been visited
    NSUInteger count = [self.grid count];
    NSUInteger visited = 0;
    // get a random cell in the grid
    MazeCell *currentCell = nil;
    NSEnumerator *cellEnumerator = [self.grid objectEnumerator];
    NSInteger randomCell = arc4random() % (count-1);
    do {
        currentCell = [cellEnumerator nextObject];
        randomCell--;
    } while(randomCell > 0);
    visited++;
    currentCell.visited = YES;
    // save some allocations
    NSMutableArray *stack = [[NSMutableArray alloc] initWithCapacity:32];
    NSMutableArray *neighbors = [[NSMutableArray alloc] initWithCapacity:4];
    // iterate till every cell has been visited
    while (visited < count) {
        // grab each neighbor of our current cell
        [currentCell.neighbors enumerateKeysAndObjectsUsingBlock:
            ^(id key, id neighbor, BOOL *stop) {
                // grab a neighbor and add it to the neighbors array
                if ([neighbor visited] != YES) {
                    [neighbors addObject:neighbor];
                }
            }
        ];
        if (neighbors.count) {
            // if there is a current neighbor that has not been visited, we are switching currentCell to one of them
            [stack addObject:currentCell];
            // get a random neighbor cell
            MazeCell *neighborCell = [neighbors objectAtIndex:arc4random() % neighbors.count];
            neighborCell.visited = YES;
            visited++;
            // knock down the walls! wall为重复,所以相互removeWall，则没有wall
            [neighborCell removeWall:currentCell];
            [currentCell removeWall:neighborCell];
            // update our current cell to be the newly selected cell
            currentCell = neighborCell;
        } else {
            // "pop" the top cell off the stack to resume a previously started trail
            currentCell = [stack objectAtIndex:stack.count - 1];
            [stack removeObjectAtIndex:stack.count - 1];
        }
        // cleanup
        [neighbors removeAllObjects];
    }

    // final cleanup
    [neighbors release];
    [stack release];
}

- (void)searchUsingAStar:(CGPoint)start endingAt:(CGPoint)end movingEntity:(CCSprite *)entity
{
    if (CGPointEqualToPoint(start, end)) {
        return;
    }
    
    MazeCell *startCell = [self cellForPosition:start];
    MazeCell *endCell = [self cellForPosition:end];
    if (startCell == nil || endCell == nil || [startCell isEqual:endCell]) {
        return;
    }


}

- (BOOL)isPositionInMaze:(CGPoint)position
{
    return position.x > 0 && position.y > 0 && position.x < _size.width && position.y < _size.height;
}

- (MazeCell *)cellForPosition:(CGPoint)position
{
    __block float distance = INFINITY;
    __block MazeCell *returnCell = nil;
    [_grid enumerateKeysAndObjectsUsingBlock:
        ^(id key, id cell, BOOL *stop) {
            MazeCell *mazeCell = (MazeCell *)cell;
            float curDistance = ccpDistance(position, mazeCell.position);
            if (curDistance < distance) {
                distance = curDistance;
                returnCell = mazeCell;
            }
        }
    ];
    
    return returnCell;
}

- (void)searchUsingDepthFirstSearch:(CGPoint)start endingAt:(CGPoint)end movingEntity:(Entity *)entity
{
    __block float distance = INFINITY;
    __block NSNumber *index = nil;
    __block float endDistance = INFINITY;
    __block NSNumber *endIndex = nil;
    [self.grid enumerateKeysAndObjectsUsingBlock:
        ^(id key, id cell, BOOL *stop) {
            MazeCell *mazeCell = (MazeCell *)cell;
            mazeCell.visited = NO;
            float curDistance = ccpDistance(start, mazeCell.position);
            if (curDistance < distance) {
                distance = curDistance;
                index = [cell index];
            }

            float curEndDistance = ccpDistance(end, mazeCell.position);
            if (curEndDistance < endDistance) {
                endDistance = curEndDistance;
                endIndex = [cell index];
            }
        }
    ];

    MazeCell *currentCell = [self.grid objectForKey:index];
    if (currentCell == nil) {
        return;
    }
    MazeCell *endCell = [self.grid objectForKey:endIndex];
    if (endCell == nil) {
        return;
    }
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:10];
    BOOL found = NO;
    BOOL impossible = NO;
    NSMutableArray *stack = [[NSMutableArray alloc] initWithCapacity:10];
    BOOL stackPopped = NO;
    while (!found && !impossible) {
        __block MazeCell *neighborCell = nil;
        // grab each neighbor of our current cell
        [currentCell.neighbors enumerateKeysAndObjectsUsingBlock:
                ^(id key, id neighbor, BOOL *stop) {
                    // grab a neighbor and add it to the neighbors array
                    if ([neighbor visited] != YES && [currentCell wallForNeighbor:neighbor] == nil) {
                        neighborCell = neighbor;
                        *stop = YES;
                    }
                }
        ];
        if (neighborCell) {
            // this neighbor cell will become the current cell
            [stack addObject:currentCell];
            neighborCell.visited = YES;

            if (stackPopped == NO) {
                // move to neighbor
                [actions addObject:[CCMoveTo actionWithDuration:0.2f position:neighborCell.position]];
                [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCurrent:)]];
            } else {
                // the entity has jumped someone not near - lets make it move there without making it look like
                // it's flying through walls
                [actions addObject:[CCFadeOut actionWithDuration:0.1f]];
                [actions addObject:[CCMoveTo actionWithDuration:0.f position:currentCell.position]];
                [actions addObject:[CCFadeIn actionWithDuration:0.1f]];
                // finally, move to the newly added neighbor
                [actions addObject:[CCMoveTo actionWithDuration:0.2f position:neighborCell.position]];
                [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCurrent:)]];
            }
            if (CGPointEqualToPoint(neighborCell.position, endCell.position)) {
                found = YES;
                break;
            }
            // update our current cell to be the newly selected cell
            currentCell = neighborCell;
            stackPopped = NO;
        } else {
            stackPopped = YES;
            if (stack.count == 0) {
                impossible = YES;
                break;
            }
            [actions addObject:[CCMoveTo actionWithDuration:0 position:currentCell.position]];
            [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCancelled:)]];
            // "pop" the top cell off the stack to resume a previously started trail
            currentCell = [stack objectAtIndex:stack.count - 1];
            [stack removeObjectAtIndex:stack.count - 1];
        }
    }
    [stack release];
    if (found) {
        id sequence = [CCSequence actionsWithArray:actions];
        [entity runAction:sequence];
    }
}

- (void)dealloc
{
    [_grid release];
    [super dealloc];
}
@end