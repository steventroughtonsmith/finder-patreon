//
//  FBCustomPreviewController.m
//  FileBrowser
//
//  Created by Steven Troughton-Smith on 29/09/2014.
//  Copyright (c) 2014 High Caffeine Content. All rights reserved.
//

#import "FBCustomPreviewController.h"

@implementation FBCustomPreviewController

- (instancetype)initWithFile:(NSString *)file
{
	self = [super init];
	if (self) {
		
		textView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
#if TARGET_OS_IOS
		textView.editable = NO;
#endif
		textView.backgroundColor = [UIColor whiteColor];
		
		imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		imageView.backgroundColor = [UIColor whiteColor];

		[self loadFile:file];

	}
	return self;
}

+(BOOL)canHandleExtension:(NSString *)fileExt
{
	if ((int)UI_USER_INTERFACE_IDIOM() != 4) // Don't use QuickLook for images on watchOS
		return ([fileExt isEqualToString:@"txt"] || [fileExt isEqualToString:@"plist"] || [fileExt isEqualToString:@"strings"] || [fileExt isEqualToString:@"xcconfig"] );

	return ([fileExt isEqualToString:@"txt"] || [fileExt isEqualToString:@"plist"] || [fileExt isEqualToString:@"strings"] || [fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"xcconfig"] || [fileExt isEqualToString:@"rtf"]  || [fileExt isEqualToString:@"htm"] || [fileExt isEqualToString:@"html"] );
}

-(void)loadFile:(NSString *)file
{
	if ([file.pathExtension isEqualToString:@"plist"] || [file.pathExtension isEqualToString:@"strings"])
	{
		NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:file];
		[textView setText:[d description]];
		self.view = textView;
	}
	else if ([file.pathExtension isEqualToString:@"xcconfig"]  || [file.pathExtension isEqualToString:@"txt"])
	{
		NSString *d = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
		[textView setText:d];
		self.view = textView;
	}
	else if ([file.pathExtension isEqualToString:@"rtf"])
	{
		NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc] initWithURL:[NSURL fileURLWithPath:file] options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
		textView.attributedText=attributedStringWithRtf;
		
		self.view = textView;
	}
	else if ([file.pathExtension isEqualToString:@"html"] || [file.pathExtension isEqualToString:@"htm"])
	{
		NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc] initWithURL:[NSURL fileURLWithPath:file] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
		textView.attributedText=attributedStringWithRtf;
		
		self.view = textView;
	}
	else
	{
		imageView.image = [UIImage imageWithContentsOfFile:file];
		self.view = imageView;
	}
	
	self.title = file.lastPathComponent;
}

@end
