//
//  CCMenuUtil.h
//  fastmaze
//
//  Created by Eric on 13-1-30.
//
//

#import <Foundation/Foundation.h>

@interface CCMenuUtil : NSObject
+(CCMenu*)createMenuWithImg:(NSString*)img target:(id)target selector:(SEL)selector;
@end
