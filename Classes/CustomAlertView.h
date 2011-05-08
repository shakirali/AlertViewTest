///
//  CustomLoadingView.h
//  HorizontalScrollView
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomAlertView : UIView {
	@private
	UILabel* textLabel;
	UIActivityIndicatorView* activityView;
}

-(id)initWithFrame:(CGRect)frame withText:(NSString*)text;
-(void)show;
@end
