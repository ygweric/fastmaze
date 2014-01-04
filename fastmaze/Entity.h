//
// @author Eric Yang <ygweric@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@interface Entity : CCSprite
@property (nonatomic, retain) NSMutableArray *currentEntities;
@property (nonatomic, retain) NSMutableArray *cancelledEntities;
- (void)beginMovement;

- (void)dropCurrent:(id)node;
- (void)dropCancelled:(id)node;
- (BOOL)backToPosition:(CGPoint )destPos mazeGird:(NSMutableDictionary*)grid;
@end