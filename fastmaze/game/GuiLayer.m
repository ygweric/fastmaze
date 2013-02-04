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
#import "GameLayer.h"

@implementation GuiLayer
{
    CGSize winSize;
    CCProgressTimer* progressTimer;
    CCLabelBMFont *lastTimeLable;
    CCLabelBMFont *currentTimeLable;
    float lastTime;
    float takedTime;
    int prepareTime;
    CCLabelBMFont *prepareLable;
}


@synthesize gameLayer=_gameLayer;
@synthesize isPause;
@synthesize isOver;


- (id)init
{
    self = [super init];
    winSize = [[CCDirector sharedDirector] winSize];
    
    progressTimer=[CCProgressTimer progressWithFile:@"progress_bar.png"];
    progressTimer.position=ccp( winSize.width*1/2 , winSize.height-30);
    progressTimer.anchorPoint=ccp(0.5, 1);
    progressTimer.type=kCCProgressTimerTypeHorizontalBarRL;  
    CCSprite* progressTimerBg=[CCSprite spriteWithFile:@"progress_bar_bg.png"];
    progressTimerBg.position=progressTimer.position;
    progressTimerBg.anchorPoint=ccp(0.5, 1);
    [self addChild:progressTimerBg z:zBelowOperation];
    [self addChild:progressTimer z:zBelowOperation];
    
    lastTimeLable = [CCLabelBMFont labelWithString:[NSString stringWithFormat:kGAME_INFO_LAST_TIME,0.0f] fntFile:@"futura-48.fnt"];
	[self addChild:lastTimeLable z:zBelowOperation tag:tShortestTime];
	lastTimeLable.position = ccp(winSize.width/2-120,winSize.height-(IS_IPAD()?70:40));
    lastTimeLable.scale=0.5;
    
    currentTimeLable=[CCLabelBMFont labelWithString:[NSString stringWithFormat:kGAME_INFO_CURRENT_TIME,0.0f] fntFile:@"futura-48.fnt"];
    [self addChild:currentTimeLable z:zBelowOperation tag:tCurrentTime];
	currentTimeLable.position = ccp(winSize.width/2+120,winSize.height-(IS_IPAD()?70:40));
    currentTimeLable.scale=0.5;
    
    

//    CCMenu* back= [SpriteUtil createMenuWithImg:@"button_previous.png" pressedColor:ccYELLOW target:self selector:@selector(goBack)];
//    [self addChild:back z:zBelowOperation];
//    back.position=ccp(winSize.width*1/3-200, winSize.height-50);


    CCMenu* pauseButton= [SpriteUtil createMenuWithImg:@"button_pause.png" pressedColor:ccYELLOW target:self selector:@selector(pauseGame)];    
    pauseButton.position=ccp(winSize.width*2/3+200, winSize.height-50);
    [self addChild:pauseButton z:zBelowOperation tag:tPause];
    
    CCMenu* nextLevelButton= [SpriteUtil createMenuWithImg:@"button_next_level.png" pressedColor:ccYELLOW target:self selector:@selector(nextLevel)];
    nextLevelButton.position=ccp(winSize.width*2/3+200, winSize.height-50);
    [self addChild:nextLevelButton z:zBelowOperation tag:tNextLevel];
    nextLevelButton.visible=NO;

    return self;
}
-(void) update:(ccTime)delta{
//    NSLog(@"update--");
    progressTimer.percentage += delta * 100/lastTime;
    if (progressTimer.percentage >= 100)
    {
        progressTimer.percentage = 0;
    }
    takedTime+=delta;
    [currentTimeLable setString:[NSString stringWithFormat:kGAME_INFO_CURRENT_TIME,takedTime]];
}



- (id)initWithGameLayer:(GameLayer*)gameLayer
{
    self = [self init];
    self.gameLayer=gameLayer;
    return self;
}



