//
// @author Jonny Brannum <jonny.brannum@gmail.com> 
//         1/22/12
//

#import <Foundation/Foundation.h>

typedef enum{
    kUP=1,
    kDOWN,
    kLEFT,
    kRIGHT,
}DIRECTION;

#define kNotiRegenerateMaze  @"__kNotiRegenerateMaze"
#define kNotiShowMazeAnswer  @"__kNotiShowMazeAnswer"


#define MIN_DISTANCE 10.0f
#define MIN_DISTANCE_PERCENT 0.5f
