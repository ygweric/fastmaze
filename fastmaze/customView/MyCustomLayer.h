//
//  MyCustomLayer.h
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
-(CGSize)winSize;
-(void)setBg:(NSString*)bgName;
@end
