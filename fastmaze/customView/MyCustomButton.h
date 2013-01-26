//
//  MyCustomButton.m
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "MyCustomButton.h"
#import "MyCustomButtonItem.h"

@interface MyCustomButton : CCMenu {
}
+ (id)buttonWithText:(NSString*)text atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
+ (id)buttonWithText:(NSString*)text fontSize:(int)fontSize fontName:(NSString*)fontName image:(NSString*)image atPosition:(CGPoint)position target:(id)target selector:(SEL)selector ;
+ (id)buttonWithImage:(NSString*)file atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
@end
