//
//  CCMenuUtil.m
//  fastmaze
//
//  Created by Eric on 13-1-30.
//
//

#import "CCMenuUtil.h"

@implementation CCMenuUtil
+(CCMenu*)createMenuWithImg:(NSString*)img pressedColor:(ccColor3B)color target:(id)target selector:(SEL)selector{
    CCSprite* pn= [CCSprite spriteWithFile:img];
    CCSprite* ps= [CCSprite spriteWithFile:img];
    ps.color=color;
    CCMenuItemSprite* p=[CCMenuItemSprite itemFromNormalSprite:pn selectedSprite:ps target:target selector:selector];
    return [CCMenu menuWithItems:p, nil];
}
@end
