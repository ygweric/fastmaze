//
//  MyBaseLayer.m
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "MyBaseLayer.h"

@implementation MyBaseLayer
+(CCScene*)scene{
    CCScene* sc=[CCScene node];
    MyBaseLayer* node=[self node];
    [sc addChild:node];
    return  sc;
}
-(id)init{
    if (self=[super init]) {
        winSize=[[CCDirector sharedDirector] winSize];
    }
    return self;
}
-(void)setBgWithFrameName:(NSString*)bgName{
    //背景
    CCSprite* bg=[CCSprite spriteWithSpriteFrameName:bgName];
    bg.position=ccp(winSize.width/2, winSize.height/2);
    [self addChild:bg z:-1];
}
-(void)setBgWithFileName:(NSString*)bgName{
    //背景
    CCSprite* bg=[CCSprite spriteWithFile:bgName];
    bg.position=ccp(winSize.width/2, winSize.height/2);
    [self addChild:bg z:-1];
}
-(CGSize)winSize{
    return winSize;
}
-(void)initSpriteSheetFile:(NSString*)frameName {
    [self initSpriteSheetFile:frameName z:0];
}
-(void)initSpriteSheetFile:(NSString*)frameName z:(int)z {
    [self initSpriteSheetFile:frameName z:z tag:0];
}
-(void)initSpriteSheetFile:(NSString*)frameName z:(int)z tag:t{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[frameName stringByAppendingString:@".plist"]];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode
                                            batchNodeWithFile:[frameName stringByAppendingString:@".png"]];
    [self addChild:spriteSheet z:z tag:t];
}
@end
