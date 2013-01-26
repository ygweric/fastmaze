//
//  MyCustomButton.h
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//
#import "MyCustomButton.h"

@implementation MyCustomButton
+ (id)buttonWithText:(NSString*)text atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
    return [self buttonWithText:text fontSize:0 fontName:nil image:nil atPosition:position target:target selector:selector];
}
/*
 fontsize=0，使用默认大小
 fontName=nil，使用默认字体
 image=nil， 默认按钮背景
 ---------
 menu.position 是从右上角->左下角进行menu布局的，很奇怪，
 估计是menu不能知道自己itme总大小的缘故吧
 */
+ (id)buttonWithText:(NSString*)text fontSize:(int)fontSize fontName:(NSString*)fontName image:(NSString*)image atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCMenu *menu = [CCMenu menuWithItems:[MyCustomButtonItem buttonWithText:text fontSize:fontSize fontName:fontName image:image target:target selector:selector], nil];
	menu.position = position;
	return menu;
}

+ (id)buttonWithImage:(NSString*)file atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCMenu *menu = [CCMenu menuWithItems:[MyCustomButtonItem buttonWithImage:file target:target selector:selector], nil];
	menu.position = position;
	return menu;
}
@end

