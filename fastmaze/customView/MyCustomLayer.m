//
//  MyCustomLayer.m
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "MyCustomLayer.h"

@implementation MyBaseLayer
-(void)setBg:(NSString*)bgName{
    //背景
    CCSprite* bg=[CCSprite spriteWithFile:bgName];
    winSize=[[CCDirector sharedDirector] winSize];
    
    bg.position=ccp(winSize.width/2, winSize.height/2);
    [self addChild:bg z:-1];
}
-(CGSize)winSize{
    return winSize;
}

@end
