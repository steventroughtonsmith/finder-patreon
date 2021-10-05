//
//  AppDelegate.m
//  Files
//
//  Created by Steven Troughton-Smith on 11/06/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import "FBShared.h"
#import "AppDelegate.h"
#import "FBColumnViewController.h"
#import "FBFilesTableViewController.h"
#import "FBColumnNavigationController.h"
#import "MBFingerTipWindow.h"


@import WindowKit;

@implementation AppDelegate

-(void)showRootCommandMenu:(UILongPressGestureRecognizer *)sender
{
#if TARGET_OS_IOS
	CGPoint pt = [sender locationInView:sender.view];
	
	UIView *viewUnderFinger = [sender.view hitTest:pt withEvent:nil];
	
	if (viewUnderFinger.tag != WKDesktopViewTag)
		return;
	
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:nil
										  message:nil
										  preferredStyle:UIAlertControllerStyleActionSheet];
	
	
	UIAlertAction *newWindowAction = [UIAlertAction actionWithTitle:@"New Window" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self createNewWindow:self];
	}];
	
	UIAlertAction *closeAllWindowsAction = [UIAlertAction actionWithTitle:@"Close All Windows" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[self closeAllWindows:self];
	}];
	
	[alertController addAction:newWindowAction];
	[alertController addAction:closeAllWindowsAction];
	
	UIPopoverPresentationController *popover = (UIPopoverPresentationController *)alertController.popoverPresentationController;
	if (popover)
	{
		popover.sourceView = [sender view];
		popover.sourceRect = CGRectMake(pt.x-20, pt.y-20, 40, 40);
		popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
	}
	
	[self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#endif
}

-(UIViewController *)initialViewController
{
	NSString *basePath = FBSharedContainerHomeDirectory();
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV)
	{
		basePath = @"/";
	}
	
	FBFilesTableViewController *tc = [[FBFilesTableViewController alloc] initWithPath:basePath];
	
	basePath = nil;
	
	FBColumnNavigationController *cnc = [[FBColumnNavigationController alloc] initWithRootViewController:tc];
	
	
	
	FBColumnViewController *columnViewController = [[FBColumnViewController alloc] initWithRootViewController:cnc];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:columnViewController];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV)
	{
		nc.view.opaque = YES;
		nc.view.backgroundColor = [UIColor whiteColor];
	}
	
#if 0
	{
		NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.highcaffeinecontent.Files"];
		NSInteger sortingFilter = [defaults integerForKey:@"FBSortingFilter"];
		
		UISegmentedControl *filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Name", @"Kind"]];
		filterSegmentedControl.apportionsSegmentWidthsByContent = NO;
		filterSegmentedControl.frame = CGRectMake(0, 0, 240, 32);
		filterSegmentedControl.selectedSegmentIndex = sortingFilter;
		columnViewController.navigationItem.titleView = filterSegmentedControl;
		
		[filterSegmentedControl addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];
	}
#endif
	
	return nc;
}

