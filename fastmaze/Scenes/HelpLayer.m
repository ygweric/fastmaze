//
//  HelpLayer.m
//  birdjump
//
//  Created by Eric on 12-12-4.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "HelpLayer.h"
#import "MenuLayer.h"
#import "MobClick.h"
@implementation HelpLayer
+(CCScene*)scene{
    CCScene* sc=[CCScene node];
    HelpLayer* la=[HelpLayer node];
    [sc addChild:la];
    return  sc;
}
-(id) init
{
	[super init];
    [self initSpriteSheetFile:@"buttons"];
    [self initSpriteSheetFile:@"game_sheet"];
    if (IS_IPHONE_5) {
        [self setBgWithFrameName:@"bg-568h@2x.jpg"];
    }else{
        [self setBgWithFrameName:@"bg.png"];
    }
    //help content
    CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help" ofType:nil] encoding:NSUTF8StringEncoding error:NULL]
                                        dimensions: CGSizeMake(winSize.width -20, winSize.height)
                                         hAlignment: UITextAlignmentCenter
                                          fontName:@"Arial" fontSize: (IS_IPAD?32:15)];
    
    
    [label setPosition:CGPointMake(winSize.width/2, winSize.height -(IS_IPAD? 140:70))];
    
    [label setColor:ccBLACK];
    [label setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    [self addChild:label];
    
    
    //-----
    CCLabelBMFont *facebookLabel = [CCLabelBMFont labelWithString:@"FaceBook" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* facebook =[CCMenuItemLabel itemWithLabel:facebookLabel target:self selector:@selector(goFacebook:)];
    facebook.scale=IS_RETINA ?1.5:1;
    
    CCLabelBMFont *twitterLabel = [CCLabelBMFont labelWithString:@"Twitter" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* twitter =[CCMenuItemLabel itemWithLabel:twitterLabel target:self selector:@selector(goTwitter:)];
    twitter.scale=IS_RETINA ?1.5:1;
    
    CCLabelBMFont *gorateLabel = [CCLabelBMFont labelWithString:@"Go Rate" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* rate =[CCMenuItemLabel itemWithLabel:gorateLabel target:self selector:@selector(goRate:)];
    rate.scale=IS_RETINA ?1.5:1;
    
    CCLabelBMFont *mailMeLabel = [CCLabelBMFont labelWithString:@"Mail Me" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* mail =[CCMenuItemLabel itemWithLabel:mailMeLabel target:self selector:@selector(mailMe:)];
    mail.scale=IS_RETINA ?1.5:1;
    

    
    // go back
    CCLabelBMFont *gobackLabel = [CCLabelBMFont labelWithString:@"Go Back" fntFile:@"futura-48.fnt"];
    CCMenuItemLabel* back =[CCMenuItemLabel itemWithLabel:gobackLabel target:self selector:@selector(backCallback:)];
    back.scale=IS_RETINA ?1.5:1;
    
    
    CCMenu *menu = [CCMenu menuWithItems:
                    facebook,twitter,rate,mail, back, nil];
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:1],
     nil
	 ];
    menu.anchorPoint=CGPointZero;
    menu.position=ccp(winSize.width/2,(IS_IPAD? 140:110));
	[self addChild: menu];
    
    
    return self;
}
-(void) backCallback: (id) sender
{
	[AudioUtil displayAudioButtonClick];	
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:[MenuLayer scene]]];
}
-(void)goFacebook:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/playbastudio"]];
    [MobClick event:@"facebook"];
}
-(void)goTwitter:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/playbastudio"]];
    [MobClick event:@"twitter"];
}
-(void)goRate:(id)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=597108795"]];
    [MobClick event:@"rateme"];
}

-(void)mailMe:(id)sender{
    NSString *url = @"mailto:ygweric@gmail.com?subject=about%20fastmaze";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    [MobClick event:@"mailme"];
}
@end
