//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "GameLayer.h"

@interface GuiLayer : CCLayer

@property (assign,nonatomic) GameLayer* gameLayer;
@property (nonatomic,assign) BOOL gameSuspended;
@property (retain,nonatomic) CCLayer* pauseLayer;

- (id)initWithGameLayer:(GameLayer*)gameLayer;
@end