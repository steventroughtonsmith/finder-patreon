//
//  AppDelegate.h
//  Files
//
//  Created by Steven Troughton-Smith on 11/06/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBColumnViewController, WKWindowManager;
@interface AppDelegate : UIResponder
#if TARGET_OS_IOS
<UIApplicationDelegate,UIAlertViewDelegate>
#else
<UIApplicationDelegate>
#endif


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *externalWindow;
//@property (strong) FBColumnViewController *columnViewController;
@property (strong, nonatomic) WKWindowManager *windowManager;

@end