#pragma mark menu
-(void)goBack{
    [AudioUtil displayAudioButtonClick];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSplitRows transitionWithDuration:1.0f scene:[MenuLayer scene]]];
    
}
- (void)regenerateMaze:(id)sender
{
    [AudioUtil displayAudioButtonClick];
    [self regenerateMaze];
    
}
- (void)regenerateMaze
{
    isOver=YES;
    isPause=YES;
    [self showOperationLayer:NO];
    [self showPauseButton:YES];
    [_gameLayer regenerateMaze];
    [self gameInit];
    
}
- (void)showMazeAnswer
{
    [AudioUtil displayAudioButtonClick];
    isOver=YES;
    isPause=NO;
    [_gameLayer showMazeAnswer];
    [self showOperationLayer:NO];
    [self showPauseButton:NO];
}
-(void)pauseGame{
    if (!isPause) {
        [AudioUtil displayAudioButtonClick];
        [self showOperationLayer:YES type:tLayerPause];
    }
    isPause=YES;
    [self unscheduleUpdate];
}
-(void)audio:(id)sender{
    if (![SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
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
    [AudioUtil displayAudioButtonClick];
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
    [AudioUtil displayAudioButtonClick];
    [self showOperationLayer:NO];
    [self showPrepareLayer];
    
}
-(void)nextLevel{
    [AudioUtil displayAudioButtonClick];
    [self showOperationLayer:NO];
    [self regenerateMaze];
}

-(void)restartGame{
    [AudioUtil displayAudioButtonClick];
    [self showOperationLayer:NO];
    [_gameLayer restartGame];
    [self gameInit];
}
-(void) menu
{
    [AudioUtil displayAudioButtonClick];
	CCScene *sc = [CCScene node];
	[sc addChild:[MenuLayer node]];
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:sc]];
}

#pragma mark -
-(void)gameInit{
    isPause=YES;
    isOver=YES;
    progressTimer.percentage=100;
    takedTime=0;
    lastTime=[[NSUserDefaults standardUserDefaults]floatForKey:UFK_LAST_TIME];
    if (lastTime<=0) {
        lastTime=kDEFAULT_LAST_TIME;
    }
    [lastTimeLable setString:[NSString stringWithFormat:kGAME_INFO_LAST_TIME,lastTime]];
    [self showPrepareLayer];
}
-(void)showPauseButton:(BOOL)show{
    [self getChildByTag:tPause].visible=show;
    [self getChildByTag:tNextLevel].visible=!show;
}


#pragma mark operation layer

-(void)showOperationLayer:(BOOL)show{
    [self showOperationLayer:show type:tLayerNone];    
}
- (void)initBaseOperationLayer:(CCLayer *)operationLayer {
    //---same for all kind of layer
    //audio & music
    BOOL isAudioOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_AUDIO];
    CCMenu* audioButton=nil;
    if (isAudioOn) {
        audioButton=[SpriteUtil createMenuWithImg:@"button_audio.png" pressedColor:ccYELLOW target:self selector:@selector(audio:)];
    }else{
        audioButton=[SpriteUtil createMenuWithImg:@"button_audio_bar.png" pressedColor:ccYELLOW target:self selector:@selector(audio:)];
    }
    audioButton.position=ccp(winSize.width /2-(IS_IPAD()?100:60), winSize.height*1/3+30);
    [operationLayer addChild:audioButton z:zAboveOperation tag:tAudio];
    
    BOOL isMusicOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_MUSIC];
    CCMenu* musicButton=nil;
    if (isMusicOn) {
        musicButton=[SpriteUtil createMenuWithImg:@"button_music.png" pressedColor:ccYELLOW target:self selector:@selector(music:)];
    }else{
        musicButton=[SpriteUtil createMenuWithImg:@"button_music_bar.png" pressedColor:ccYELLOW target:self selector:@selector(music:)];
    }
    musicButton.position=ccp(winSize.width /2+(IS_IPAD()?100:60), winSize.height*1/3+30);
    [operationLayer addChild:musicButton z:zAboveOperation tag:tMusic];
    
    //menu & refresh & start
