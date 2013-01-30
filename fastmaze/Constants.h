//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>

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
    zScoreLablel,
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
    tAudio,
    tAudioItem,
    tMusic,
    tMusicItem,
    tResume,
    tRestart,
    tPauseLayer,
    
    tMazeSize,
    
};


#define kNotiRegenerateMaze  @"__kNotiRegenerateMaze"
#define kNotiShowMazeAnswer  @"__kNotiShowMazeAnswer"


#define MIN_DISTANCE 10.0f
#define MIN_DISTANCE_PERCENT 0.5f

#define MENU_ANIM_SHOW_INTERVAL 0.5f


#define UDF_AUDIO @"UDF_AUDIO"
#define UDF_MUSIC @"UDF_MUSIC"
#define UDF_DIFFICULLY @"UDF_DIFFICULLY"
#define UDF_OPERATION @"UDF_OPERATION"
#define UDF_MAZESIZE @"UDF_MAZESIZE"
#define UDF_LEVEL_SELECTED @"UDF_LEVEL_SELECTED" //选择level，及当前正玩level
#define UDF_LEVEL_PASSED @"UDF_LEVEL_PASSED" //已通过最大level
#define UDF_LEVEL_CURRENT @"UDF_LEVELCURRENT" //当前正玩或刚刚结束level，先不用，以后或许会需要
#define UDF_TOTAL_SCORE @"UDF_TOTAL_SCORE" //用户积分

//FIXME release
#define kMAX_LEVEL_IDEAL 13
#define kMAX_LEVEL_REAL 13

#define MAX_AUTO_STEP 10

#define kGAME_SCORE_MODEL @"score: %d "

