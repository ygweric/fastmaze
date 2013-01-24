//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "Entity.h"
#import "CCActionInterval.h"
#import "CGPointExtension.h"

@interface Entity ()
@property (nonatomic, retain) NSMutableArray *currentEntities;
@property (nonatomic, retain) NSMutableArray *cancelledEntities;
@end

@implementation Entity
@synthesize currentEntities = _currentEntities;
@synthesize cancelledEntities = _cancelledEntities;


- (id)init
{
    self = [super init];
    CCSprite *glow = [CCSprite spriteWithFile:@"entity.png"];
    [glow setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    id sequence = [CCSequence actions:
        [CCFadeTo actionWithDuration:0.5f opacity:100],
        [CCFadeTo actionWithDuration:0.5f opacity:255],
        nil
    ];
    [glow runAction:[CCRepeatForever actionWithAction:sequence]];
    [glow setPosition:ccp(glow.textureRect.size.width/2, glow.textureRect.size.height/2)];
    [self addChild:glow];
    self.currentEntities = [NSMutableArray arrayWithCapacity:20];
    self.cancelledEntities = [NSMutableArray arrayWithCapacity:20];
    return self;
}

- (void)beginMovement
{
    [self stopAllActions];
    [_currentEntities enumerateObjectsUsingBlock:
        ^(id sprite, NSUInteger key, BOOL *stop) {
            [self.parent removeChild:sprite cleanup:YES];
        }
    ];
    [_currentEntities removeAllObjects];
    
    [_cancelledEntities enumerateObjectsUsingBlock:
        ^(id sprite, NSUInteger key, BOOL *stop) {
            [self.parent removeChild:sprite cleanup:YES];
        }
    ];
    [_cancelledEntities removeAllObjects];
}

- (void)dropCurrent:(CCSprite *)node
{
    CCSprite *current = [CCSprite spriteWithFile:@"entity.png"];
    [current setColor:ccBLUE];
    [current setPosition:position_];
    [_currentEntities addObject:current];
    [self.parent addChild:current];
}

- (void)dropCancelled:(CCSprite *)node
{
    CGPoint pos = position_;
    __block CCSprite *current = nil;
    __block NSUInteger currentKey = 0;
    [_currentEntities enumerateObjectsUsingBlock:
        ^(id sprite, NSUInteger key, BOOL *stop) {
            if (CGPointEqualToPoint([sprite position], pos)) {
                current = sprite;
                currentKey = key;
                *stop = YES;
            }
        }
    ];
    [self.parent removeChild:current cleanup:YES];
    [_currentEntities removeObjectAtIndex:currentKey];
    CCSprite *cancelled = [CCSprite spriteWithFile:@"entity.png"];
    [cancelled setColor:ccc3(100, 100, 100)];
    [cancelled setPosition:pos];
    [_cancelledEntities addObject:cancelled];
    [self.parent addChild:cancelled];
}

- (void)dealloc {
    [_currentEntities release];
    [_cancelledEntities release];
    [super dealloc];
}

@end