//    CCMenu* menuButton= [SpriteUtil createMenuWithImg:@"button_menu.png" pressedColor:ccYELLOW target:self selector:@selector(menu)];
//    menuButton.position=ccp(winSize.width /2-(IS_IPAD()?200:100), winSize.height*1/3-100);
//    [operationLayer addChild:menuButton z:zAboveOperation];
    
    CCMenu* back= [SpriteUtil createMenuWithImg:@"button_previous.png" pressedColor:ccYELLOW target:self selector:@selector(goBack)];
    [operationLayer addChild:back z:zBelowOperation];
    back.position=ccp(winSize.width /2-(IS_IPAD()?200:100), winSize.height*1/3-100);
    
    CCMenu* restartButton= [SpriteUtil createMenuWithImg:@"button_refresh.png" pressedColor:ccYELLOW target:self selector:@selector(restartGame)];
    restartButton.position=ccp(winSize.width /2, winSize.height*1/3-100);
    [operationLayer addChild:restartButton z:zAboveOperation];
}
-(void)showOverLayer:(CCLayer *)operationLayer isWin:(BOOL)isWin{
    {
        if ([SysConfig needAudio]){
            if (isWin) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"win.mp3"];
            } else {
                [[SimpleAudioEngine sharedEngine] playEffect:@"lose.mp3"];
            }
        
        }
        isOver=YES;
        [self unscheduleUpdate];
        [self initBaseOperationLayer:operationLayer];
        
        CCMenu* nextLevelButton=[SpriteUtil createMenuWithImg:@"button_next_level.png" pressedColor:ccYELLOW target:self selector:@selector(nextLevel)];
        nextLevelButton.position=ccp(winSize.width/2+(IS_IPAD()?200:100), winSize.height*1/3-100);
        [operationLayer addChild:nextLevelButton z:zAboveOperation];
        
        CCLabelBMFont* resultLable =nil;
        if (isWin) {
            resultLable = [CCLabelBMFont labelWithString:kGAME_INFO_RESULT_WIN fntFile:@"futura-48.fnt"];
        } else {
            resultLable = [CCLabelBMFont labelWithString:kGAME_INFO_RESULT_LOSE fntFile:@"futura-48.fnt"];
        }
        [operationLayer addChild:resultLable z:zBelowOperation tag:tShortestTime];
        resultLable.position = ccp(winSize.width/2, winSize.height*2/3-100);
        
        
        
        CCSprite* winGoodSprite=nil;
        if (isWin) {
            winGoodSprite=[CCSprite spriteWithFile:@"result_win_good.png"];
        } else {
            winGoodSprite=[CCSprite spriteWithFile:@"result_lose.png"];
        }
        
        winGoodSprite.position=ccp(winSize.width/2, winSize.height*2/3+100);
        [operationLayer addChild:winGoodSprite z:zAboveOperation];
        
        [[NSUserDefaults standardUserDefaults] setFloat:takedTime forKey:UFK_LAST_TIME];
    }
}
-(void)showOperationLayer:(BOOL)show type:(LayerType)layerType{
    if (show) {
        //暂停layer
        CCLayer* operationLayer =[CCLayerColor layerWithColor:ccc4(166,166,166,122) ];
        [self addChild:operationLayer z:zPauseLayer tag:tOperationLayer];
        operationLayer.isTouchEnabled=NO;
        self.isTouchEnabled=NO;
        switch (layerType) {
            case tLayerPause:
            {
                [self initBaseOperationLayer:operationLayer];
                
                CCMenu* regenerateMaze=[SpriteUtil createMenuWithImg:@"button_new_maze.png" pressedColor:ccYELLOW target:self selector:@selector(regenerateMaze:)];
                [operationLayer addChild:regenerateMaze z:zBelowOperation];
                regenerateMaze.position=ccp(winSize.width*1/3, winSize.height*1/3+160);
                
                
                CCMenu* showMazeAnswer= [SpriteUtil createMenuWithImg:@"button_show_answer.png" pressedColor:ccYELLOW target:self selector:@selector(showMazeAnswer)];
                [operationLayer addChild:showMazeAnswer z:zBelowOperation];
                showMazeAnswer.position=ccp(winSize.width*2/3, winSize.height*1/3+160);
                
                CCMenu* resumeButton=[SpriteUtil createMenuWithImg:@"button_start.png" pressedColor:ccYELLOW target:self selector:@selector(resumeGame)];
                resumeButton.position=ccp(winSize.width/2+(IS_IPAD()?200:100), winSize.height*1/3-100);
                [operationLayer addChild:resumeButton z:zAboveOperation];
            }
                
                break;
            case tLayerWin:
            {
                [self showOverLayer:operationLayer isWin:(takedTime<lastTime)];
            }
                
                break;
            case tLayerLose:
            {
                
            }
                break;
            case tLayerPrepare:
            {
                prepareLable = [CCLabelBMFont labelWithString:@"" fntFile:@"futura-48.fnt"];
                [operationLayer addChild:prepareLable z:zBelowOperation];
                prepareLable.position = ccp(winSize.width/2,winSize.height/2);
                prepareLable.scale=2;
                [self updatePrepareTimer];
            }
                break;
            case tLayerNone:
            {
                
            }
                break;
        }
    } else {
        CCLayer* pl=(CCLayer*)[self getChildByTag:tOperationLayer];
        [pl removeAllChildrenWithCleanup:YES];
        [pl removeFromParentAndCleanup:YES];
    }    
}

-(void)showPrepareLayer{
    prepareTime=kPREPARE_TIME;
    [self showOperationLayer:YES type:tLayerPrepare];
}
//显示准备倒计时
-(void)updatePrepareTimer{
    if (prepareTime>0) {
        [prepareLable setString:[NSString stringWithFormat:@"%d",prepareTime]];
        [self performSelector:@selector(updatePrepareTimer) withObject:nil afterDelay:1];
        prepareTime--;
    }else{
        isPause=NO;
        isOver=NO;
        [self scheduleUpdate];
        [self showOperationLayer:NO];
    }
}

@end