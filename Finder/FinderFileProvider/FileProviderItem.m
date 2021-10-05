//
//  FileProviderItem.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

@import MobileCoreServices;

#import "FileProviderItem.h"
#import "FileProviderExtension.h"

@implementation FileProviderItem

// TODO: implement an initializer to create an item from your extension's backing model
// TODO: implement the accessors to return the values from your extension's backing model

- (instancetype)initWithPath:(NSString *)filePath
{
	self = [super init];
	if (self) {
		self.filePath = filePath;
	}
	return self;
}

- (NSFileProviderItemIdentifier)itemIdentifier {
    return self.filePath;
}
- (NSFileProviderItemIdentifier)parentItemIdentifier {
     if ([[self.filePath stringByDeletingLastPathComponent] isEqualToString:FBSharedContainerHomeDirectory()])
         return NSFileProviderRootContainerItemIdentifier;
    else
        return [self.filePath stringByDeletingLastPathComponent];
}

- (NSFileProviderItemCapabilities)capabilities {
    return NSFileProviderItemCapabilitiesAllowsReading;
}

- (NSString *)filename {
    return self.filePath.lastPathComponent;
}

- (NSString *)typeIdentifier {
	
	BOOL isDirectory = NO;
	
	[[NSFileManager defaultManager] fileExistsAtPath:self.filePath isDirectory:&isDirectory];
//	NSDictionary *attribs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:self.filePath error:nil];
	//UTCreateStringForOSType
	return isDirectory? @"public.folder" : (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFBridgingRetain(self.filePath.pathExtension), NULL);
	//@"public.content";
}

@end
