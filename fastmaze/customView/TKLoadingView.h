//
//  TKLoadingView.h
//  Yunho2
//
//  Created by l on 12-12-25.
//
//

#import <UIKit/UIKit.h>

@interface TKLoadingView : UIView {
	UIActivityIndicatorView *_activity;
	BOOL _hidden;
    
	NSString *_title;
	NSString *_message;
	float radius;
    int lWidth;
}
@property (copy,nonatomic) NSString *title;
@property (assign,nonatomic) int lWidth;
@property (copy,nonatomic) NSString *message;
@property (assign,nonatomic) float radius;

- (id) initWithTitle:(NSString*)title message:(NSString*)message;
- (id) initWithTitle:(NSString*)title;

- (void) startAnimating;
- (void) stopAnimating;

@end