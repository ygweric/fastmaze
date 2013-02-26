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
#import "HelpViewController.h"
#import "GuideLayer.h"

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
            [self setBg:@"main_bg.png"];
        }
        //操作菜单
//        modeLevel= [CCMenuUtil createMenuWithImg:@"mode_level.png" pressedColor:ccYELLOW target:self selector:@selector(showLayerModelLevel)];
//        [self addChild:modeLevel z:zAboveOperation];
//        modeLevel.position=ccp(-winSize.width*1/3, winSize.height*4/3);
        

        modelEndless= [SpriteUtil createMenuWithImg:@"mode_endless.png" pressedColor:ccYELLOW target:self selector:@selector(showLayerModelEndless)];         
        [self addChild:modelEndless z:zAboveOperation];
         modelEndless.position=ccp(-100, -100);
        
        modelSetting= [SpriteUtil createMenuWithImg:@"mode_setting.png" pressedColor:ccYELLOW target:self selector:@selector(OnSettings:)];
        [self addChild:modelSetting z:zAboveOperation];
        modelSetting.position=ccp(winSize.width/2, winSize.height+100);
        
        modelHelp= [SpriteUtil createMenuWithImg:@"mode_help.png" pressedColor:ccYELLOW target:self selector:@selector(onHelp:)];
        [self addChild:modelHelp z:zAboveOperation];
        modelHelp.position=ccp(winSize.width+100, -100);
        
//        modelShop= [SpriteUtil createMenuWithImg:@"mode_shop.png" pressedColor:ccYELLOW target:self selector:@selector(onShop:)];
//        [self addChild:modelShop z:zAboveOperation];
//        modelShop.position=ccp(winSize.width+100, winSize.height+100);
        
        
        
        //*/
//        [self performSelector:@selector(showAllMenu) withObject:nil afterDelay:0.5];
         /*/
        [self performSelector:@selector(showMenuModelEndless) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL];
        [self performSelector:@selector(showMenuModelSetting) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*2];
        [self performSelector:@selector(showMenuModelHelp) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*3];
        [self performSelector:@selector(showMenuModelShop) withObject:nil afterDelay:MENU_ANIM_SHOW_INTERVAL*4];
        //*/
        
        NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
        if (![def boolForKey:IS_FAMILY_PLAY]) {
//          if(1){
            [def setBool:YES forKey:IS_FAMILY_PLAY];
            GuideLayer* layer= [GuideLayer node];
            layer.position=ccp(winSize.width/2, winSize.height/2);
            [self addChild:layer z:50];
          }else{
              [self performSelector:@selector(showAllMenu) withObject:nil afterDelay:0.5];
          }
        
	}

	return self;
}
#pragma mark menu
-(void)displayMenuCommingAudio{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"showmenuitme.wav"];
        
    }
}
#pragma mark -
-(void)showAllMenu{
    [self displayMenuCommingAudio];
    [modelEndless runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*1/8+50, winSize.height*2/3)]];
    [modelSetting runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*4/8, winSize.height*1/3)]];
    [modelHelp runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*6/8, winSize.height*2/3)]];
//    [modelShop runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*7/8-50, winSize.height*1/3)]];
}

-(void)showMenuModelEndless{
    [self displayMenuCommingAudio];
    [modelEndless runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*1/8+50, winSize.height*2/3)]];
    }
-(void)showMenuModelSetting{
    [self displayMenuCommingAudio];
    [modelSetting runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*3/8, winSize.height*1/3)]];
}
-(void)showMenuModelHelp{
    [self displayMenuCommingAudio];
    [modelHelp runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*5/8, winSize.height*2/3)]];
}
-(void)showMenuModelShop{
    [self displayMenuCommingAudio];
    [modelShop runAction:[CCMoveTo actionWithDuration:MENU_ANIM_SHOW_INTERVAL position:ccp(winSize.width*7/8-50, winSize.height*1/3)]];
}

#pragma mark -
-(void)showLayerModelEndless{
    [AudioUtil displayAudioButtonClick];
    GameScene* scene= [GameScene node];
    CCLabelBMFont* spinner= [DialogUtil showWaitLable:self];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:scene]];
    [scene.guiLayer gameInit];
    
    [DialogUtil unshowWaitLable:spinner];
}

-(void)setting{
    [AudioUtil displayAudioButtonClick];
    CCScene* sc=[SettingLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}

- (void) OnSettings:(id) sender
{
    [AudioUtil displayAudioButtonClick];
    CCScene* sc=[SettingLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}
- (void) onHelp:(id) sender
{
    /*/
    [AudioUtil displayAudioButtonClick];
    CCScene* sc=[HelpLayer node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
    
/*/
    HelpViewController* cont=[[[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil]autorelease];
    [[CCDirector sharedDirector] presentViewController:cont animated:YES completion:nil];
 //*/
}

-(void)onShop:(id) sender{
    [AudioUtil displayAudioButtonClick];
    UIAlertView* shopAlert=[[[UIAlertView alloc]initWithTitle:nil message:@"remove ad" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil]autorelease];
    [shopAlert show];
}
@end
