//
//  GuideLayer.m
//  fastmaze
//
//  Created by Eric on 13-2-18.
//
//

#import "GuideLayer.h"
#import "GuiLayer.h"
#import "MenuLayer.h"

@implementation GuideLayer
{
    int currentPage;
}
-(id)init{
    self=[super init];
    currentPage=1;
    [self showGuideView];
    
    self.isTouchEnabled = YES;
    return self;
}
-(void)showGuideView{
    CCSprite* guide=[CCSprite spriteWithFile:[NSString stringWithFormat:@"guide%d.png",currentPage]];
    [self addChild:guide];
}
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self removeAllChildrenWithCleanup:YES];
    currentPage++;
    if (currentPage<=kGUIDE_PAGE_COUNT) {        
        [self showGuideView];         
    }else{
        CCNode* node=[self parent];
        if ([node isKindOfClass:[GuiLayer class]]) {
            GuiLayer* guiLayer=(GuiLayer*) [self parent];
            [guiLayer showPrepareLayer];
        }else if([node isKindOfClass:[MenuLayer class]]){
            MenuLayer* menuLayer=(MenuLayer*) [self parent];
            [menuLayer showAllMenu];
        }
        [self removeFromParentAndCleanup:YES];
    }
}
@end
