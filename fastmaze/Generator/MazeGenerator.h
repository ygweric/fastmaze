//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import <Foundation/Foundation.h>

@class MazeCell;
@class CCSprite;
@class Entity;
@class CCSpriteBatchNode;

@interface MazeGenerator : NSObject
@property (nonatomic, retain) NSMutableDictionary *grid;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) Entity* playerEntity;
@property (nonatomic,assign) CCLayer* mazeLayer;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batch layer:(CCLayer*)layer;

- (void)generateGrid;

- (void)addToNeighbors:(MazeCell *)cell;

- (void)createUsingDepthFirstSearch;
-(void)cleanAllTrack:(Entity *)entity;
- (BOOL)isPositionInMaze:(CGPoint)position;

- (MazeCell *)cellForPosition:(CGPoint)position;
- (BOOL)movingEntity:(Entity *)entity direction:(DIRECTION) direction;
- (void)searchUsingDepthFirstSearch:(CGPoint)start endingAt:(CGPoint)end movingEntity:(Entity *)entity;
- (BOOL)movingEntity:(Entity *)entity position:(CGPoint) position;
- (BOOL)showShotPath:(CGPoint)start endingAt:(CGPoint)end movingEntity:(Entity *)entity;
- (BOOL)showShotPath:(CGPoint)start endingAt:(CGPoint)end;
- (BOOL)isDesirePosition:(CGPoint)end desirePosition:(CGPoint)desirePosition;
@end