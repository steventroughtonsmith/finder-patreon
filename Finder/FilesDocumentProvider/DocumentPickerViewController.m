//
//  DocumentPickerViewController.m
//  FilesDocumentProvider
//
//  Created by Steven Troughton-Smith on 11/06/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import "DocumentPickerViewController.h"
#import "FBColumnViewController.h"
#import "FBFilesTableViewController.h"
#import "FBColumnNavigationController.h"

NSString *FBSharedContainerHomeDirectory()
{
	NSString *basePath = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.highcaffeinecontent.Files"] path] stringByAppendingPathComponent:@"File Provider Storage/Documents/"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:nil])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return basePath;
}

@implementation DocumentPickerViewController

-(void)prepareForPresentationInMode:(UIDocumentPickerMode)mode {
	
	FBFilesTableViewController *tc = [[FBFilesTableViewController alloc] initWithPath:FBSharedContainerHomeDirectory()];
	FBColumnNavigationController *cnc = [[FBColumnNavigationController alloc] initWithRootViewController:tc];
	
	FBColumnViewController *columnViewController = [[FBColumnViewController alloc] initWithRootViewController:cnc];

	tc.columnViewController = columnViewController;

	columnViewController.view.frame = CGRectMake(0, 44,  self.view.bounds.size.width, self.view.bounds.size.height);

	[self.view addSubview:columnViewController.view];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:@"FBPickedFileURL" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

		NSURL *url = note.object;
		NSURL *tempURL = [NSURL URLWithString:[[url absoluteString] lastPathComponent] relativeToURL:self.documentStorageURL];
				
		[url.absoluteString writeToURL:tempURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
	
		[self dismissGrantingAccessToURL:tempURL];
	}];
}

@end
