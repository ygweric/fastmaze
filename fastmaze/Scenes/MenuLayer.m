//
//  MenuLayer.m
//  birdjump
//
//  Created by Eric on 12-11-20.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "SlidingMenuGrid.h"
#import "HelpLayer.h"
#import "SettingLayer.h"
#import "AppDelegate.h"
#import "GameScene.h"

enum  {
    tMenuGrid ,
};

@implementation MenuLayer
{
    CCMenu* modelEndless;
    CCMenu* modelLevel;
    CCMenu* modelSetting;
    CCMenu* modelHelp;
    CCMenu* modelShop;
}
enum {
    eMenuButtonPlay =1,
    eMenuButtonSetting,
    eMenuButtonHelp,
};
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	self = [super init];
	if (self)
	{
        if (IS_IPHONE_5) {
            [self setBg:@"bg-568h@2x.jpg"];
        }else{
            [self setBg:SD_OR_HD(@"bg.jpg")];
        }
        //操作菜单
//        modeLevel= [CCMenuUtil createMenuWithImg:@"mode_level.png" pressedColor:ccYELLOW target:self selector:@selector(showLayerModelLevel)];
//        [self addChild:modeLevel z:zAboveOperation];
//        modeLevel.position=ccp(-winSize.width*1/3, winSize.height*4/3);
        

        modelEndless= [CCMenuUtil createMenuWithImg:@"mode_endless.png" pressedColor:ccYELLOW target:self selector:@selector(showLayerModelEndless)];         
        [self addChild:modelEndless z:zAboveOperation];
         modelEndless.position=ccp(-100, -100);
        
        modelSetting= [CCMenuUtil createMenuWithImg:@"mode_setting.png" pressedColor:ccYELLOW target:self selector:@selector(OnSettings:)];
        [self addChild:modelSetting z:zAboveOperation];
        modelSetting.position=ccp(winSize.width/2, winSize.height+100);
        
        modelHelp= [CCMenuUtil createMenuWithImg:@"mode_help.png" pressedColor:ccYELLOW target:self selector:@selector(onHelp:)];
        [self addChild:modelHelp z:zAboveOperation];
        modelHelp.position=ccp(winSize.width+100, -100);
        
        modelShop= [CCMenuUtil createMenuWithImg:@"mode_shop.png" pressedColor:ccYELLOW target:self selector:@selector(onShop:)];
        [self addChild:modelShop z:zAboveOperation];
        modelShop.position=ccp(winSize.width+100, winSize.height+100);
        
        
        
//        [self performSelector:@selector(showMenuModelLevel) withObject:nil afterDelay:0.5];
        [self performSelector:@selector(showMenuModelEndless) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL];
        [self performSelector:@selector(showMenuModelSetting) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*2];
        [self performSelector:@selector(showMenuModelHelp) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*3];
        [self performSelector:@selector(showMenuModelShop) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*4];
        
	}

	return self;
}

-(void)showMenuModelLevel{ 
//    [modelLevel runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(winSize.width/2-(IS_IPAD()?150:70), winSize.height*2/3)]];
//    [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
}
-(void)showMenuModelEndless{
    [modelEndless runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width/2-(IS_IPAD()?250:70), winSize.height*2/3)]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
}
-(void)showMenuModelSetting{
    [modelSetting runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width/2, winSize.height*1/3)]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
}
-(void)showMenuModelHelp{
    [modelHelp runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width/2+(IS_IPAD()?250:70), winSize.height*2/3)]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
}
-(void)showMenuModelShop{
    [modelShop runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp((winSize.width/2+(IS_IPAD()?250:70))+100, winSize.height*1/3)]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
}

- (void) showGameLevelList:(id) sender
{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    SlidingMenuGrid* menuGrid=(SlidingMenuGrid*)[self getChildByTag:tMenuGrid];
    if (menuGrid==nil) {
        NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:kMAX_LEVEL_IDEAL+1];
        //最后一个提示“more is comming soon !!! \n follow my twitter”
        for (int i = 1; i <= kMAX_LEVEL_IDEAL+1; ++i)
        {
            // create a menu item for each character
            CCSprite* normalSprite = [CCSprite spriteWithFile:SD_OR_HD(@"menu_item_bg.png") ];
            CCSprite* selectedSprite = [CCSprite spriteWithFile:SD_OR_HD(@"menu_item_bg.png")];
            ccColor3B color= ccBLUE;
            selectedSprite.color= color;
            CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(LaunchLevel:)];
            item.tag=i;
            int levelPassed= [[NSUserDefaults standardUserDefaults]integerForKey:UDF_LEVEL_PASSED];
            CCNode* levelInfo=nil;
            if ((![SysConfig needLockLevel]|| (i<=levelPassed+1)) && (i<=kMAX_LEVEL_REAL)) {
                levelInfo=[[CCLabelBMFont alloc]initWithString:[NSString stringWithFormat:@"%d",i] fntFile:@"futura-48.fnt"];
                levelInfo.scale=HD2SD_SCALE;
            }else if(i==kMAX_LEVEL_REAL+1){
                levelInfo=[CCMenuItemImage itemFromNormalImage:SD_OR_HD(@"level_what.png") selectedImage:SD_OR_HD(@"level_what.png")];
            }else{
                levelInfo=[CCMenuItemImage itemFromNormalImage:SD_OR_HD(@"level_lock.png") selectedImage:SD_OR_HD(@"level_lock.png")];
            }
            
            levelInfo. position=ccp(item.contentSize.width/2, item.contentSize.height/2);
            [item addChild:levelInfo];
            /* //--for test
             item.contentSize 64*72
             item.rect.size.width 64*72
             item.boundingBox.size.width 64*72
             NSLog(@"%@,%@,%@",item.contentSize,item.rect,item.boundingBox);
             */
            
            
            [allItems addObject:item];
        }
        
        //从position开始向右下角排列
        if (IS_IPAD()) {
            menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:8 rows:3 position:ccp(70.f, 0.0f) padding:CGPointMake(90.f, 90.f) verticalPages:NO];
        } else {
            menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:6 rows:3 position:ccp(45.f, 0.0f) padding:CGPointMake(45.f, 45.f) verticalPages:NO];
        }
        
        [self addChild:menuGrid z:-1 tag:tMenuGrid];
        
        
        //只有layer才有透明动画，menu没有
        CGPoint p=IS_IPAD()? ccp(70, 280):ccp(45, 150);
        [menuGrid runAction:[CCMoveTo actionWithDuration:0.5 position:p]];
        menuGrid.menuOrigin=p;
    }
}

-(void)showLayerModelLevel{
    
}

-(void)showLayerModelEndless{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:[GameScene node]]];
}

-(void)setting{
    
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    CCScene* sc=[SettingLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}

-(void)about{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    CCScene* sc=[HelpLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}



- (void) OnSettings:(id) sender
{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    CCScene* sc=[SettingLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}
- (void) onHelp:(id) sender
{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    CCScene* sc=[HelpLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}

-(void)onShop:(id) sender{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    UIAlertView* shopAlert=[[[UIAlertView alloc]initWithTitle:nil message:@"remove ad" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil]autorelease];
    [shopAlert show];
}
@end
