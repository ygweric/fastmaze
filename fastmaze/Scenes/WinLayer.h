//
//  WinLayer.h
//  birdjump
//
//  Created by Eric on 12-11-21.
//  Copyright (c) 2012年 Symetrix. All rights reserved.
//

#import "CCLayer.h"

@interface WinLayer : MyBaseLayer
@property (retain,nonatomic) CCLabelBMFont *scoreLabel ;
@property (retain,nonatomic) CDSoundSource* loopSound ;
@property (retain,nonatomic)CCSprite* birdSprite;
@property int score;
@end
