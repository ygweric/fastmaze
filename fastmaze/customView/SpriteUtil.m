//
//  CCMenuUtil.m
//  fastmaze
//
//  Created by Eric on 13-1-30.
//
//

#import "SpriteUtil.h"

@implementation SpriteUtil
+(CCMenu*)createMenuWithImg:(NSString*)img pressedColor:(ccColor3B)color target:(id)target selector:(SEL)selector{
    CCSprite* pn= [CCSprite spriteWithFile:img];
    CCSprite* ps= [CCSprite spriteWithFile:img];
    ps.color=color;
    CCMenuItemSprite* p=[CCMenuItemSprite itemWithNormalSprite:pn selectedSprite:ps target:target selector:selector];
    return [CCMenu menuWithItems:p, nil];
}
+(CCMenu*)createMenuWithFrame:(NSString*)img pressedColor:(ccColor3B)color target:(id)target selector:(SEL)selector{
    CCSprite* pn= [CCSprite spriteWithSpriteFrameName:img];
    CCSprite* ps= [CCSprite spriteWithSpriteFrameName:img];
    ps.color=color;
    CCMenuItemSprite* p=[CCMenuItemSprite itemWithNormalSprite:pn selectedSprite:ps target:target selector:selector];
    return [CCMenu menuWithItems:p, nil];
}
@end