-(void)createDummyFilesystem
{
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.highcaffeinecontent.Files"];
	BOOL createdDummyFS = [defaults integerForKey:@"FBDummyFSCreated"];
	BOOL forceCreate = [[[NSProcessInfo processInfo] arguments] containsObject:@"-FBCreateDummyFS"];
	BOOL symlinkLibrary = [[[NSProcessInfo processInfo] arguments] containsObject:@"-FBSymlinkLibrary"];
	
	NSString *basePath = FBSharedContainerHomeDirectory();
	
	if (forceCreate || !createdDummyFS)
	{
		
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Paris" ofType:@"jpg"] toPath:[basePath stringByAppendingPathComponent:@"Jobs.jpg"] error:nil];
		
		
		[@"Here's to the crazy ones.\nThe misfits.\nThe rebels.\nThe troublemakers.\nThe round pegs in the square holes.\nThe ones who see things differently.\nThey're not fond of rules.\nAnd they have no respect for the status quo.\nYou can quote them, disagree with them, glorify or vilify them.\nAbout the only thing you can't do is ignore them.\nBecause they change things.\nThey push the human race forward.\nAnd while some may see them as the crazy ones, we see genius.\nBecause the people who are crazy enough to think they can change the world, are the ones who do." writeToFile:[basePath stringByAppendingPathComponent:@"Crazy Ones.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:[basePath stringByAppendingPathComponent:@"Example Folder"] withIntermediateDirectories:YES attributes:nil error:nil];
		
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"The Curtain Rises" ofType:@"mp3"] toPath:[basePath stringByAppendingPathComponent:@"Example Folder/The Curtain Rises.mp3"] error:nil];
		
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"TextEdit Test Document" ofType:@"rtf"] toPath:[basePath stringByAppendingPathComponent:@"Example Folder/TextEdit Test Document.rtf"] error:nil];
		
		[defaults setBool:YES forKey:@"FBDummyFSCreated"];
	}
	
	if (symlinkLibrary)
	{
		[[NSFileManager defaultManager] createSymbolicLinkAtPath:[basePath stringByAppendingPathComponent:@"Library"] withDestinationPath:@"/System/Library" error:nil];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	
	[self createDummyFilesystem];
	
	
	
	self.window = [[UIWindow alloc] init];
	
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIScreenDidConnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
		
		UIWindow *externalWindow = [[MBFingerTipWindow alloc] init];
		
		WKWindowManager *windowManager = [WKWindowManager new];
		self.windowManager = windowManager;
		
#if BUILD_FOR_APPSTORE
		windowManager.defaultBackgroundColor = [UIColor blackColor];
		windowManager.allowsFreeformWindowing = NO;
#else
		windowManager.defaultBackgroundColor = [UIColor colorWithRed:0.321 green:0.501 blue:0.734 alpha:1.000];
		windowManager.allowsFreeformWindowing = YES;
#endif
		
		windowManager.backgroundColor = nil;
		
		[self createNewWindow:self];
		UIScreen *externalScreen = [UIScreen screens].lastObject;
		externalScreen.overscanCompensation = UIScreenOverscanCompensationNone;
		
		externalWindow.screen = externalScreen;
		
		externalWindow.rootViewController = windowManager;
		
		
		[externalWindow makeKeyAndVisible];

		self.externalWindow = externalWindow;
		
		if (0)//UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomTV)
		{
			//[windowManager.windows.lastObject snap:WKWindowSnapFullscreen];
		}
		else
		{
			[windowManager.windows.lastObject setFrame:CGRectMake(100, 100, 1700, 800)];
			//			[self createNewWindow:self];
			//
			//			[windowManager.windows.lastObject setFrame:CGRectMake(300, 300, 1000, 500)];
			
		}
		
		[self createNewWindow:self];

		
		[windowManager.windows.lastObject setFrame:CGRectMake(500, 300, 600, 490)];

		UILongPressGestureRecognizer *rec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showRootCommandMenu:)];
		
		[windowManager.view addGestureRecognizer:rec];

	}];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV)
	{
		
		WKWindowManager *windowManager = [WKWindowManager new];
		self.windowManager = windowManager;
		
#if BUILD_FOR_APPSTORE
		windowManager.defaultBackgroundColor = [UIColor blackColor];
		windowManager.allowsFreeformWindowing = NO;
#else
		windowManager.defaultBackgroundColor = [UIColor colorWithRed:0.321 green:0.501 blue:0.734 alpha:1.000];
		windowManager.allowsFreeformWindowing = YES;
#endif
		
		windowManager.backgroundColor = nil;
		
		[self createNewWindow:self];
		
	//	if ([[UIScreen mainScreen] mirroredScreen])
		self.window.screen = [[UIScreen mainScreen] mirroredScreen];

		self.window.rootViewController = windowManager;
		[self.window makeKeyAndVisible];
		
	

		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomTV)
		{
			[windowManager.windows.lastObject snap:WKWindowSnapFullscreen];
		}
		else
		{
			[windowManager.windows.lastObject setFrame:CGRectMake(100, 100, 1700, 800)];
			//			[self createNewWindow:self];
			//
			//			[windowManager.windows.lastObject setFrame:CGRectMake(300, 300, 1000, 500)];
			
		}
		
		
		UILongPressGestureRecognizer *rec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showRootCommandMenu:)];
		
		[windowManager.view addGestureRecognizer:rec];

	}
	else
	{
		self.window.rootViewController = [self initialViewController];
		[self.window makeKeyAndVisible];
		
	
	}
	
	
	
	return YES;
}

