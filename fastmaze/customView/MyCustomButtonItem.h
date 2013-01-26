//
//  MyCustomButtonItem.h
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "CCLayer.h"

@interface MyCustomButtonItem : CCMenuItemImage {
	CCSprite *back;
	CCSprite *backPressed;
}
+ (id)buttonWithText:(NSString*)text target:(id)target selector:(SEL)selector;
+ (id)buttonWithText:(NSString*)text  fontSize:(int)fontSize fontName:(NSString*)fontName image:(NSString*)image target:(id)target selector:(SEL)selector ;
+ (id)buttonWithImage:(NSString*)file target:(id)target selector:(SEL)selector;
- (id)initWithText:(NSString*)text target:(id)target selector:(SEL)selector;
- (id)initWithImage:(NSString*)file target:(id)target selector:(SEL)selector;
@end