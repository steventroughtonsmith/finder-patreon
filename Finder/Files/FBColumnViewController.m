//
//  FBColumnViewController.m
//  Files
//
//  Created by Steven Troughton-Smith on 11/06/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import "FBShared.h"
#import "FBColumnViewController.h"
#import "FBFilesTableViewController.h"
#import "FBColumnNavigationController.h"
#import "FBFilesIconViewController.h"
#import "FBColumnsScrollView.h"

@implementation FBColumnViewController
@dynamic view;

-(BOOL)canBecomeFirstResponder
{
	return YES;
}

- (instancetype)initWithRootViewController:(UIViewController <FBColumnViewControllerChild>*)vc
{
	self = [super init];
	if (self) {
		self.viewControllers = @[vc];
		self.columnWidth = 320.;
		
		vc.columnViewController = self;
		FBColumnsScrollView *sv = [[FBColumnsScrollView alloc] initWithFrame:self.view.frame];
		//		sv.panGestureRecognizer.delegate = self;
		sv.autoresizingMask = self.view.autoresizingMask;
#if TARGET_OS_IOS
		sv.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
		self.view = sv;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		{
			self.columnWidth = [UIScreen mainScreen].bounds.size.width;
			
			self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:vc.childViewControllers.firstObject];
#ifdef APP_EXTENSION
			self.rootNavigationController.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-64);
#else
			self.rootNavigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-_FBStatusBarDelta());
#endif
			self.rootNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
			
#if TARGET_OS_IOS
			[self.rootNavigationController setToolbarHidden:NO];
#endif
			[self.view addSubview:self.rootNavigationController.view];
		}
		else
		{
			[self layout];
		}
		

		{
			UISegmentedControl *filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[ [UIImage imageNamed:@"IconMode"], [UIImage imageNamed:@"ListMode"], [UIImage imageNamed:@"ColumnMode"]]];
			filterSegmentedControl.apportionsSegmentWidthsByContent = NO;
			filterSegmentedControl.frame = CGRectMake(0, 0, 64, 32);
			filterSegmentedControl.selectedSegmentIndex = 2;
			
			[filterSegmentedControl addTarget:self action:@selector(changeViewMode:) forControlEvents:UIControlEventValueChanged];
			
			self.viewMode = 2;
			
			//			self.navigationItem.titleView = filterSegmentedControl;
			
			
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterSegmentedControl];
			[filterSegmentedControl sizeToFit];
			
		}

		//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goToFolder:)];
		
		//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(switchToIconView:)];
		
		[self becomeFirstResponder];
		
	}
	return self;
}

-(void)changeViewMode:(UISegmentedControl *)sender
{
	
	if (sender.selectedSegmentIndex == self.viewMode)
		return;
	
	if (sender.selectedSegmentIndex == 0)
	{
		[self switchToIconView:sender];
	}
	else if (sender.selectedSegmentIndex == 1)
	{
		[self switchToListView:sender];
	}
	else if (sender.selectedSegmentIndex == 2)
	{
		[self switchToColumnView:sender];
	}
	
	self.viewMode = sender.selectedSegmentIndex;
}

-(void)switchToListView:(id)sender
{
	
}


-(void)switchToColumnView:(id)sender
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		self.rootNavigationController.view.hidden = NO;
	}
	
	FBFilesIconViewController *ivc = (FBFilesIconViewController *)iconNavController.topViewController;
	
	[[iconNavController view] removeFromSuperview];
	[iconNavController removeFromParentViewController];
	
	for (UIViewController *vc in self.viewControllers)
	{
		vc.view.hidden = NO;
	}
	
	self.view.scrollEnabled = YES;
	
	[self navigateToPath:ivc.path];
	
	
}

-(void)switchToIconView:(id)sender
{
	FBColumnNavigationController *parentVC = (FBColumnNavigationController *)self.viewControllers.lastObject;
	
	
	
	FBFilesTableViewController *topVC = (FBFilesTableViewController *)[parentVC topViewController];
	
	if (![[topVC class] isSubclassOfClass:[FBFilesTableViewController class]])
	{
		parentVC = (FBColumnNavigationController *)[self.viewControllers objectAtIndex:self.viewControllers.count-2];
		topVC = (FBFilesTableViewController *)[parentVC topViewController];
	}
	
	if (self.rootNavigationController)
	{
		topVC = (FBFilesTableViewController *)self.rootNavigationController.topViewController;
	}
	
	FBFilesIconViewController *ivc = [[FBFilesIconViewController alloc] initWithPath:topVC.path];
	ivc.columnViewController = self;
	
	iconNavController = [[FBColumnNavigationController alloc] initWithRootViewController:ivc];
	
	//	[self.rootNavigationController popToRootViewControllerAnimated:NO];
	//[self.rootNavigationController pushViewController:ivc animated:NO];
	
	//	[self pushViewController:ivc];
	[self addChildViewController:iconNavController];
	
	//	ivc.view.bounds = self.view.bounds;
	iconNavController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-_FBStatusBarDelta());
	
	iconNavController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:iconNavController.view];
	
