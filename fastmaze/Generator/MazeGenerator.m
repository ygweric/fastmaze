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
@property (nonatomic,assign) NSMutableArray* cancelEntitys;
@property (nonatomic,assign) NSMutableArray* correctEntitys;
@end

@implementation MazeGenerator
@synthesize size       = _size;
@synthesize complexity = _complexity;
@synthesize density    = _density;
@synthesize grid       = _grid;
@synthesize batch = _batch;
@synthesize playerEntity=_playerEntity;
@synthesize cancelEntitys=_cancelEntitys;
@synthesize correctEntitys=_correctEntitys;

#pragma mark -
- (id)initWithBatchNode:(CCSpriteBatchNode *)batch
{
    self = [super init];
    self.batch = batch;
    int baseWidth=480;
    int baseHeight=320;
    switch ([SysConfig mazeSize]) {
        case oSmall:
            self.size = CGSizeMake(baseWidth, baseHeight);
            break;
        case oNormal:
            self.size = CGSizeMake(baseWidth*2, baseHeight*2);
            break;
        case oLarge:
            self.size = CGSizeMake(baseWidth*3, baseHeight*3);
            break;
        case oHuge:
            self.size = CGSizeMake(baseWidth*4, baseHeight*4);
            break;

    }

    self.complexity = 0.1f;
    self.density = 0.5f;

    _cancelEntitys=[[NSMutableArray alloc]initWithCapacity:10];
    _correctEntitys=[[NSMutableArray alloc]initWithCapacity:10];
    
    
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
    CGSize winSize=[[CCDirector sharedDirector] winSize];
    CGPoint mazeCenter=ccp(self.size.width/2, self.size.height/2);
    CGPoint diff=ccpSub(ccp(winSize.width/2,winSize.height/2), mazeCenter);
    for (NSUInteger x = 0; x < self.size.width; x+=32) {
        for (NSUInteger y = 0; y < self.size.height; y+=32) {
            MazeCell *cell = [[[MazeCell alloc] initWithIndex:[self createIndex:ccp(x, y)] andBatchNode:_batch] autorelease];
//            [cell setPosition:ccpAdd(ccp(x, y), diff) ];
            [cell setPosition:ccp(x, y) ];
            [self.grid setObject:cell forKey:cell.index];
        }
    }
    for (NSUInteger x = 0; x < self.size.width; x+=32) {
        for (NSUInteger y = 0; y < self.size.height; y+=32) {
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

#pragma mark -
//return BOOL 表示是否移动成功
/*
 将指定entity移至指定position，
 首先判断是否相邻
 然后判断是否有wall
 */
- (BOOL)movingEntity:(Entity *)entity position:(CGPoint) position
{
    //    NSLog(@"movingEntity--entity:%@,direcion:%d",entity,direction);
    __block MazeCell* currentCell= [self cellForPosition:entity.position];
    __block MazeCell* destCell= [self cellForPosition:position];
    NSLog(@"currentCell x:%f,y:%f --destCell x:%f,y:%f",currentCell.position.x,currentCell.position.y,destCell.position.x,destCell.position.y);
    __block BOOL movable=NO;//是否可移动
    [currentCell.neighbors enumerateKeysAndObjectsUsingBlock:
     ^(id key, id neig, BOOL *stop) {
         MazeCell* neighbor= (MazeCell*)neig;
         CGPoint diff= ccpSub(neighbor.position, destCell.position);
         if (diff.x==0 && diff.y==0) {
             NSLog(@"is corresponding neighbor");
             if (![currentCell wallForNeighbor:destCell]) {
                 movable=YES;
                 NSLog(@"ok,movable..");
             } else {
                  NSLog(@"!!! you can't move role here,has wall");
             }
            *stop=YES;  
         }     
     }
     ];
    if (movable) {
        entity.position=destCell.position;
    }
    return movable;
}

//return BOOL 表示是否移动成功
- (BOOL)movingEntity:(Entity *)entity direction:(DIRECTION) direction
{
//    NSLog(@"movingEntity--entity:%@,direcion:%d",entity,direction);
    __block MazeCell* currentCell= [self cellForPosition:entity.position];
    __block BOOL hasMoved=NO;//是否可移动
        [currentCell.neighbors enumerateKeysAndObjectsUsingBlock:
         ^(id key, id neig, BOOL *stop) {
             BOOL hasWall=NO;//是否有wall
             BOOL isRefWall=NO;//是否在对应方向上判断wall
             MazeCell* neighbor= (MazeCell*)neig;
             CGPoint diff = ccp( neighbor.position.x-currentCell.position.x, neighbor.position.y-currentCell.position.y);
             if (diff.x>0 && direction==kRIGHT) {
                 isRefWall=YES;
                 hasWall=(currentCell.eastWall != nil);
             }else if(diff.x< 0&& direction==kLEFT){
                 isRefWall=YES;
                 hasWall=(currentCell.westWall != nil);
             }else if (diff.y>0&& direction==kUP) {
                 isRefWall=YES;
                 hasWall=(currentCell.northWall != nil);
             }else if(diff.y< 0&& direction==kDOWN){
                 isRefWall=YES;
                 hasWall=(currentCell.southWall != nil);
             }else{
                 //不是相应方向的neighbor，继续循环
                 isRefWall=NO;
             }
             
             if (isRefWall) {
                 if (!hasWall) {
                     currentCell=neighbor;
                     hasMoved=YES;
                     NSLog(@"--has no Wall--index:%d",currentCell.index.intValue);
                 }else{
                     
                 }
                 *stop=YES;
             }
         }
         ];
    if (hasMoved) {
        entity.position=currentCell.position;
    }    
    return hasMoved;
}
//只计算shot path距离是否合适
- (BOOL)showShotPath:(CGPoint)start endingAt:(CGPoint)end
{
    NSLog(@"-1-showShotPath--start x:%f,y:%f,end x:%f,y:%f",start.x,start.y,end.x,end.y);
    __block float distance = INFINITY;
    __block NSNumber *index = nil;
    __block float endDistance = INFINITY;
    __block NSNumber *endIndex = nil;
    [self.grid enumerateKeysAndObjectsUsingBlock:
     ^(id key, id cell, BOOL *stop) {
         MazeCell *mazeCell = (MazeCell *)cell;
         mazeCell.visited = NO;
         //找到start点
         //一直循环，找到离start点最近的cell
         float curDistance = ccpDistance(start, mazeCell.position);
         if (curDistance < distance) {
             distance = curDistance;
             index = [cell index];
         }
         //找到end点
         float curEndDistance = ccpDistance(end, mazeCell.position);
         if (curEndDistance < endDistance) {
             endDistance = curEndDistance;
             endIndex = [cell index];
         }
     }
     ];
    NSLog(@"showShotPath--currentCell.index:%d, endCell.index:%d",index.intValue,endIndex.intValue);
    MazeCell *currentCell = [self.grid objectForKey:index];
    if (currentCell == nil) {
        return NO;
    }
    MazeCell *endCell = [self.grid objectForKey:endIndex];
    if (endCell == nil) {
        return NO;
    }
    int cancenCount=0,correctCount=0;
    BOOL found = NO;
    BOOL impossible = NO;
    NSMutableArray *stack = [[NSMutableArray alloc] initWithCapacity:10];
    BOOL stackPopped = NO;
    //这里首先要把currentCell置为visited，否则会重复迭代currentCell
    currentCell.visited=YES;
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
                correctCount++;
            } else {
                correctCount++;
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
            cancenCount++;
            correctCount--;
            // "pop" the top cell off the stack to resume a previously started trail
            currentCell = [stack objectAtIndex:stack.count - 1];
            [stack removeObjectAtIndex:stack.count - 1];
        }
    }
    [stack release];
    
    //util很快就找到了path，上面的过程只是在生成action
    if (correctCount<=MAX_AUTO_STEP*([SysConfig mazeSize]+1)) {
        if (found) {
            NSLog(@"--ok, the auto path has been shown --");
            return YES;
        }else{
            NSLog(@"OH!,--1- I can't show the Answer! Error !!!");
        }
    } else {
        NSLog(@"you auto step is too long");
    }
    
    return NO;
    
    
    
    
    
}
- (BOOL)isDesirePosition:(CGPoint)end desirePosition:(CGPoint)desirePosition{
    __block float endDistance = INFINITY;
    __block NSNumber *endIndex = nil;
    [self.grid enumerateKeysAndObjectsUsingBlock:
     ^(id key, id cell, BOOL *stop) {
         MazeCell *mazeCell = (MazeCell *)cell;
         //找到end点
         float curEndDistance = ccpDistance(end, mazeCell.position);
         if (curEndDistance < endDistance) {
             endDistance = curEndDistance;
             endIndex = [cell index];
         }
     }
     ];
    MazeCell *endCell = [self.grid objectForKey:endIndex];
    if (endCell == nil) {
        return NO;
    }else if(ccpDistance(endCell.position, desirePosition)==0){        
        NSLog(@"MazeGenerator---great!!! you win!!!!!");
        return YES;
    }

    return NO;
}


//只管显示，不管检查距离，而用 showShotPath:endingAt:来检查距离
- (BOOL)showShotPath:(CGPoint)start endingAt:(CGPoint)end movingEntity:(Entity *)entity
{
    NSLog(@"-2-showShotPath--start x:%f,y:%f,end x:%f,y:%f",start.x,start.y,end.x,end.y);
    [entity beginMovement];
    __block float distance = INFINITY;
    __block NSNumber *index = nil;
    __block float endDistance = INFINITY;
    __block NSNumber *endIndex = nil;
    [self.grid enumerateKeysAndObjectsUsingBlock:
     ^(id key, id cell, BOOL *stop) {
         MazeCell *mazeCell = (MazeCell *)cell;
         mazeCell.visited = NO;
         //找到start点
         //一直循环，找到离start点最近的cell
         float curDistance = ccpDistance(start, mazeCell.position);
         if (curDistance < distance) {
             distance = curDistance;
             index = [cell index];
         }
         //找到end点
         float curEndDistance = ccpDistance(end, mazeCell.position);
         if (curEndDistance < endDistance) {
             endDistance = curEndDistance;
             endIndex = [cell index];
         }
     }
     ];
    
    MazeCell *currentCell = [self.grid objectForKey:index];
    if (currentCell == nil) {
        return NO;
    }
    MazeCell *endCell = [self.grid objectForKey:endIndex];
    if (endCell == nil) {
       return NO;
    }
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:10];
     int cancenCount=0,correctCount=0;
    BOOL found = NO;
    BOOL impossible = NO;
    NSMutableArray *stack = [[NSMutableArray alloc] initWithCapacity:10];
    BOOL stackPopped = NO;
    //这里首先要把currentCell置为visited，否则会重复迭代currentCell
    currentCell.visited=YES;
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
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:neighborCell.position]];
                [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCurrent:)]];
                correctCount++;
            } else {
                // the entity has jumped someone not near - lets make it move there without making it look like
                // it's flying through walls
                [actions addObject:[CCFadeOut actionWithDuration:0.0f]];
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:currentCell.position]];
                [actions addObject:[CCFadeIn actionWithDuration:0.0f]];
                // finally, move to the newly added neighbor
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:neighborCell.position]];
                [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCurrent:)]];
                correctCount++;
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
            cancenCount++;
            correctCount--;
            // "pop" the top cell off the stack to resume a previously started trail
            currentCell = [stack objectAtIndex:stack.count - 1];
            [stack removeObjectAtIndex:stack.count - 1];
        }
    }
    [stack release];
