//
//  main.m
//  Files
//
//  Created by Steven Troughton-Smith on 11/06/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSString *FBSharedContainerHomeDirectory()
{
	NSString *basePath = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.highcaffeinecontent.Files"] path] stringByAppendingPathComponent:@"File Provider Storage/Documents/"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:nil])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return basePath;
}

int main(int argc, char * argv[]) {
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
