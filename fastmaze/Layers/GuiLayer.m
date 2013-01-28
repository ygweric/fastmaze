//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "GuiLayer.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
#import "CCDirector.h"
#import "CGPointExtension.h"
#import "Constants.h"
#import "MenuLayer.h"

@implementation GuiLayer
@synthesize gameLayer=_gameLayer;
@synthesize gameSuspended;
@synthesize pauseLayer;

- (id)init
{
    self = [super init];

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    
    CCSprite* backn= [CCSprite spriteWithFile:@"button_previous.png"];
    CCSprite* backs= [CCSprite spriteWithFile:@"button_previous.png"];
    backs.color=ccYELLOW;
    CCMenuItemSprite* backItem=[CCMenuItemSprite itemFromNormalSprite:backn selectedSprite:backs target:self selector:@selector(goBack)];
    CCMenu* back= [CCMenu menuWithItems:backItem, nil];
    [self addChild:back z:zBelowOperation];
    back.position=ccp(winSize.width*1/3, winSize.height-50);

    
    CCSprite* regenerateMazen= [CCSprite spriteWithFile:@"button_new_maze.png"];
    CCSprite* regenerateMazes= [CCSprite spriteWithFile:@"button_new_maze.png"];
    regenerateMazes.color=ccYELLOW;
    CCMenuItemSprite* regenerateMazeItem=[CCMenuItemSprite itemFromNormalSprite:regenerateMazen selectedSprite:regenerateMazes target:self selector:@selector(regenerateMaze)];
    CCMenu* regenerateMaze= [CCMenu menuWithItems:regenerateMazeItem, nil];
    [self addChild:regenerateMaze z:zBelowOperation];
    regenerateMaze.position=ccp(winSize.width*1/2, winSize.height-50);
    
    
    CCSprite* showMazeAnswern= [CCSprite spriteWithFile:@"button_show_answer.png"];
    CCSprite* showMazeAnswers= [CCSprite spriteWithFile:@"button_show_answer.png"];
    showMazeAnswers.color=ccYELLOW;
    CCMenuItemSprite* showMazeAnswerItem=[CCMenuItemSprite itemFromNormalSprite:showMazeAnswern selectedSprite:showMazeAnswers target:self selector:@selector(showMazeAnswer)];
    CCMenu* showMazeAnswer= [CCMenu menuWithItems:showMazeAnswerItem, nil];
    [self addChild:showMazeAnswer z:zBelowOperation];
    showMazeAnswer.position=ccp(winSize.width*2/3, winSize.height-50);
    

    
    //------------
    CCSprite* pn= [CCSprite spriteWithFile:@"button_pause.png"];
    CCSprite* ps= [CCSprite spriteWithFile:@"button_pause.png"];
    CCMenuItemSprite* p=[CCMenuItemSprite itemFromNormalSprite:pn selectedSprite:ps target:self selector:@selector(pauseGame)];
    CCMenu* pauseButton= [CCMenu menuWithItems:p, nil];
    
    pauseButton.position=ccp(winSize.width*2/3+50, winSize.height-50);
    [self addChild:pauseButton z:zBelowOperation tag:tPause];
    
    //暂停layer
    pauseLayer =[CCLayerColor layerWithColor:ccc4(166,166,166,122) ];
    [self addChild:pauseLayer z:zPauseLayer tag:tPauseLayer];
    pauseLayer.visible=NO;
    
    //audio & music
    BOOL isAudioOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_AUDIO];
    CCSprite* audion,*audios;
    if (isAudioOn) {
        audion= [CCSprite spriteWithFile:@"button_audio.png"];
        audios= [CCSprite spriteWithFile:@"button_audio.png"];
    }else{
        audion= [CCSprite spriteWithFile:@"button_audio_bar.png"];
        audios= [CCSprite spriteWithFile:@"button_audio_bar.png"];
    }
    audios.color=ccYELLOW;
    CCMenuItemSprite* audiosa=[CCMenuItemSprite itemFromNormalSprite:audion selectedSprite:audios target:self selector:@selector(audio:)];
    audiosa.tag=tAudioItem;
    CCMenu* audioButton= [CCMenu menuWithItems:audiosa, nil];
    audioButton.position=ccp(winSize.width /2-(IS_IPAD()?100:60), winSize.height*1/3+30);
    [pauseLayer addChild:audioButton z:zAboveOperation tag:tAudio];
    
    BOOL isMusicOn= [[NSUserDefaults standardUserDefaults] boolForKey:UDF_MUSIC];
    CCSprite* musicn,*musics;
    if (isMusicOn) {
        musicn= [CCSprite spriteWithFile:@"button_music.png"];
        musics= [CCSprite spriteWithFile:@"button_music.png"];
    }else{
        musicn= [CCSprite spriteWithFile:@"button_music_bar.png"];
        musics= [CCSprite spriteWithFile:@"button_music_bar.png"];
    }
    musics.color=ccYELLOW;
    CCMenuItemSprite* musicsa=[CCMenuItemSprite itemFromNormalSprite:musicn selectedSprite:musics target:self selector:@selector(music:)];
    musicsa.tag=tMusicItem;
    CCMenu* musicButton= [CCMenu menuWithItems:musicsa, nil];
    musicButton.position=ccp(winSize.width /2+(IS_IPAD()?100:60), winSize.height*1/3+30);
    [pauseLayer addChild:musicButton z:zAboveOperation tag:tMusic];
    
    
    //menu & refresh & start
    CCSprite* mn= [CCSprite spriteWithFile:@"button_menu.png"];
    CCSprite* ms= [CCSprite spriteWithFile:@"button_menu.png"];
    ms.color=ccYELLOW;
    CCMenuItemSprite* msa=[CCMenuItemSprite itemFromNormalSprite:mn selectedSprite:ms target:self selector:@selector(menu)];
    CCMenu* menuButton= [CCMenu menuWithItems:msa, nil];
    menuButton.position=ccp(winSize.width /2-(IS_IPAD()?200:100), winSize.height*1/3-100);
    [pauseLayer addChild:menuButton z:zAboveOperation];
    
    
    
    CCSprite* rsn= [CCSprite spriteWithFile:@"button_refresh.png"];
    CCSprite* rss= [CCSprite spriteWithFile:@"button_refresh.png"];
    rss.color=ccYELLOW;
    CCMenuItemSprite* rsa=[CCMenuItemSprite itemFromNormalSprite:rsn selectedSprite:rss target:self selector:@selector(restartGame)];
    CCMenu* restartButton= [CCMenu menuWithItems:rsa, nil];
    restartButton.position=ccp(winSize.width /2, winSize.height*1/3-100);
    [pauseLayer addChild:restartButton z:zAboveOperation];
    
    
    
    CCSprite* rn= [CCSprite spriteWithFile:@"button_start.png"];
    CCSprite* rs= [CCSprite spriteWithFile:@"button_start.png"];
    rs.color=ccYELLOW;
    CCMenuItemSprite* r=[CCMenuItemSprite itemFromNormalSprite:rn selectedSprite:rs target:self selector:@selector(resumeGame)];
    CCMenu* resumeButton= [CCMenu menuWithItems:r, nil];
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




@end