//
//  TKLoadingView.m
//  Yunho2
//
//  Created by l on 12-12-25.
//
//

#import "TKLoadingView.h"

#import "UIView+TKCategory.h"


#define WIDTH_MARGIN 20
#define HEIGHT_MARGIN 20

@interface TKLoadingView (PrivateMethods)
- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode;
@end


@implementation TKLoadingView
@synthesize radius;
@synthesize lWidth;

- (id) initWithTitle:(NSString*)ttl message:(NSString*)msg{
	if(!(self = [super initWithFrame:CGRectMake(0, 0, 320,460)])) return nil;
    
    _title = [ttl copy];
    _message = [msg copy];
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:_activity];
    _hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
	lWidth = 200;
	return self;
}
- (id) initWithTitle:(NSString*)ttl{
	return [self initWithTitle:ttl message:nil];
}

- (void) drawRect:(CGRect)rect {
	
	if(_hidden) return;
	int width, rWidth, rHeight, x;
	
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:16];
	UIFont *messageFont = [UIFont systemFontOfSize:12];
	
	CGSize s1 = [self calculateHeightOfTextFromWidth:_title font:titleFont width:lWidth linebreak:UILineBreakModeTailTruncation];
	CGSize s2 = [self calculateHeightOfTextFromWidth:_message font:messageFont width:200 linebreak:UILineBreakModeCharacterWrap];
	
	if([_title length] < 1) s1.height = 0;
	if([_message length] < 1) s2.height = 0;
	
	
	rHeight = (s1.height + s2.height + (HEIGHT_MARGIN*2) + 10 + _activity.frame.size.height);
	rWidth = width = (s2.width > s1.width) ? (int) s2.width : (int) s1.width;
	rWidth += WIDTH_MARGIN * 2;
	x = (self.frame.size.width - rWidth) / 2;
	int y = (self.frame.size.height - rHeight) / 2 - HEIGHT_MARGIN;
	_activity.center = CGPointMake(x+rWidth/2, y+HEIGHT_MARGIN+HEIGHT_MARGIN/2);
	
	
	//log4debug(@"DRAW RECT %d %f",rHeight,self.frame.size.height);
	
	// DRAW ROUNDED RECTANGLE
	[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.9] set];
	CGRect r = CGRectMake(x, y, rWidth,rHeight);
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75] set];
	[UIView drawRoundRectangleInRect:r withRadius:15.0];
	
	
	// DRAW FIRST TEXT
	[[UIColor whiteColor] set];
	r = CGRectMake(x+WIDTH_MARGIN, _activity.center.y + HEIGHT_MARGIN, width, s1.height);
	CGSize s = [_title drawInRect:r withFont:titleFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	
	
	// DRAW SECOND TEXT
	r.origin.y += s.height;
	r.size.height = s2.height;
	[_message drawInRect:r withFont:messageFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
	
	
	
}


- (void) setTitle:(NSString*)str{
	[_title release];
	_title = [str copy];
	//[self updateHeight];
	[self setNeedsDisplay];
}
- (NSString*) title{
	return _title;
}

- (void) setMessage:(NSString*)str{
	[_message release];
	_message = [str copy];
	[self setNeedsDisplay];
}
- (NSString*) message{
	return _message;
}

- (void) setRadius:(float)f{
	if(f==radius) return;
	
	radius = f;
	[self setNeedsDisplay];
	
}

- (void) startAnimating{
	if(!_hidden) return;
	_hidden = NO;
	[self setNeedsDisplay];
	[_activity startAnimating];
	
}
- (void) stopAnimating{
	if(_hidden) return;
	_hidden = YES;
	[self setNeedsDisplay];
	[_activity stopAnimating];
	
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont
			constrainedToSize:CGSizeMake(width, FLT_MAX)
				lineBreakMode:lineBreakMode];
}



- (CGSize) heightWithString:(NSString*)str font:(UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	
	
	CGSize suggestedSize = [str sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
	return suggestedSize;
}


- (void) adjustHeight{
	
	CGSize s1 = [self heightWithString:_title font:[UIFont boldSystemFontOfSize:16.0]
								 width:200.0
							 linebreak:UILineBreakModeTailTruncation];
	
	CGSize s2 = [self heightWithString:_message font:[UIFont systemFontOfSize:12.0]
                                 width:200.0
                             linebreak:UILineBreakModeCharacterWrap];
    
	CGRect r = self.frame;
	r.size.height = s1.height + s2.height + 20;
	self.frame = r;
}





- (void) dealloc{
	[_activity release];
	[_title release];
	[_message release];
	[super dealloc];
}

@end