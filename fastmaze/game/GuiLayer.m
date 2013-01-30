//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//
#import <UIKit/UIKit.h>
#import "GuiLayer.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
#import "CCDirector.h"
#import "CGPointExtension.h"
#import "Constants.h"
#import "MenuLayer.h"
#import "HelpLayer.h"

@implementation GuiLayer
@synthesize gameLayer=_gameLayer;
@synthesize gameSuspended;
@synthesize pauseLayer;

- (id)init
{
    self = [super init];

    CGSize winSize = [[CCDirector sharedDirector] winSize];


    CCMenu* back= [CCMenuUtil createMenuWithImg:@"button_previous.png" pressedColor:ccYELLOW target:self selector:@selector(goBack)]; 
    [self addChild:back z:zBelowOperation];
    back.position=ccp(winSize.width*1/3, winSize.height-50);

    CCMenu* regenerateMaze=[CCMenuUtil createMenuWithImg:@"button_new_maze.png" pressedColor:ccYELLOW target:self selector:@selector(regenerateMaze)];
    [self addChild:regenerateMaze z:zBelowOperation];
    regenerateMaze.position=ccp(winSize.width*1/2, winSize.height-50);
    

    CCMenu* showMazeAnswer= [CCMenuUtil createMenuWithImg:@"button_show_answer.png" pressedColor:ccYELLOW target:self selector:@selector(showMazeAnswer)]; 
    [self addChild:showMazeAnswer z:zBelowOperation];
    showMazeAnswer.position=ccp(winSize.width*2/3, winSize.height-50);
    

//    CCMenu* helpButton= [CCMenuUtil createMenuWithImg:@"button_help.png" pressedColor:ccYELLOW target:self selector:@selector(help)];    
//    helpButton.position=ccp(winSize.width*1/3-100, winSize.height-50);
//    [self addChild:helpButton z:zBelowOperation];
    //------------

    CCMenu* pauseButton= [CCMenuUtil createMenuWithImg:@"button_pause.png" pressedColor:ccYELLOW target:self selector:@selector(pauseGame)];    
    pauseButton.position=ccp(winSize.width*2/3+100, winSize.height-50);
    [self addChild:pauseButton z:zBelowOperation tag:tPause];
    
    //暂停layer
    pauseLayer =[CCLayerColor layerWithColor:ccc4(166,166,166,122) ];
    [self addChild:pauseLayer z:zPauseLayer tag:tPauseLayer];
    pauseLayer.visible=NO;
    
    //audio & music
    
    BOOL isAudioOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_AUDIO];
    CCMenu* audioButton=nil;
    if (isAudioOn) {
        audioButton=[CCMenuUtil createMenuWithImg:@"button_audio.png" pressedColor:ccYELLOW target:self selector:@selector(audio:)];
    }else{
        audioButton=[CCMenuUtil createMenuWithImg:@"button_audio_bar.png" pressedColor:ccYELLOW target:self selector:@selector(audio:)];
    }
    audioButton.position=ccp(winSize.width /2-(IS_IPAD()?100:60), winSize.height*1/3+30);
    [pauseLayer addChild:audioButton z:zAboveOperation tag:tAudio];
    
    BOOL isMusicOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_MUSIC];
    CCMenu* musicButton=nil;
    if (isMusicOn) {
        musicButton=[CCMenuUtil createMenuWithImg:@"button_music.png" pressedColor:ccYELLOW target:self selector:@selector(music:)];
    }else{
        musicButton=[CCMenuUtil createMenuWithImg:@"button_music_bar.png" pressedColor:ccYELLOW target:self selector:@selector(music:)];
    }
    musicButton.position=ccp(winSize.width /2+(IS_IPAD()?100:60), winSize.height*1/3+30);
    [pauseLayer addChild:musicButton z:zAboveOperation tag:tMusic];
    
    
    //menu & refresh & start
    CCMenu* menuButton= [CCMenuUtil createMenuWithImg:@"button_menu.png" pressedColor:ccYELLOW target:self selector:@selector(menu)]; 
    menuButton.position=ccp(winSize.width /2-(IS_IPAD()?200:100), winSize.height*1/3-100);
    [pauseLayer addChild:menuButton z:zAboveOperation];
    
    CCMenu* restartButton= [CCMenuUtil createMenuWithImg:@"button_refresh.png" pressedColor:ccYELLOW target:self selector:@selector(restartGame)];
    restartButton.position=ccp(winSize.width /2, winSize.height*1/3-100);
    [pauseLayer addChild:restartButton z:zAboveOperation];
    
    CCMenu* resumeButton=[CCMenuUtil createMenuWithImg:@"button_start.png" pressedColor:ccYELLOW target:self selector:@selector(restartGame)];
    resumeButton.position=ccp(winSize.width/2+(IS_IPAD()?200:100), winSize.height*1/3-100);
    [pauseLayer addChild:resumeButton z:zAboveOperation];
    
    return self;
}

