//
//  FBFilesTableViewController.h
//  FileBrowser
//
//  Created by Steven Troughton-Smith on 18/06/2013.
//  Copyright (c) 2013 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_OS_IOS
#import <QuickLook/QuickLook.h>
#endif

@class FBColumnViewController;

@interface FBFilesTableViewController : UITableViewController
#if TARGET_OS_IOS
<QLPreviewControllerDataSource>
#endif

@property (strong) FBColumnViewController *columnViewController;

-(void)refresh:(id)sender;
-(id)initWithPath:(NSString *)path;
-(void)highlightPathComponent:(NSString *)pathComponent;

@property (strong, nonatomic) NSString *path;
@property (strong) NSMutableArray *files;
@end
