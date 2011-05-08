//
//  AlertViewTestViewController.m
//  AlertViewTest
//

#import "AlertViewTestViewController.h"
#import "CustomAlertView.h"

@implementation AlertViewTestViewController
#define CUSTOM_ALERT_VIEW_TAG 1
#define CUSTOM_ALERT_VIEW_HEIGHT 150
#define CUSTOM_ALERT_VIEW_WIDTH 250

-(void)displayBtnAction{
	CGRect alertFrame = CGRectMake((self.view.frame.size.width - CUSTOM_ALERT_VIEW_WIDTH)/2, (self.view.frame.size.height - CUSTOM_ALERT_VIEW_HEIGHT)/2, CUSTOM_ALERT_VIEW_WIDTH, CUSTOM_ALERT_VIEW_HEIGHT);
	CustomAlertView* customAlertView = [[CustomAlertView alloc] initWithFrame:alertFrame withText:@"Posting Tweet"]; 
	customAlertView.tag = CUSTOM_ALERT_VIEW_TAG;
	[self.view addSubview:customAlertView];
	[customAlertView show];
	[customAlertView release];
}

- (void)dealloc {
    [super dealloc];
}

@end
