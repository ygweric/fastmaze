//
//  SettingsLayer.m
//  G03
//
//  Created by Mac Admin on 18/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingLayer.h"
#import "MenuLayer.h"


@implementation SettingLayer


-(id) init
{
	[super init];
    [self initSpriteSheetFile:@"buttons"];
    [self initSpriteSheetFile:@"game_sheet"];
    if (IS_IPHONE_5) {
        [self setBgWithFrameName:@"bg-568h@2x.jpg"];
    }else{
        [self setBgWithFrameName:@"bg.png"];
    }
    CCMenuItemFont *title1 =[CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"Sound Effect" fntFile:@"futura-48.fnt"]];
    [title1 setDisabledColor:title1.color];
    [title1 setIsEnabled:NO];
    title1.scale=IS_RETINA ?1.5:1;
    CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"ON" fntFile:@"futura-48.fnt"]],
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"OFF" fntFile:@"futura-48.fnt"]],
                             nil];
    item1.tag=tAudio;
    item1.scale=IS_RETINA ?1.5:1;
    if ([SysConfig needAudio]) {
        item1.selectedIndex=0;
    } else {
        item1.selectedIndex=1;
    }
    
	 CCLabelBMFont* lable2=[CCLabelBMFont labelWithString:@"Music" fntFile:@"futura-48.fnt"];
    CCMenuItemFont *title2 =[CCMenuItemLabel itemWithLabel:lable2];
    [title2 setDisabledColor:title2.color];
    [title2 setIsEnabled:NO];
    title2.scale=IS_RETINA ?1.5:1;
	CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"ON" fntFile:@"futura-48.fnt"]],
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"OFF" fntFile:@"futura-48.fnt"]],
                               nil];
    item2.tag=tMusic;
    item2.scale=IS_RETINA ?1.5:1;
    if ([SysConfig needMusic]) {
        item2.selectedIndex=0;
    } else {
        item2.selectedIndex=1;
    }
   
        
    CCLabelBMFont* lable5=[CCLabelBMFont labelWithString:@"Maze Size" fntFile:@"futura-48.fnt"];
    CCMenuItemFont *title5 =[CCMenuItemLabel itemWithLabel:lable5];
    [title5 setDisabledColor:title5.color];
    [title5 setIsEnabled:NO];
    title5.scale=IS_RETINA ?1.5:1;
	CCMenuItemToggle *item5 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                               
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"Small" fntFile:@"futura-48.fnt"]],
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"Normal" fntFile:@"futura-48.fnt"]],
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"Large" fntFile:@"futura-48.fnt"]],
                               [CCMenuItemLabel itemWithLabel:[[CCLabelBMFont alloc]initWithString:@"Huge" fntFile:@"futura-48.fnt"]],
                               nil];
	item5.tag=tMazeSize;
    item5.scale=IS_RETINA ?1.5:1;
    // you can change the one of the items by doing this
    item5.selectedIndex = [SysConfig mazeSize];
    
    
    
    CCLabelBMFont *gobackLabel = [CCLabelBMFont labelWithString:@"Go Back" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* back =[CCMenuItemLabel itemWithLabel:gobackLabel target:self selector:@selector(backCallback:)];
    back.scale=IS_RETINA ?1.5:1;
    
    /*
	CCMenu *menu = [CCMenu menuWithItems:
                    title1,item1,
                    title2,item2,
                    title4,item4,
                    title5,item5,                    
                    back, nil]; // 9 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:1],
     nil
	 ]; // 2 + 2 + 2 + 2 + 1 = total count of 9.
     /*/
    CCMenu *menu = [CCMenu menuWithItems:
                    title1,item1,
                    title2,item2,
                    title5,item5,
                    back, nil]; // 9 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:1],
     nil
	 ]; // 2 + 2 + 2 + 2 + 1 = total count of 9.
    //*/
	[self addChild: menu];
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) menuCallback: (id) sender
{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    CCMenuItem* mi=(CCMenuItem*)sender;
	NSLog(@"sender.tag: %d index:%d",mi.tag, [sender selectedIndex] );
    NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
    switch (mi.tag) {
        case tAudio:
            if ([sender selectedIndex]==0) {
                [defaults setBool:YES forKey:UDF_AUDIO];
                [SysConfig setNeedAudio:YES];
            } else {
                [defaults setBool:NO forKey:UDF_AUDIO];
                [SysConfig setNeedAudio:NO];
            }
            break;
        case tMusic:
            if ([sender selectedIndex]==0) {
                [defaults setBool:YES forKey:UDF_MUSIC];
                [SysConfig setNeedMusic:YES];
            } else {
                [defaults setBool:NO forKey:UDF_MUSIC];
                [SysConfig setNeedMusic:NO];
            }
            
            if ([SysConfig needMusic]) {
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gamebg.mp3" loop:YES];
            } else {
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            }
            break;
        case tMazeSize:
            [defaults setInteger:[sender selectedIndex] forKey:UDF_MAZESIZE];
            [SysConfig setMazeSize:[sender selectedIndex]];
            break;
       
    }
    
    
    
}

-(void) backCallback: (id) sender
{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
	CCScene *sc = [CCScene node];
	[sc addChild:[MenuLayer node]];
	
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}
@end