//    [actions addObject:[CCCallFuncN actionWithTarget:self selector:@selector(handlerActionFinished) ]];
    
    id sequence = [CCSequence actionsWithArray:actions];
    [entity runAction:sequence];
    return YES;
    
    
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
    //这里首先要把currentCell置为visited，否则会重复迭代currentCell
    currentCell.visited=YES;
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
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:neighborCell.position]];
                [actions addObject:[CCCallFuncN actionWithTarget:entity selector:@selector(dropCurrent:)]];
            } else {
                // the entity has jumped someone not near - lets make it move there without making it look like
                // it's flying through walls
                [actions addObject:[CCFadeOut actionWithDuration:0.0f]];
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:currentCell.position]];
                [actions addObject:[CCFadeIn actionWithDuration:0.0f]];
                // finally, move to the newly added neighbor
                [actions addObject:[CCMoveTo actionWithDuration:0.0f position:neighborCell.position]];
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
    
//    [actions addObject:[CCCallFuncN actionWithTarget:self selector:@selector(handlerActionFinished) ]];
    
    //util很快就找到了path，上面的过程只是在生成action
    if (found) {
        NSLog(@"--ok, the answer has been shown --");
        id sequence = [CCSequence actionsWithArray:actions];
        [entity runAction:sequence];
        
    }else{
        NSLog(@"OH!,--2- I can't show the Answer! Error !!!");
    }
  
}
-(void)handlerActionFinished{
    NSLog(@"handlerActionFinished---_playerEntity.currentEntities.count:%d",_playerEntity.currentEntities.count);
    for (Entity* e in _playerEntity.currentEntities) {
        NSLog(@"handlerActionFinished-----e-- x:%f,y:%f",e.position.x,e.position.y);
    }
}
- (void)dealloc
{
    [_correctEntitys release];
    [_cancelEntitys release];
    [_grid release];
    [super dealloc];
}
@end