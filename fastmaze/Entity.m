//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import "Entity.h"
#import "CCActionInterval.h"
#import "CGPointExtension.h"
#import "MazeCell.h"

@interface Entity ()

@end

@implementation Entity
@synthesize currentEntities = _currentEntities;
@synthesize cancelledEntities = _cancelledEntities;

#pragma mark -
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
//查找前的清空工作
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
//     NSLog(@"---dropCurrent-----");
    //检测蓝点
    int destIndex = -1;
    for (int i=0; i<_currentEntities.count; i++) {
        if (CGPointEqualToPoint(((Entity*)[_currentEntities objectAtIndex:i]).position, position_)) {
            destIndex=i;
            break;
        }
    }
//    if (0) {
    if (destIndex>0) {
        //如果有，则置为灰色
        [self.parent removeChild:[_currentEntities objectAtIndex:destIndex] cleanup:YES];
        [_currentEntities removeObjectAtIndex:destIndex];
        [self justDropCancelled:position_];
    } else {
        //否则，置蓝点
        CCSprite *current = [CCSprite spriteWithFile:@"entity.png"];
        current.tag=tCorrectEntity;
        [current setColor:ccBLUE];
        [current setPosition:position_];
        [_currentEntities addObject:current];
        [self.parent addChild:current];
    }
    
    
    
   
    
   }
/*
 撤销蓝点到指定position，走过的点置灰
 return YES撤销成功
 NO包括 1、不是蓝点。2、
 */
- (BOOL)backToPosition:(CGPoint )destPos mazeGird:(NSMutableDictionary*)grid 
{
    NSLog(@"backToPosition--- x:%f,y:%f",destPos.x,destPos.y);
    __block float destDistance = INFINITY;
    __block CGPoint destPosition=CGPointZero;//目标点的标准cell坐标
    [grid enumerateKeysAndObjectsUsingBlock:
     ^(id key, id cell, BOOL *stop) {
         MazeCell *mazeCell = (MazeCell *)cell;
         mazeCell.visited = NO;
         //一直循环，找到离dest点最近的cell
         //找到dest点
         float curDestDistance = ccpDistance(destPos, mazeCell.position);
         if (curDestDistance < destDistance) {
             destDistance = curDestDistance;
             destPosition=mazeCell.position;
         }
     }
     ];

    //找到对应点的索引
    int destIndex = -1;
    for (int i=0; i<_currentEntities.count; i++) {
        if (CGPointEqualToPoint(((Entity*)[_currentEntities objectAtIndex:i]).position, destPosition)) {
            destIndex=i;
            break;
        }
    }
    
    if (destIndex>0) {
        //destIndex为当前touch的cell索引，移除除touch点以后的所有点
        NSLog(@"backToPosition--_currentEntities.count:%d",_currentEntities.count);
        for (int i=_currentEntities.count-1; i>destIndex; i--) {
            
            Entity* e=[_currentEntities objectAtIndex:i];
            NSLog(@"backToPosition--remote canceled entity i:%d, posi x:%f,y:%f",i,e.position.x,e.position.y);
            [_currentEntities removeObject:e];
            [self justDropCancelled:e.position];
            [self.parent removeChild:e cleanup:YES];
        }
        //将self（role）移植touch点
        self.position=destPosition;
        return YES;
    } else {
        NSLog(@"destPosition isn't in corrent entity array!!");
        return NO;
    }
  
}

- (void)dropCancelled:(CCSprite *)node
{
//    NSLog(@"---dropCancelled-----");
    CGPoint pos = position_;
    __block CCSprite *current = nil;
    __block NSUInteger currentKey = 0;
    [_currentEntities enumerateObjectsUsingBlock:
        ^(id sprite, NSUInteger key, BOOL *stop) {
            if (CGPointEqualToPoint(((Entity*) sprite).position, pos)) {
                current = sprite;
                currentKey = key;
                *stop = YES;
            }
        }
    ];
    [self.parent removeChild:current cleanup:YES];
    [_currentEntities removeObjectAtIndex:currentKey];
    
    //暂时不显示cancel点
    /*
    CCSprite *cancelled = [CCSprite spriteWithFile:@"entity.png"];
    [cancelled setColor:ccc3(100, 100, 100)];
    cancelled.tag=tCancalEntity;
    [cancelled setPosition:pos];
    [_cancelledEntities addObject:cancelled];
    [self.parent addChild:cancelled];
     */
   
}
//仅仅放置cancel点，并在cancel数组中记录，不做其他操作
-(void)justDropCancelled:(CGPoint)pos{
//    NSLog(@"---justDropCancelled-----");
    CCSprite *cancelled = [CCSprite spriteWithFile:@"entity.png"];
    [cancelled setColor:ccc3(100, 100, 100)];
    cancelled.tag=tCancalEntity;
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