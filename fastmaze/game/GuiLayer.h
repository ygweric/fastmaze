//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"

@class GameLayer;
@interface GuiLayer : CCLayer

@property (assign,nonatomic) GameLayer* gameLayer;
@property (nonatomic,assign) BOOL gameSuspended;



- (id)initWithGameLayer:(GameLayer*)gameLayer;

-(void)showOperationLayer:(BOOL)show;
-(void)showOperationLayer:(BOOL)show type:(LayerType)layerType;

@end