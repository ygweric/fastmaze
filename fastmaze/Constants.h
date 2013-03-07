
typedef enum{
    kUP=1,
    kDOWN,
    kLEFT,
    kRIGHT,
}DIRECTION;

// layer z
enum{
    zBgSpriteSheet,
    zBg,
    zCloud,
    zGameWorldMap,
    zPlatform,
    zParticleExplosion,
    zBirdSpriteSheet,
    zBird,
    zBonusSpriteSheet,
    zBonus,
    zBonusParticle,
    zTimerLablel,
    zButtonSpriteSheet,
    zBelowOperation,
    zPauseLayer,
    zAboveOperation,
    
};


//----tag
enum{
    tCancalEntity=100,
    tCorrectEntity,
    tGame,
    tPause,
    tNextLevel,
    tAudio,
    tAudioItem,
    tMusic,
    tMusicItem,
    tResume,
    tRestart,
    tPauseLayer,
    tOperationLayer,
    tShortestTime,
    tCurrentTime,
    
    tMazeSize,
    
};

typedef enum{
    tLayerPause=200,
    tLayerWin,
    tLayerLose,
    tLayerPrepare,
    tLayerNone,
}LayerType ;



#define KEY_AD_ADWHIRL @"9ad68ef5767447baa1dd37f4d7ae7766"
#define KEY_UMENG @"510b959c5270154d4700000a"

#define MIN_DISTANCE 10.0f
#define MIN_DISTANCE_PERCENT 0.5f

#define MENU_ANIM_SHOW_INTERVAL 0.5f

#define HAVE_SETTED @"HAVE_SETTED"
#define IS_FAMILY_PLAY @"IS_FAMILY_PLAY"

#define UDF_AUDIO @"UDF_AUDIO"
#define UDF_MUSIC @"UDF_MUSIC"
#define UDF_DIFFICULLY @"UDF_DIFFICULLY"
#define UDF_OPERATION @"UDF_OPERATION"
#define UDF_MAZESIZE @"UDF_MAZESIZE"
#define UDF_LEVEL_SELECTED @"UDF_LEVEL_SELECTED" //选择level，及当前正玩level
#define UDF_LEVEL_PASSED @"UDF_LEVEL_PASSED" //已通过最大level
#define UDF_LEVEL_CURRENT @"UDF_LEVELCURRENT" //当前正玩或刚刚结束level，先不用，以后或许会需要
#define UDF_TOTAL_SCORE @"UDF_TOTAL_SCORE" //用户积分

#define UFK_LAST_TIME @"UFK_LAST_TIME"
#define UFK_NEXT_ALERT_RATE_TIME @"UFK_NEXT_ALERT_RATE_TIME"
#define UFK_TOTAL_LAUNCH_COUNT @"UFK_TOTAL_LAUNCH_COUNT"

#define UFK_SHOW_AD @"UFK_SHOW_AD"

#define UFK_CURRENT_VERSION @"UFK_CURRENT_VERSION"

//FIXME release
#define kMAX_LEVEL_IDEAL 13
#define kMAX_LEVEL_REAL 13

#define MAX_AUTO_STEP 7

#define kGAME_INFO_LAST_TIME @"last time: %0.2f s  "
#define kGAME_INFO_CURRENT_TIME @"current time: %0.2f s"

#define kGAME_INFO_RESULT_WIN @"great! you are faster than last time"
#define kGAME_INFO_RESULT_LOSE @"ooh! you are slower than last time"

#define kPREPARE_TIME 1
#define kGUIDE_PAGE_COUNT 4

#define kDEFAULT_LAST_TIME 1*60.0f

//FIXME release
#define kRATE_FIRST_TIME 3 //首次运行n次后提醒评分 5
#define kRATE_DAYS 5*24*60*60    //距离上次评分n天后再次提醒评分 5*24*60*60
#define kRATE_MAX_DAYS kRATE_DAYS*2  //“不再提醒”后提醒的时间间隔

#define kTAG_Ad_VIEW 1101


