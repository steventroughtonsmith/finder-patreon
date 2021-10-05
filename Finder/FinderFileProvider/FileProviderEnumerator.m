//
//  FileProviderEnumerator.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FileProviderEnumerator.h"
#import "FileProviderItem.h"
#import "FileProviderExtension.h"

@implementation FileProviderEnumerator

-(NSArray *)contentsForPath:(NSString *)path
{
    NSError *error = nil;
    NSArray *tempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error)
    {
        NSLog(@"ERROR: %@", error);
        
        if ([path isEqualToString:@"/System"])
            tempFiles = @[@"Library"];
        
        if ([path isEqualToString:@"/Library"])
            tempFiles = @[@"Preferences"];
        
        if ([path isEqualToString:@"/var"])
            tempFiles = @[@"mobile"];
        
        if ([path isEqualToString:@"/usr"])
            tempFiles = @[@"lib", @"libexec", @"bin"];
    }
    
    return tempFiles;
}

- (instancetype)initWithEnumeratedItemIdentifier:(NSFileProviderItemIdentifier)enumeratedItemIdentifier {
    if (self = [super init]) {
        _enumeratedItemIdentifier = enumeratedItemIdentifier;
    }
    return self;
}

- (void)invalidate {
    // TODO: perform invalidation of server connection if necessary
}

- (void)enumerateItemsForObserver:(id<NSFileProviderEnumerationObserver>)observer startingAtPage:(NSFileProviderPage)page {
    /* TODO:
     - inspect the page to determine whether this is an initial or a follow-up request
     
     If this is an enumerator for a directory, the root container or all directories:
     - perform a server request to fetch directory contents
     If this is an enumerator for the active set:
     - perform a server request to update your local database
     - fetch the active set from your local database
     
     - inform the observer about the items returned by the server (possibly multiple times)
     - inform the observer that you are finished with this page
     */
    
    
    
    NSMutableArray *providersArray = @[].mutableCopy;
    
    NSString *basePath = _enumeratedItemIdentifier;
    
    //NSLog(@"FINDER] _enumeratedItemIdentifier = %@", _enumeratedItemIdentifier);
    //System/Library/CoreServices/SpringBoard.app/
    if (!_enumeratedItemIdentifier)
        return;
    
    for (NSString *item in [self contentsForPath:basePath])
    {
        FileProviderItem *providerItem = [[FileProviderItem alloc] initWithPath:[basePath stringByAppendingPathComponent:item]];
        [providersArray addObject:providerItem];
    }
    
    [observer didEnumerateItems:providersArray];
    [observer finishEnumeratingUpToPage:page];
}

- (void)enumerateChangesForObserver:(id<NSFileProviderChangeObserver>)observer fromSyncAnchor:(NSFileProviderSyncAnchor)anchor {
    /* TODO:
     - query the server for updates since the passed-in sync anchor
     
     If this is an enumerator for the active set:
     - note the changes in your local database
     
     - inform the observer about item deletions and updates (modifications + insertions)
     - inform the observer when you have finished enumerating up to a subsequent sync anchor
     */
}

@end
