//
//  FileProviderExtension.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FileProviderExtension.h"
#import "FileProviderEnumerator.h"
#import "FileProviderItem.h"

@interface FileProviderExtension ()

@property (nonatomic, readonly, strong) NSFileManager *fileManager;

@end

@implementation FileProviderExtension

- (instancetype)init {
    if (self = [super init]) {
        _fileManager = [[NSFileManager alloc] init];
        
        [self.fileCoordinator coordinateWritingItemAtURL:[self documentStorageURL] options:0 error:nil byAccessor:^(NSURL *newURL) {
            // ensure the documentStorageURL actually exists
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtURL:newURL withIntermediateDirectories:YES attributes:nil error:&error];
        }];
        
        //        [[NSFileManager defaultManager] createSymbolicLinkAtURL:[manager.documentStorageURL URLByAppendingPathComponent:@"System"]  withDestinationURL:[NSURL fileURLWithPath:@"/System"] error:nil];
        NSString *basePath =
        FBSharedContainerHomeDirectory();
        NSError *error = nil;
        [@"Blah" writeToFile:[basePath stringByAppendingPathComponent:@"Test.txt"] atomically:NO encoding:NSUTF8StringEncoding error:&error];
        
        if (error)
        {
            NSLog(error.localizedDescription);
        }
        
        [[NSFileManager defaultManager] createSymbolicLinkAtPath:[basePath stringByAppendingPathComponent:@"Library"] withDestinationPath:@"/System/Library" error:&error];
        
        if (error)
        {
            NSLog(error.localizedDescription);
        }
        NSLog(@"SYMLINK SUCCESS");
    }
    return self;
}

- (NSFileCoordinator *)fileCoordinator {
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    [fileCoordinator setPurposeIdentifier:[self providerIdentifier]];
    return fileCoordinator;
}

- (nullable NSFileProviderItem)itemForIdentifier:(NSFileProviderItemIdentifier)identifier error:(NSError * _Nullable *)error {
    // resolve the given identifier to a record in the model
    
    // TODO: implement the actual lookup
    FileProviderItem *providerItem = [[FileProviderItem alloc] initWithPath:identifier];
    
    return providerItem;
}

- (nullable NSURL *)URLForItemWithPersistentIdentifier:(NSFileProviderItemIdentifier)identifier {
    NSURL *url = [NSURL fileURLWithPath:identifier];
    
    NSLog(@"Providing: %@", url);
    
    
    return url;
}

- (nullable NSFileProviderItemIdentifier)persistentIdentifierForItemAtURL:(NSURL *)url {
    // resolve the given URL to a persistent identifier using a database
    //NSArray <NSString *> *pathComponents = [url pathComponents];
    
    // exploit the fact that the path structure has been defined as
    // <base storage directory>/<item identifier>/<item file name> above
    // NSParameterAssert(pathComponents.count > 2);
    
    return url.path;
    //pathComponents[pathComponents.count - 2];
}

#if 1
- (void)startProvidingItemAtURL:(NSURL *)url completionHandler:(void (^)(NSError *))completionHandler {
//
//    NSURL* fileURL = url;
//    NSError* error = NULL;
//
//    NSString *fileName = [url lastPathComponent];
//
//    NSURL *tempURL = [self.documentStorageURL URLByAppendingPathComponent:fileName];
//    NSURL *redirectedURL = [NSURL URLWithString:[NSString stringWithContentsOfURL:tempURL encoding:NSUTF8StringEncoding error:nil]];
//
//    NSURL *placeholderURL = [NSFileProviderExtension placeholderURLForURL:redirectedURL];
//
//
//    NSData* bookmarkData = [placeholderURL bookmarkDataWithOptions:0 includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
//
//    [bookmarkData writeToURL:url options:0 error:&error];
//    
//    [self.fileCoordinator coordinateWritingItemAtURL:[self documentStorageURL] options:0 error:nil byAccessor:^(NSURL *newURL) {
//        // ensure the documentStorageURL actually exists
//        NSError *error = nil;
//        [[NSFileManager defaultManager] createDirectoryAtURL:newURL withIntermediateDirectories:YES attributes:nil error:&error];
//    }];
    
    [self.fileCoordinator coordinateReadingItemAtURL:url options:0 error:nil byAccessor:^(NSURL *newURL) {
        // ensure the documentStorageURL actually exists
    }];
    
    completionHandler(nil);
}

#endif

- (void)itemChangedAtURL:(NSURL *)url {
    // Called at some point after the file has changed; the provider may then trigger an upload
    
    /* TODO:
     - mark file at <url> as needing an update in the model
     - if there are existing NSURLSessionTasks uploading this file, cancel them
     - create a fresh background NSURLSessionTask and schedule it to upload the current modifications
     - register the NSURLSessionTask with NSFileProviderManager to provide progress updates
     */
}

- (void)stopProvidingItemAtURL:(NSURL *)url {
    // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
    
    
    // TODO: look up whether the file has local changes
    BOOL fileHasLocalChanges = NO;
    
    if (!fileHasLocalChanges) {
        // remove the existing file to free up space
        [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
        
        // write out a placeholder to facilitate future property lookups
        [self providePlaceholderAtURL:url completionHandler:^(NSError * __nullable error) {
            // TODO: handle any error, do any necessary cleanup
        }];
    }
    
}

#pragma mark - Actions

/* TODO: implement the actions for items here
 each of the actions follows the same pattern:
 - make a note of the change in the local model
 - schedule a server request as a background task to inform the server of the change
 - call the completion block with the modified item in its post-modification state
 */

#pragma mark - Enumeration

- (nullable id<NSFileProviderEnumerator>)enumeratorForContainerItemIdentifier:(NSFileProviderItemIdentifier)containerItemIdentifier error:(NSError **)error {
    id<NSFileProviderEnumerator> enumerator = nil;
    if ([containerItemIdentifier isEqualToString:NSFileProviderRootContainerItemIdentifier]) {
        return [[FileProviderEnumerator alloc] initWithEnumeratedItemIdentifier:FBSharedContainerHomeDirectory()];
        
    } else if ([containerItemIdentifier isEqualToString:NSFileProviderWorkingSetContainerItemIdentifier]) {
        // TODO: instantiate an enumerator that recursively enumerates all directories
        return [[FileProviderEnumerator alloc] initWithEnumeratedItemIdentifier:FBSharedContainerHomeDirectory()];
        
    } else {
        // TODO: determine if the item is a directory or a file
        // - for a directory, instantiate an enumerator of its subitems
        // - for a file, instantiate an enumerator that observes changes to the file
        
        return [[FileProviderEnumerator alloc] initWithEnumeratedItemIdentifier:containerItemIdentifier];
    }
    
    
    return enumerator;
}

@end

NSString *FBSharedContainerHomeDirectory()
{
    NSFileProviderManager *manager = [NSFileProviderManager defaultManager];
    NSURL *perItemDirectory = manager.documentStorageURL;
    
    return perItemDirectory.path;
    
    NSString *basePath = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.highcaffeinecontent.Files"] path] stringByAppendingPathComponent:@"File Provider Storage/Documents/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return basePath;
}

