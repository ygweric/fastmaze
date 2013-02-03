//
//  AutioUtil.m
//  fastmaze
//
//  Created by Eric on 13-2-3.
//
//

#import "AudioUtil.h"

@implementation AudioUtil
+(void)displayAudioButtonClick{
    if ([SysConfig needAudio]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"button_select.mp3"];
    }
}
@end