-(void)goBack{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:[MenuLayer scene]]];
}
- (id)initWithGameLayer:(GameLayer*)gameLayer
{
    self = [self init];
    self.gameLayer=gameLayer;
    return self;
}

- (void)regenerateMaze
{
    [_gameLayer regenerateMaze];
}
- (void)showMazeAnswer
{
    [_gameLayer showMazeAnswer];
}

#pragma mark menu

-(void)pauseGame{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    gameSuspended=YES;
    [self showPauseLayer:YES];
    
}
-(void)audio:(id)sender{
    CCMenuItemSprite* i=(CCMenuItemSprite*)sender;
    NSUserDefaults* def= [NSUserDefaults standardUserDefaults];
    BOOL isAudioOn= ![def boolForKey:UDF_AUDIO];
    [def setBool:isAudioOn forKey:UDF_AUDIO];
    [SysConfig setNeedAudio:isAudioOn];
    CCSprite* audion,*audios;
    if (isAudioOn) {
        audion= [CCSprite spriteWithFile:@"button_audio.png"];
        audios= [CCSprite spriteWithFile:@"button_audio.png"];
    }else{
        audion= [CCSprite spriteWithFile:@"button_audio_bar.png"];
        audios= [CCSprite spriteWithFile:@"button_audio_bar.png"];
    }
    audios.color=ccYELLOW;
    i.normalImage = audion;
    i.selectedImage=audios;
    
}
-(void)music:(id)sender{
    CCMenuItemSprite* i=(CCMenuItemSprite*)sender;
    NSUserDefaults* def= [NSUserDefaults standardUserDefaults];
    BOOL isMusicOn= ![def boolForKey:UDF_MUSIC];
    [def setBool:isMusicOn forKey:UDF_MUSIC];
    [SysConfig setNeedMusic:isMusicOn];
    if (isMusicOn) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gamebg.mp3" loop:YES];
    } else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    
    CCSprite* musicn,*musics;
    if (isMusicOn) {
        musicn= [CCSprite spriteWithFile:@"button_music.png"];
        musics= [CCSprite spriteWithFile:@"button_music.png"];
    }else{
        musicn= [CCSprite spriteWithFile:@"button_music_bar.png"];
        musics= [CCSprite spriteWithFile:@"button_music_bar.png"];
    }
    musics.color=ccYELLOW;
    i.normalImage = musicn;
    i.selectedImage=musics;
    
}
-(void)resumeGame{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
    gameSuspended=NO;
    [self showPauseLayer:NO];
}
-(void)restartGame{
    
    
    [self showPauseLayer:NO];
}
-(void) menu
{
	CCScene *sc = [CCScene node];
	[sc addChild:[MenuLayer node]];
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}
-(void)showPauseLayer:(BOOL)show{
    CCLayer* pl=(CCLayer*)[self getChildByTag:tPauseLayer];
    pl.visible=show;
    pl.isTouchEnabled=!show;
}

-(void)help{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:[HelpLayer scene]]];
    
    /*
    FIXME scene方向会改变，不知道原因
    AppDelegate* delegate=(AppDelegate*) [[UIApplication sharedApplication]delegate];
    HelpViewController* controller= [[[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil]autorelease];
    NSLog(@"--self.boundingBox.size width:%f,height:%f",self.boundingBox.size.width,self.boundingBox.size.height);
    NSLog(@"delegate.viewController.view:%@",delegate.viewController);

    [delegate.viewController presentModalViewController:controller animated:YES];
    NSLog(@"--self.boundingBox.size width:%f,height:%f",self.boundingBox.size.width,self.boundingBox.size.height);
     */
}


@end