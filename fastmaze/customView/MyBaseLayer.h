//
//  MyBaseLayer.h
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "CCLayer.h"

@interface MyBaseLayer : CCLayer
{
    CGSize winSize;
}
+(CCScene*)scene;
-(CGSize)winSize;
-(void)setBgWithFrameName:(NSString*)bgName;
-(void)setBgWithFileName:(NSString*)bgName;
-(void)initSpriteSheetFile:(NSString*)frameName ;
-(void)initSpriteSheetFile:(NSString*)frameName z:(int)z ;
-(void)initSpriteSheetFile:(NSString*)frameName z:(int)z tag:t;

@end
