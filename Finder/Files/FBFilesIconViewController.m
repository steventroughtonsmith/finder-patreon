//
//  FBFilesIconViewController.m
//  Files
//
//  Created by Steven Troughton-Smith on 26/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FBShared.h"
#import "AppDelegate.h"
#import "FBFilesIconViewController.h"
#import "FBFilesIconCell.h"
#import "FBCustomPreviewController.h"
#import "FBColumnNavigationController.h"

#import "FBColumnViewController.h"

#if TARGET_OS_IOS
#import "FBQLPreviewController.h"
#endif

@import WindowKit;

@interface FBFilesIconViewController ()

@end

@implementation FBFilesIconViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)initWithPath:(NSString *)path
{
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(120, 120+32);
	layout.minimumInteritemSpacing = 4;
	layout.minimumLineSpacing = 4;
	
	
	self = [super initWithCollectionViewLayout:layout];
	if (self) {
		
		[self.collectionView registerNib:[UINib nibWithNibName:@"FBFilesIconCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
		self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
		self.collectionView.delegate = self;
		
		
		self.path = [path stringByExpandingTildeInPath];
		
		
//		UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
//		[self.collectionView addGestureRecognizer:pinch];
//		
		/*
		 [[NSNotificationCenter defaultCenter]  addObserverForName:@"FBFileTableViewControllerNavigateUp" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
			[self navigateUp:self];
		 }];
		 
		 
		 [[NSNotificationCenter defaultCenter]  addObserverForName:@"FBFileTableViewControllerNavigateDown" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
			[self navigateDown:self];
		 }];
		 */
		
		
		
		/*
		 [[NSNotificationCenter defaultCenter] addObserver:self
		 selector:@selector(defaultsChanged:)
		 name:NSUserDefaultsDidChangeNotification
		 object:nil];
		 */
		//[self sortFiles];
		
		self.collectionView.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

-(void)refresh:(id)sender
{
	[self setPath:self.path];
}

-(void)setPath:(NSString *)path
{
	_path = path;
	
	self.title = [path lastPathComponent];
	
	self.columnViewController.title = self.title;
	
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
	
	self.files = [tempFiles sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(NSString* file1, NSString* file2) {
		NSString *newPath1 = [self.path stringByAppendingPathComponent:file1];
		NSString *newPath2 = [self.path stringByAppendingPathComponent:file2];
		
		BOOL isDirectory1, isDirectory2;
		[[NSFileManager defaultManager ] fileExistsAtPath:newPath1 isDirectory:&isDirectory1];
		[[NSFileManager defaultManager ] fileExistsAtPath:newPath2 isDirectory:&isDirectory2];
		
		if (isDirectory1 && !isDirectory2)
			return NSOrderedDescending;
		
		return  NSOrderedAscending;
	}];
	
	
	#if TARGET_OS_IOS
	UIBarButtonItem *itemCountBarItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%lu item%@", (unsigned long)self.files.count, ((self.files.count == 0) || (self.files.count > 1)) ? @"s" : @""] style:UIBarButtonItemStylePlain target:nil action:nil];
	UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	
	UISlider *sliderView = [UISlider new];
	
	sliderView.maximumValue = 256;
	sliderView.minimumValue = 80;
	sliderView.value = 120;
	
	[sliderView addTarget:self action:@selector(changeIconSize:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *iconSlider = [[UIBarButtonItem alloc] initWithCustomView:sliderView];
	
	itemCountBarItem.tintColor = [UIColor blackColor];
	[itemCountBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
	
	[self setToolbarItems:@[flexibleSpace,itemCountBarItem,flexibleSpace, iconSlider]];
#endif
	
	
	[self.collectionView reloadData];
	//[self.self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
	
	//	self.collectionView.contentSize = self.view.bounds.size;
	
	if (self.files.count)
	{
		[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
	}

}

#if TARGET_OS_IOS
-(void)pinch:(UIPinchGestureRecognizer *)pinch
{
	
	UICollectionViewFlowLayout *fl = (UICollectionViewFlowLayout *) self.collectionViewLayout;
	
	CGFloat possible = fl.itemSize.width;
	
	possible *= pinch.scale/2.0;
	
	[self _setIconSize:possible];
}

-(void)changeIconSize:(UISlider *)sender
{
	CGFloat size = sender.value;
	[self _setIconSize:size];
}
#endif

-(void)_setIconSize:(CGFloat)size
{
	if (size < 90 || size > 256)
		return;
	
	UICollectionViewFlowLayout *fl = (UICollectionViewFlowLayout *) self.collectionViewLayout;
	
	fl.itemSize = CGSizeMake(size, size+32);
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.files.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FBFilesIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	NSString *newPath = [self.path stringByAppendingPathComponent:self.files[indexPath.row]];
	
	BOOL isDirectory;
	BOOL isSymbolic = NO;
	
	[[NSFileManager defaultManager ] fileExistsAtPath:newPath isDirectory:&isDirectory];
	
	NSDictionary *attribs = [[NSFileManager defaultManager ] attributesOfItemAtPath:newPath error:nil];
	if ([attribs[NSFileType] isEqualToString:NSFileTypeSymbolicLink])
	{
		isSymbolic = YES;
	}
	
	cell.imageView.tintColor = [UIColor colorWithRed:0.565 green:0.773 blue:0.878 alpha:1.000];
	
	UIImage *possibleImage = nil;

	if (isDirectory)
		possibleImage = [UIImage imageNamed:@"Folder"];
	else if ([[newPath pathExtension] isEqualToString:@"png"] || [[newPath pathExtension] isEqualToString:@"jpg"])
	{
		
		possibleImage = [UIImage imageWithContentsOfFile:newPath];
		
//		cell.imageView.image = [UIImage imageNamed:@"Picture"];
	}
	else
		possibleImage = [UIImage imageNamed:@"Document"];
	
	
	if (isSymbolic)
	{
		CGSize sz = possibleImage.size;
		
		UIGraphicsBeginImageContextWithOptions(sz, NO, [UIScreen mainScreen].scale);
		
		[possibleImage drawAtPoint:CGPointZero];
		[[UIImage imageNamed:@"AliasBadgeIcon"] drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
		
		possibleImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
	}
	
	cell.imageView.image = possibleImage;

	
	
	cell.textLabel.text = self.files[indexPath.row];
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	cell.highlighted = NO;
	[cell setNeedsDisplay];

	
	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	FBFilesIconCell *cell = (FBFilesIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	cell.highlighted = NO;
	[cell setNeedsDisplay];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
	
	FBFilesIconCell *cell = (FBFilesIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	cell.highlighted = YES;
	[cell setNeedsDisplay];
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *newPath = [self.path stringByAppendingPathComponent:self.files[indexPath.row]];
	
	BOOL isDirectory;
	BOOL fileExists = [[NSFileManager defaultManager ] fileExistsAtPath:newPath isDirectory:&isDirectory];
	
	
	if (fileExists)
	{
		if (isDirectory)
		{
			[self setPath:newPath];
			
			
		}
		else
		{
#ifndef APP_EXTENSION
			
			AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
			
			WKWindow *childWindow = nil;
			CGPoint p = [appDelegate.windowManager nextWindowOrigin];

			WKWindowMask mask = 0;
			
#if !BUILD_FOR_APPSTORE
			mask = WKWindowClosable|WKWindowMiniaturizable|WKWindowResizable;
#endif
			
			childWindow = [[WKWindow alloc] initWithWindowManager:appDelegate.windowManager mask:mask];
			
			
			if ([FBCustomPreviewController canHandleExtension:[newPath pathExtension]])
			{
				
				FBCustomPreviewController *preview = [[FBCustomPreviewController alloc] initWithFile:newPath];
				
				FBColumnNavigationController *detailNavController = [[FBColumnNavigationController alloc] initWithRootViewController:preview];
				
				[detailNavController setNavigationBarHidden:NO];
				childWindow.rootViewController = detailNavController;
			}
			else
			{
				#if TARGET_OS_IOS
				FBQLPreviewController *preview = [[FBQLPreviewController alloc] init];
				preview.dataSource = self;
				
				FBColumnNavigationController *detailNavController = [[FBColumnNavigationController alloc] initWithRootViewController:preview];
				
				childWindow.rootViewController = detailNavController;
#endif
			}
			
			
			
			
			
			
			[childWindow makeKeyAndVisible];
			

			[childWindow setFrame:CGRectMake(p.x, p.y, 487, 665)];
			childWindow.minimumSize = CGSizeMake(320, 320);
#endif
		}
	}
	
}

#pragma mark - QuickLook

#if TARGET_OS_IOS
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
	
	return YES;
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller {
	return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index {
	
	NSString *newPath = [self.path stringByAppendingPathComponent:self.files[self.collectionView.indexPathsForSelectedItems.lastObject.row]];
	
	return [NSURL fileURLWithPath:newPath];
}
#endif

@end
