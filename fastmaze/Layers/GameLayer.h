//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/21/12
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"

@interface GameLayer : CCLayer

- (void)regenerateMaze;

- (void)loadGeneratedMaze;
@end