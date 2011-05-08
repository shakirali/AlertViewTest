//
//  AlertViewTestAppDelegate.h
//  AlertViewTest
//

#import <UIKit/UIKit.h>

@class AlertViewTestViewController;

@interface AlertViewTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AlertViewTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AlertViewTestViewController *viewController;

@end

