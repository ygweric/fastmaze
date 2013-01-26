//
//  MyCustomButtonItem.m
//  birdjump
//
//  Created by Eric on 12-11-24.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "MyCustomButtonItem.h"

@implementation MyCustomButtonItem
+ (id)buttonWithText:(NSString*)text target:(id)target selector:(SEL)selector {
	return [self buttonWithText:text fontSize:0 fontName:nil image:nil target:target selector:selector];
}
+ (id)buttonWithText:(NSString*)text  fontSize:(int)fontSize fontName:(NSString*)fontName image:(NSString*)image target:(id)target selector:(SEL)selector {
	return [[[self alloc] initWithText:text fontSize:fontSize fontName:fontName image:image target:target selector:selector] autorelease];
}

+ (id)buttonWithImage:(NSString*)file target:(id)target selector:(SEL)selector {
	return [[[self alloc] initWithImage:file target:target selector:selector] autorelease];
}

- (id)initWithText:(NSString*)text  fontSize:(int)fontSize fontName:(NSString*)fontName  image:(NSString*)image target:(id)target selector:(SEL)selector {
   	if(self = [super initWithTarget:target selector:selector]) {
        if (image==nil) {
            image=@"custom_button_p.png";
        }
		back = [[CCSprite spriteWithFile:image] retain];
//		back.anchorPoint = ccp(0,0);
		backPressed = [[CCSprite spriteWithFile:image] retain];
//		backPressed.anchorPoint = ccp(0,0);
        //没有设置字体大小的方法，只能设置scale
        backPressed.scale=0.8;
		[self addChild:back];
        
		self.contentSize = back.contentSize;
        CCNode* textLabel;
        if (fontName==nil) {
            //http://iosfonts.com/ 字体查询网站
            textLabel = [CCLabelTTF labelWithString:text fontName:@"Arial Hebrew" fontSize:(fontSize==0)?22:fontSize];
        } else {
            textLabel = [CCLabelBMFont labelWithString:text fntFile:fontName ];
            textLabel.scale=(fontSize==0)?1:fontSize;
        }

//		textLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height* 1/ 3);
        //anchor向下稍移,则文字刚好显示在中间
//		textLabel.anchorPoint = ccp(-0.2, 0);
		[self addChild:textLabel z:1];
	}
    // */
	return self;
}

- (id)initWithText:(NSString*)text target:(id)target selector:(SEL)selector {
   return [self initWithText:text fontSize:0 fontName:nil image:nil target:target selector:selector];
}

- (id)initWithImage:(NSString*)file target:(id)target selector:(SEL)selector {
//    [super tme]
    
	if(self = [super initWithTarget:target selector:selector]) {
        
//        self set
        
		back = [[CCSprite spriteWithFile:@"button.png"] retain];
		back.anchorPoint = ccp(0,0);
		backPressed = [[CCSprite spriteWithFile:@"button_p.png"] retain];
		backPressed.anchorPoint = ccp(0,0);
		[self addChild:back];
        
		self.contentSize = back.contentSize;
        
		CCSprite* image = [CCSprite spriteWithFile:file];
		[self addChild:image z:1];
		image.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
	}
	return self;
}

-(void) selected {
	[self removeChild:back cleanup:NO];
	[self addChild:backPressed];
	[super selected];
}

-(void) unselected {
	[self removeChild:backPressed cleanup:NO];
	[self addChild:back];
	[super unselected];
}

// this prevents double taps
- (void)activate {
	[super activate];
	[self setIsEnabled:NO];
	[self schedule:@selector(resetButton:) interval:0.5];
}

- (void)resetButton:(ccTime)dt {
	[self unschedule:@selector(resetButton:)];
	[self setIsEnabled:YES];
}

- (void)dealloc {
	[back release];
	[backPressed release];
	[super dealloc];
}

@end