-(void)closeAllWindows:(id)sender
{
	NSArray *_temp = [_windowManager.windows copy];
	
	for (WKWindow *window in _temp)
	{
		[window close:sender];
	}
}

-(void)createNewWindow:(id)sender
{
	if (!self.windowManager.allowsFreeformWindowing)
	{
		if (self.windowManager.windows.count >= 3)
		{
			return;
		}
	}
	
	WKWindow *childWindow = nil;
	CGPoint p = [self.windowManager nextWindowOrigin];
	
	[self becomeFirstResponder];
	
	WKWindowMask mask = 0;
	
	if (self.windowManager.allowsFreeformWindowing)
	{
		mask = WKWindowClosable|WKWindowMiniaturizable|WKWindowResizable;
	}
	else
	{
		if (self.windowManager.windows.count > 0)
		{
			mask = WKWindowClosable;
		}
	}
	
	childWindow = [[WKWindow alloc] initWithWindowManager:self.windowManager mask:mask];
	childWindow.rootViewController = [self initialViewController];
	
	[childWindow makeKeyAndVisible];
	childWindow.minimumSize = CGSizeMake(320, 320);
	
	
	[childWindow setFrame:CGRectMake(p.x, p.y, 414, 667)];
	//487
	
	if (!self.windowManager.allowsFreeformWindowing)
	{
		
		
		if (self.windowManager.windows.count == 2)
		{
			//		[UIView animateWithDuration:0.15 delay:0 options:0 animations:^{
			//
			//
			//} completion:^(BOOL finished) {
			//
			//		}];
			[childWindow showTargetForSnap:WKWindowSnapRight];
			[childWindow snap:WKWindowSnapRight];
		}
		else if (self.windowManager.windows.count == 3)
		{
			[childWindow showTargetForSnap:WKWindowSnapBottomRight];
			[childWindow snap:WKWindowSnapBottomRight];
			
			//		[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
			//
			//		} completion:^(BOOL finished) {
			//					}];
		}
	}
}

-(void)filterChanged:(UISegmentedControl *)sender
{
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.highcaffeinecontent.Files"];
	
	[defaults setInteger:sender.selectedSegmentIndex forKey:@"FBSortingFilter"];
}

-(void)debugToggleFreeformWindowing:(id)sender
{
	
	
	self.windowManager.allowsFreeformWindowing = !self.windowManager.allowsFreeformWindowing;
	
	[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
		
		if (self.windowManager.allowsFreeformWindowing)
		{
			self.windowManager.defaultBackgroundColor = [UIColor colorWithRed:0.321 green:0.501 blue:0.734 alpha:1.000];
			self.windowManager.backgroundColor = nil;
		}
		else
		{
			self.windowManager.defaultBackgroundColor = [UIColor blackColor];
			self.windowManager.backgroundColor = nil;
		}
		
		for (WKWindow *window in self.windowManager.windows)
		{
			if (self.windowManager.allowsFreeformWindowing)
				window.windowMask |= (WKWindowMiniaturizable|WKWindowResizable);
			else
			{
				window.windowMask ^= (WKWindowMiniaturizable|WKWindowResizable);
				
				[window snap:window.snapState];
			}
			
			[window update];
		}
	} completion:nil];
}

#pragma mark - Key Commands

-(NSArray <UIKeyCommand *>*)keyCommands
{
	return @[
			 [UIKeyCommand keyCommandWithInput:@"n" modifierFlags:UIKeyModifierCommand action:@selector(createNewWindow:) discoverabilityTitle:NSLocalizedString(@"New Window", nil)],
			 [UIKeyCommand keyCommandWithInput:@"0" modifierFlags:UIKeyModifierCommand action:@selector(debugToggleFreeformWindowing:) discoverabilityTitle:NSLocalizedString(@"DEBUG: Toggle Freeform Windowing", nil)],
			 ];
}

@end
