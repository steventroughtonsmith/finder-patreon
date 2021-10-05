//
//  FBFilesIconViewController.h
//  Files
//
//  Created by Steven Troughton-Smith on 26/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_OS_IOS
@import QuickLook;
#endif

@class FBColumnViewController;

@interface FBFilesIconViewController : UICollectionViewController
#if TARGET_OS_IOS
<QLPreviewControllerDataSource>
#endif

@property (strong) FBColumnViewController *columnViewController;

-(void)refresh:(id)sender;
-(id)initWithPath:(NSString *)path;
@property (strong, nonatomic) NSString *path;
@property (strong) NSArray *files;

@end
