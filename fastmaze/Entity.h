//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@interface Entity : CCSprite

- (void)beginMovement;

- (void)dropCurrent:(id)node;
- (void)dropCancelled:(id)node;

@end