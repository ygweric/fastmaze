//
//  SysConfig.h
//  birdjump
//
//  Created by Eric on 12-11-20.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    dEasy,
    dNormal,
    dHard,
}eDifficulty;
typedef enum{
    oAcceleration,
    oGesture,
    oMix,
}eOperation;

typedef enum{
    oSmall,
    oNormal,
    oLarge,
    oHuge,
}eMazeSize;

@interface SysConfig : NSObject
+(BOOL) needAudio;
+(void) setNeedAudio:(BOOL)need;
+(BOOL) needMusic;
+(void) setNeedMusic:(BOOL)need;
+(int) difficulty;
+(void) setDifficulty:(int)diff;
+(int) operation;
+(void) setOperation:(int)oper;
+(int) mazeSize;
+(void) setMazeSize:(int)size;

+(BOOL) needLockLevel;
@end
