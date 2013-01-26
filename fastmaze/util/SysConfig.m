//
//  SysConfig.m
//  birdjump
//
//  Created by Eric on 12-11-20.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "SysConfig.h"

@implementation SysConfig


static BOOL sNeedAudio_= YES;
static BOOL sNeedMusic_= YES;
static eDifficulty sDifficulty_= dNormal;
static eOperation sOperation_= oAcceleration;

+(BOOL) needAudio{
    return sNeedAudio_;
}
+(void) setNeedAudio:(BOOL)need{
    sNeedAudio_=need;
}
+(BOOL) needMusic{
    return sNeedMusic_;
}
+(void) setNeedMusic:(BOOL)need{
    sNeedMusic_=need;
}
+(int) difficulty{
    return sDifficulty_;
}
+(void) setDifficulty:(int)diff{
    sDifficulty_=diff;
}
+(int) operation{
    return  sOperation_;
}
+(void) setOperation:(int)oper{
    sOperation_=oper;
}

//FIXME release
+(BOOL) needLockLevel{
//    return NO;
    return YES;
}
@end
