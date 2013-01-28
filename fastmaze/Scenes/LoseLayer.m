//
//  LoseLayer.m
//  birdjump
//
//  Created by Eric on 12-11-21.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "LoseLayer.h"
#import "MenuLayer.h"
#import "GameLayer.h"

@implementation LoseLayer
+(CCScene*)scene{
    CCScene* sc=[CCScene node];
    LoseLayer* la=[LoseLayer node];
    [sc addChild:la];
    return  sc;
}

-(id) init
{
	[super init];
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine]playEffect:@"lose.mp3"];
    }
    
    if (IS_IPHONE_5) {
        [self setBg:@"bg-568h@2x.jpg"];
    }else{
        [self setBg:SD_OR_HD(@"bg.jpg")];
    }
    
    //分数
    CCLabelBMFont* loseLabel = [CCLabelBMFont labelWithString:@"OH-NO!\n You Lose!" fntFile:@"futura-48.fnt"];
    loseLabel.position=ccp(winSize.width/2, winSize.height*2/3);
    loseLabel.scale=HD2SD_SCALE;
    [self addChild:loseLabel];
    
    //操作菜单
    CCSprite* mn= [CCSprite spriteWithSpriteFrameName:@"button_menu.png"];
    CCSprite* ms= [CCSprite spriteWithSpriteFrameName:@"button_menu.png"];
    ms.color=ccYELLOW;
    CCMenuItemSprite* m=[CCMenuItemSprite itemFromNormalSprite:mn selectedSprite:ms target:self selector:@selector(menu)];
    CCMenu* menuButton= [CCMenu menuWithItems:m, nil];
    menuButton.position=ccp(winSize.width/2-(IS_IPAD()?150:70), winSize.height*1/3);
    [self addChild:menuButton z:zAboveOperation];
    
    CCSprite* rn= [CCSprite spriteWithSpriteFrameName:@"button_refresh.png"];
    CCSprite* rs= [CCSprite spriteWithSpriteFrameName:@"button_refresh.png"];
    rs.color=ccYELLOW;
    CCMenuItemSprite* r=[CCMenuItemSprite itemFromNormalSprite:rn selectedSprite:rs target:self selector:@selector(restart)];
    CCMenu* restartButton= [CCMenu menuWithItems:r, nil];
    restartButton.position=ccp(winSize.width/2+(IS_IPAD()?150:70), winSize.height*1/3);
    [self addChild:restartButton z:zAboveOperation];

    return self;
}

-(void) menu
{
	CCScene *sc = [CCScene node];
	[sc addChild:[MenuLayer node]];
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}
-(void) restart
{
	CCScene *sc =[GameLayer scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}


@end