#if TARGET_OS_IOS
	[iconNavController setToolbarHidden:NO];
#endif
	
	for (UIViewController *vc in self.viewControllers)
	{
		vc.view.hidden = YES;
	}
	
	self.view.contentSize = self.view.bounds.size;
	self.view.scrollEnabled = NO;
	
	self.title = ivc.title;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		self.rootNavigationController.view.hidden = YES;
	}
	[self becomeFirstResponder];
}


-(void)pushDetailViewController:(UIViewController <FBColumnViewControllerChild>*)vc
{
	_isDetailViewController = YES;
	[self pushViewController:vc];
	_isDetailViewController = NO;
}

-(void)pushViewController:(UIViewController <FBColumnViewControllerChild>*)vc
{
	self.viewControllers = [self.viewControllers arrayByAddingObject:vc];
	vc.columnViewController = self;
	
	self.title = vc.title;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		[self.rootNavigationController pushViewController:vc.childViewControllers.firstObject animated:YES];
#if TARGET_OS_IOS
		[self.rootNavigationController setToolbarHidden:NO];
#endif
	}
	else
	{
		[self layout];
		
		self.view.contentSize = CGSizeMake(self.viewControllers.lastObject.view.frame.origin.x+self.viewControllers.lastObject.view.frame.size.width, self.view.frame.size.height-44-_FBStatusBarDelta());
		[self.view scrollRectToVisible:vc.view.frame animated:YES];
	}
}

-(void)popViewController
{
	if (self.viewControllers.count > 1)
	{
		self.viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, self.viewControllers.count-2)];
	}
	else
	{
		self.viewControllers = @[];
	}
	
	self.title = self.viewControllers.lastObject.title;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		[self.rootNavigationController popViewControllerAnimated:YES];
	}
	else
	{
		[self layout];
		
		self.view.contentSize = CGSizeMake(self.viewControllers.lastObject.view.frame.origin.x+self.viewControllers.lastObject.view.frame.size.width, self.view.frame.size.height-44-_FBStatusBarDelta());
		[self.view scrollRectToVisible:self.viewControllers.lastObject.view.frame animated:YES];
	}
}

-(void)popToRootViewController
{
	self.viewControllers = @[[self.viewControllers firstObject]];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		[self.rootNavigationController popToRootViewControllerAnimated:YES];
	}
	else
	{
		[self layout];
		
		self.view.contentSize = CGSizeMake(self.viewControllers.lastObject.view.frame.origin.x+self.viewControllers.lastObject.view.frame.size.width, self.view.frame.size.height-44-_FBStatusBarDelta());
		[self.view scrollRectToVisible:self.viewControllers.lastObject.view.frame animated:YES];
	}
}

-(void)popToViewController:(UIViewController *)vc
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
	}
	else
	{
		NSUInteger idx = [self.viewControllers indexOfObject:vc];
		
		if (idx < self.viewControllers.count)
		{
			self.viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, idx+1)];
			
			[self layout];
		}
		
		[self.view scrollRectToVisible:vc.view.frame animated:YES];
	}
}

-(void)layout
{
	if (self.view.subviews.count && self.view.subviews.count > self.viewControllers.count)
	{
		[[self.view.subviews subarrayWithRange:NSMakeRange(self.viewControllers.count, self.view.subviews.count-self.viewControllers.count)] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	
	NSUInteger idx = 0;
	for (UIViewController *vc in self.viewControllers)
	{
		
		CGFloat desiredWidth = self.columnWidth;
		
		if (_isDetailViewController && idx == self.viewControllers.count-1)
		{
			desiredWidth = 512;
		}
		
		vc.view.frame = CGRectMake(idx*self.columnWidth+idx, 0, desiredWidth, self.view.frame.size.height-44-_FBStatusBarDelta());
		
		vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:vc.view];
		
		idx++;
	}
}

CGFloat _FBStatusBarDelta()
{
	CGFloat statusBarDelta = 0;
	
#ifdef APP_EXTENSION
	statusBarDelta = 0;
#endif
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		statusBarDelta = 20;
	
	return statusBarDelta;
}




-(void)navigateToPath:(NSString *)path
{
	[self popToRootViewController];
	
	__block NSString *composedPath = @"/";
	
	
	NSString *basePath = FBSharedContainerHomeDirectory();
	
	
	if ([path hasPrefix:@"~"])
	{
		if (path.length > 3)
		{
			path = [basePath stringByAppendingPathComponent:[path substringFromIndex:2]];
		}
		else
		{
			path = basePath;
		}
	}
	
	NSArray *components = [[path stringByExpandingTildeInPath] pathComponents];
	
	[components enumerateObjectsUsingBlock:^(NSString * _Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
		if (idx == 0)
			return;
		
		
		
		NSString *highlightedComponent = (idx < components.count-1) ? components[idx+1] : nil;
		
		composedPath = [composedPath stringByAppendingPathComponent:component];
		
		
		if ([path hasPrefix:basePath] && ! (composedPath.length > basePath.length))
		{
			return;
		}
		
		FBFilesTableViewController *vc = [[FBFilesTableViewController alloc] initWithPath:composedPath];
		
		FBColumnNavigationController *detailNavController = [[FBColumnNavigationController alloc] initWithRootViewController:vc];
		[self pushViewController:detailNavController];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[vc highlightPathComponent:highlightedComponent];
		});
	}];
	
}

