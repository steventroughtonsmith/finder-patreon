//
//  WKWindowManager.m
//  WindowKit
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "WKWindowManager.h"
#import "WKWindow.h"
#import "WKMenuBar.h"

@interface WKWindowManager ()

@end

@implementation WKWindowManager

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.windows = [NSMutableArray arrayWithCapacity:3];
	}
	return self;
}

-(void)addWindow:(WKWindow *)window
{
	[self.windows addObject:window];
	window.windowManager = self;
}

-(void)loadView
{
	UIView *_bgView = [[UIView alloc] init];
	_bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
//	UIColor *openstepColor = [UIColor colorWithRed:0.333 green:0.330 blue:0.471 alpha:1.000];
//	UIColor *macColor = [UIColor colorWithRed:0.321 green:0.501 blue:0.734 alpha:1.000];

	_bgView.backgroundColor = [UIColor colorWithRed:0.196 green:0.195 blue:0.229 alpha:1.000];
	_bgView.tag = WKDesktopViewTag;
#if 0
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
	blurView.frame = CGRectMake(0, 0, _bgView.bounds.size.width, kMenuBarHeight+kStatusBarHeight);
	blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;

	menuBar = [[WKMenuBar alloc] initWithFrame:CGRectMake(blurView.bounds.origin.x, blurView.bounds.origin.y, blurView.bounds.size.width, blurView.bounds.size.height)];
	menuBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	blurView.clipsToBounds = NO;
	blurView.layer.shadowRadius = 30.0;
	blurView.layer.shadowColor = [UIColor blackColor].CGColor;
	blurView.layer.shadowOpacity = 0.3;
	
	[blurView.contentView addSubview:menuBar];
	[_bgView addSubview:blurView];
	
	blurView.layer.zPosition = 1000;
#endif
	self.view = _bgView;
}


-(UIColor *)backgroundColor
{
	return self.view.backgroundColor;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	
	
	if (!backgroundColor)
		self.view.backgroundColor = self.defaultBackgroundColor;
	else
		self.view.backgroundColor = backgroundColor;
}

-(CGRect)bounds
{
	return self.view.bounds;
}

-(void)updateWindowIndices
{
	NSUInteger _i = 0;
	
	for (WKWindow *window in self.windows)
	{
		window.index = _i;
		_i++;
	}
}

-(CGPoint)nextWindowOrigin
{
	CGPoint o = CGPointMake(50, 50);
	
	for (WKWindow *window in self.windows)
	{
		if (window.isKeyWindow)
		{
			o = CGPointMake(window.frame.origin.x+50, window.frame.origin.y+50);
			break;
		}
	}

	return o;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{

	return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder
{
	return YES;
}

-(NSArray <UIKeyCommand *>*)keyCommands
{
	NSMutableArray *kc = [NSMutableArray array];
	[kc addObject:[UIKeyCommand keyCommandWithInput:@"`" modifierFlags:UIKeyModifierCommand action:@selector(switchWindow:) discoverabilityTitle:@"Switch Window"]];
	
	return kc;
}

-(void)switchWindow:(id)sender
{
	NSUInteger keyIndex = 0;
	
	for (WKWindow *window in self.windows)
	{
		if (window.isKeyWindow)
		{
			keyIndex++;
			break;
		}
		
		
		keyIndex++;
	}
	
	if (keyIndex >= self.windows.count)
		keyIndex = 0;
	
	[self.windows[keyIndex] becomeKeyWindow];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	for (WKWindow *window in self.windows)
	{
		[window viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	}
}

@end
