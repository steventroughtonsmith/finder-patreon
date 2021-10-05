//
//  AppDelegate.m
//  WindowKitDemo
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "AppDelegate.h"

@import WindowKit;
@import MapKit;

@interface AppDelegate ()

@end

@implementation AppDelegate

WKWindow *childWindow = nil;
WKWindow *childWindow2 = nil;
WKWindow *childWindow3 = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	self.window = [UIWindow new];
	
	WKWindowManager *windowManager = [WKWindowManager new];
	
	{
		childWindow = [[WKWindow alloc] initWithWindowManager:windowManager mask:WKWindowClosable|WKWindowResizable|WKWindowNonActivating];
		
		UITableViewController *tc = [UITableViewController new];
		tc.title = @"Files";
		
		childWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:tc];
		
		[childWindow makeKeyAndVisible];
		[childWindow setFrame:CGRectMake(100, 100, 320, 480)];
	}
	
	{
		childWindow2 = [[WKWindow alloc] initWithWindowManager:windowManager mask:WKWindowClosable|WKWindowResizable|WKWindowMiniaturizable];
		
		UIViewController *vc = [UIViewController new];
		vc.view = [UITextView new];
		vc.title = @"Hello World.lua";
		
		childWindow2.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
		
		[childWindow2 makeKeyAndVisible];
		[childWindow2 setFrame:CGRectMake(500, 300, 512, 512)];
	}
	
	{
		childWindow3 = [[WKWindow alloc] initWithWindowManager:windowManager mask:WKWindowClosable|WKWindowResizable|WKWindowMiniaturizable];
		
		UIViewController *vc = [UIViewController new];
		vc.view.backgroundColor = [UIColor blackColor];
		
		childWindow3.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
		
		[childWindow3 makeKeyAndVisible];
		[childWindow3 setFrame:CGRectMake(500, 300, 320, 480)];
	}
	
	self.window.rootViewController = windowManager;
	[self.window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
