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
@property (nonatomic, assign) Entity *playerEntity;//用户观察到的role
@property (nonatomic, assign) Entity *desireEntity;//暂无用
@property (nonatomic, assign) Entity *currentStart;//始终标记起始点，不移动
@property (nonatomic, assign) Entity *currentEnd;//始终标记结束点，不移动


- (void)regenerateMaze;
- (void)showMazeAnswer;

- (void)loadGeneratedMaze;
@end