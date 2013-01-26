//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"

#import "MazeGenerator.h"
#import "CCSpriteBatchNode.h"
#import "CCSpriteFrameCache.h"
#import "CCSprite.h"
#import "CGPointExtension.h"
#import "MazeCell.h"
#import "Entity.h"

@interface GameLayer : CCLayer
@property (nonatomic, retain) MazeGenerator *mazeGenerator;
@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, assign) Entity *playerEntity;
@property (nonatomic, assign) Entity *desireEntity;
@property (nonatomic, assign) Entity *currentStart;
@property (nonatomic, assign) Entity *currentEnd;


- (void)regenerateMaze;
- (void)showMazeAnswer;

- (void)loadGeneratedMaze;
@end