//
//  CCMenuUtil.h
//  fastmaze
//
//  Created by Eric on 13-1-30.
//
//

#import <Foundation/Foundation.h>

@interface CCMenuUtil : NSObject
+(CCMenu*)createMenuWithImg:(NSString*)img pressedColor:(ccColor3B)color target:(id)target selector:(SEL)selector;
@end