#pragma mark - Key Commands

-(NSArray <UIKeyCommand *>*)keyCommands
{
	return @[
			 [UIKeyCommand keyCommandWithInput:@"g" modifierFlags:UIKeyModifierShift|UIKeyModifierCommand action:@selector(goToFolder:) discoverabilityTitle:NSLocalizedString(@"Go to Folder…", nil)],
#if TARGET_OS_IOS
			 [UIKeyCommand keyCommandWithInput:@"i" modifierFlags:UIKeyModifierCommand action:@selector(importToCurrentFolder:) discoverabilityTitle:NSLocalizedString(@"Import…", nil)],
#endif
			 [UIKeyCommand keyCommandWithInput:@"n" modifierFlags:UIKeyModifierShift|UIKeyModifierCommand action:@selector(createNewFolder:) discoverabilityTitle:NSLocalizedString(@"New Folder", nil)]
			 
			 ];
}

#pragma mark -

#if TARGET_OS_IOS

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
	NSError *error = nil;
	
	
	FBColumnNavigationController *parentVC = (FBColumnNavigationController *)self.viewControllers.lastObject;
	
	
	
	FBFilesTableViewController *topVC = (FBFilesTableViewController *)[parentVC topViewController];
	
	if (![[topVC class] isSubclassOfClass:[FBFilesTableViewController class]])
	{
		parentVC = (FBColumnNavigationController *)[self.viewControllers objectAtIndex:self.viewControllers.count-2];
		topVC = (FBFilesTableViewController *)[parentVC topViewController];
	}
	
	if (self.rootNavigationController)
	{
		topVC = (FBFilesTableViewController *)self.rootNavigationController.topViewController;
	}
	
	NSString *currentPath = topVC.path;
	
	[[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:[currentPath stringByAppendingPathComponent:url.lastPathComponent]] error:&error];
	
	//createSymbolicLinkAtURL:[NSURL fileURLWithPath:[currentPath stringByAppendingPathComponent:url.lastPathComponent]] withDestinationURL:url error:&error];
	
	
	if (error)
	{
		NSLog(@"ERROR = %@", error.localizedDescription);
	}
	
	[topVC refresh:self];
}

-(void)importToCurrentFolder:(id)sender
{
	UIDocumentPickerViewController* documentPicker =
	[[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
														   inMode:UIDocumentPickerModeImport];
	documentPicker.delegate = self;
	
	[self presentViewController:documentPicker animated:YES completion:nil];
}
#endif

-(void)createNewFolder:(id)sender
{
	
}



-(void)goToFolder:(id)sender
{
	
	UIAlertController * alert = [UIAlertController
								 alertControllerWithTitle:NSLocalizedString(@"Go to the folder…", nil)
								 message:nil
								 preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
	}];
	
	UIAlertAction* goAction = [UIAlertAction
							   actionWithTitle:NSLocalizedString(@"Go", nil)
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction * action)
							   {
								   NSString *path = alert.textFields.firstObject.text;
								   
								   if (path.length > 0)
								   {
									   [self navigateToPath:path];
								   }
								   
								   [alert dismissViewControllerAnimated:YES completion:nil];
								   
							   }];
	UIAlertAction* cancelAction = [UIAlertAction
								   actionWithTitle:NSLocalizedString(@"Cancel", nil)
								   style:UIAlertActionStyleCancel
								   handler:^(UIAlertAction * action)
								   {
									   [alert dismissViewControllerAnimated:YES completion:nil];
								   }];
	
	[alert addAction:cancelAction];
	[alert addAction:goAction];
	
	[self presentViewController:alert animated:YES completion:nil];
}

@end
