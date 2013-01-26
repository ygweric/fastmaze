

#import <UIKit/UIDevice.h>
#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
//----------------- Code Setup--- BEGIN --------------------
/*  DETERMINE THE DEVICE USED  */
#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (NO)
#endif

/*  NORMAL DETAILS */
#define kScreenHeight       480
#define kScreenWidth        320

/* OFFSETS TO ACCOMMODATE IPAD */
#define kXoffsetiPad        64
#define kYoffsetiPad        32


#define SD_PNG      @"."
#define HD_PNG      @"-ipad."

#define ADJUST_CCP(__p__)       \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x * 2 ) + kXoffsetiPad, ( __p__.y * 2 ) + kYoffsetiPad ) : \
__p__)

#define REVERSE_CCP(__p__)      \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x - kXoffsetiPad ) / 2, ( __p__.y - kYoffsetiPad ) / 2 ) : \
__p__)

#define ADJUST_XY(__x__, __y__)     \
(IS_IPAD() == YES ?                     \
ccp( ( __x__ * 2 ) + kXoffsetiPad, ( __y__ * 2 ) + kYoffsetiPad ) : \
ccp(__x__, __y__))

#define ADJUST_X(__x__)         \
(IS_IPAD() == YES ?             \
( __x__ * 2 ) + kXoffsetiPad :      \
__x__)

#define ADJUST_Y(__y__)         \
(IS_IPAD() == YES ?             \
( __y__ * 2 ) + kYoffsetiPad :      \
__y__)

#define HD_PIXELS(__pixels__)       \
(IS_IPAD() == YES ?             \
( __pixels__ * 2 ) :                \
__pixels__)

#define HD_TEXT(__size__)   \
(IS_IPAD() == YES ?         \
( __size__ * 1.5 ) :            \
__size__)

#define SD_OR_HD(__filename__)  \
(IS_IPAD() == YES ?             \
[__filename__ stringByReplacingOccurrencesOfString:SD_PNG withString:HD_PNG] :  \
__filename__)
//----------------- Code Setup--- END --------------------

//----------------- Spritesheets , BMFonts,TMX--- BEGIN --------------------
/* SD/HD Font file */
#define SD_FNT  @".fnt"
#define HD_FNT @"-ipad.fnt"

/* SD/HD scale convert */
#define HD2SD_SCALE IS_IPAD()?1:0.5
#define SD2SD_SCALE IS_IPAD()?2:1


/* SD/HD Spritesheet plist */
#define SD_PLIST  @".plist"
#define HD_PLIST  @"-ipad.plist"

/* SD/HD Spritesheet plist */
#define SD_TMX  @".tmx"
#define HD_TMX  @"-ipad.tmx"

#define SD_HD_FONT(__filename__)  \
(IS_IPAD() == YES ?  \
[__filename__ stringByReplacingOccurrencesOfString:SD_FNT withString:HD_FNT] : \
__filename__)


#define SD_HD_PLIST(__filename__) \
(IS_IPAD() == YES ?  \
[__filename__ stringByReplacingOccurrencesOfString:SD_PLIST withString:HD_PLIST] : \
__filename__)

#define SD_HD_TMX(__filename__) \
(IS_IPAD() == YES ? \
[__filename__ stringByReplacingOccurrencesOfString:SD_TMX withString:HD_TMX] :  \
__filename__)
//----------------- Spritesheets BMFonts,TMX--- END --------------------

