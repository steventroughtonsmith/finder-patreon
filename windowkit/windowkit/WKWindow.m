//
//  WKWindow.m
//  WindowManager
//
//  Created by Steven Troughton-Smith on 23/12/2015.
//  Copyright © 2015 High Caffeine Content. All rights reserved.
//

#import "WKWindow.h"
#import "WKWindowFrameView.h"
#import "WKWindowManager.h"

@import QuartzCore;

@implementation WKWindow

- (instancetype)initWithWindowManager:(WKWindowManager *)manager mask:(WKWindowMask)mask
{
	self = [super init];
	if (self) {
		self.windowMask = mask;
		
		[manager addWindow:self];
		
		_snapTargetView = [[UIView alloc] initWithFrame:CGRectZero];
		_snapTargetView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
		//colorWithRed:0.321 green:0.501 blue:0.734 alpha:0.6];
		_snapTargetView.alpha = 0;
		
		[self.windowManager.view addSubview:_snapTargetView];
		
		_frameView = [[WKWindowFrameView alloc] initWithContainingWindow:self];
		_frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.minimumSize = CGSizeMake(320, 480);
		
		self.view = _frameView;
		
		[self.windowManager.view addSubview:self.view];
		
		
		[self.windowManager.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
		
	}
	return self;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	if (self.snapped)
	{
		CGRect potentialFrame = CGRectZero;
		
		if (self.snapState == WKWindowSnapLeft)
		{
			potentialFrame = CGRectMake(-kWindowResizeGutterSize, kStatusBarHeight+kMenuBarHeight-kWindowResizeGutterSize, size.width/2+(kWindowResizeGutterSize*2), size.height-kStatusBarHeight+kMenuBarHeight+(kWindowResizeGutterSize*2));
			
		}
		else if (self.snapState == WKWindowSnapRight)
		{
			potentialFrame = CGRectMake(size.width/2-kWindowResizeGutterSize, kStatusBarHeight+kMenuBarHeight-kWindowResizeGutterSize, size.width/2+(kWindowResizeGutterSize*2), size.height-kStatusBarHeight+kMenuBarHeight+(kWindowResizeGutterSize*2));
			
		}
		
		self.frame = potentialFrame;
	}
	
	if (self.maximized)
	{
		self.frame = CGRectMake(-kWindowResizeGutterSize, kStatusBarHeight+kMenuBarHeight+-kWindowResizeGutterSize, size.width+(kWindowResizeGutterSize*2), size.height-kStatusBarHeight+kMenuBarHeight+(kWindowResizeGutterSize*2));
	}
	
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	[self _recalculateForSceneSizeChange];
}

-(void)_recalculateForSceneSizeChange
{
	CGRect containingFrame = self.frame;
	
	if (self.maximized)
	{
		[self setFrame:self.windowManager.view.bounds];
		return;
	}
	
	if (containingFrame.origin.x > (self.windowManager.view.bounds.size.width - containingFrame.size.width/2))
	{
		containingFrame.origin.x = (self.windowManager.view.bounds.size.width - containingFrame.size.width/2);
		
		[self setFrame:containingFrame];
	}
	
	
}

-(void)maximize:(id)sender
{
	self.maximized = !self.maximized;
	
	UIView *rootWindow = self.windowManager.view;
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	if (self.maximized)
	{
		
		_savedFrame = self.frame;
		self.frame = CGRectMake(-kWindowResizeGutterSize, kStatusBarHeight+kMenuBarHeight+-kWindowResizeGutterSize, rootWindow.bounds.size.width+(kWindowResizeGutterSize*2), rootWindow.bounds.size.height-kStatusBarHeight+kMenuBarHeight+(kWindowResizeGutterSize*2));
		
		_frameView.layer.shadowOpacity = 0;
		
		self.windowManager.backgroundColor = self.rootViewController.view.backgroundColor;
		
	}
	else
	{
		self.frame = _savedFrame;
		_frameView.layer.shadowOpacity = 0.3;
		
		self.windowManager.backgroundColor = nil;
	}
	
	[_frameView _adjustMask];
	[UIView commitAnimations];
}

-(void)minimize:(id)sender
{
	[self.windowManager updateWindowIndices];
	self.minimized = !self.minimized;
	
	[_frameView _adjustContentForMinimization];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	if (self.minimized)
	{
		
		_savedFrame = self.frame;
		self.rootViewController.view.alpha = 0;
		[_frameView setFrameFrame:CGRectMake(20+self.index*128, kStatusBarHeight + 20, 128, 128)];
		
		//_frameView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
		
		[self resignKeyWindow];
		
	}
	else
	{
		[_frameView setFrameFrame:_savedFrame];
		self.rootViewController.view.alpha = 1;
		
		
		[self becomeKeyWindow];
		//_frameView.layer.transform = CATransform3DMakeScale(1, 1, 1);
	}
	[UIView commitAnimations];
	
	[_frameView _adjustMask];
	
	
}

-(void)setRootViewController:(UIViewController *)rootViewController
{
	[_frameView addSubview:rootViewController.view];
	_rootViewController = rootViewController;
}

-(void)setFrame:(CGRect)frame
{
	
	
	
	
	if (frame.origin.x < 0)
	{
		//
	}
	if ((frame.size.width < self.minimumSize.width) || (frame.size.height < self.minimumSize.height))
		return;
	
	if (frame.origin.y < kStatusBarHeight-kWindowResizeGutterSize)
		return;
	
	if (frame.origin.x < 0-frame.size.width)
		return;
	
	_frame = frame;
	
	[_frameView setFrameFrame:frame];
	
	if ([[self.rootViewController class] isSubclassOfClass:[UISplitViewController class]])
	{
		UISplitViewController *svc = (UISplitViewController *)self.rootViewController;
		
		[UIView beginAnimations:nil context:nil];
		if (frame.size.width <= self.windowManager.bounds.size.width/2 || (self.snapped && !self.maximized))
		{
			svc.preferredPrimaryColumnWidthFraction = 0;
		}
		else
		{
			svc.preferredPrimaryColumnWidthFraction = UISplitViewControllerAutomaticDimension;
		}
		[UIView commitAnimations];
		
	}
	
}

-(CGRect)frame
{
	return _frame;
}

-(void)updateContentViewVisibility
{
	_frameView.hidden = self.hidden;
	[_frameView setNeedsDisplay];
	[_frameView _adjustMask];
	[_frameView updateWindowButtons];
}

-(void)makeKeyAndVisible
{
	self.hidden = NO;
	[self becomeKeyWindow];
}

-(void)close:(id)sender
{
	WKWindow *_lastW = nil;
	for (WKWindow *w in self.windowManager.windows)
	{
		if (w == self)
		{
			break;
		}
		_lastW = w;
	}
	
	[_lastW becomeKeyWindow];
	
	self.hidden = YES;
	[self updateContentViewVisibility];
	[self.windowManager.view removeObserver:self forKeyPath:@"frame"];
	
	[self.windowManager.windows removeObject:self];
}

- (void)becomeKeyWindow
{
	for (WKWindow *w in self.windowManager.windows)
	{
		w.isKeyWindow = NO;
		[w updateContentViewVisibility];
	}
	
	self.isKeyWindow = YES;
	
	UIResponder *responder = [[[UIApplication sharedApplication] keyWindow] valueForKey:@"_firstResponder"];
	[responder resignFirstResponder];
	
	[self.view.superview addSubview:self.view];
	
	self.hidden = NO;
	[self updateContentViewVisibility];
	
	[_frameView setNeedsDisplay];
	_frameView.layer.shadowRadius = 30.0;
	//	for (UIButton *btn in _frameView.windowButtons)
	//	{
	//		btn.enabled = YES;
	//	}
	
	[_frameView updateWindowButtons];
	
	[self becomeFirstResponder];
	
	if ([[self.rootViewController class] isSubclassOfClass:[UISplitViewController class]])
	{
		UISplitViewController *svc = (UISplitViewController *)self.rootViewController;
		[[[svc.viewControllers lastObject] topViewController] becomeFirstResponder];
	}
}

- (void)resignKeyWindow
{
	[_frameView setNeedsDisplay];
	_frameView.layer.shadowRadius = 10.0;
	
	for (UIButton *btn in _frameView.windowButtons)
	{
		btn.enabled = NO;
	}
	[self resignFirstResponder];
}

-(void)update
{
	[_frameView _adjustMask];
	[_frameView updateWindowButtons];
}

-(BOOL)canBecomeFirstResponder
{
	return YES;
}

-(NSArray <UIKeyCommand *>*)keyCommands
{
	NSMutableArray *kc = [NSMutableArray array];
	
	
	if ((self.windowMask & WKWindowClosable))
		[kc addObject:[UIKeyCommand keyCommandWithInput:@"W" modifierFlags:UIKeyModifierCommand action:@selector(close:) discoverabilityTitle:@"Close Window"]];
	
	if ((self.windowMask & WKWindowMiniaturizable))
		[kc addObject:[UIKeyCommand keyCommandWithInput:@"M" modifierFlags:UIKeyModifierCommand action:@selector(minimize:) discoverabilityTitle:@"Minimize Window"]];
	
	
	NSString *fullscreenTitle = @"Enter Full Screen";
	
	if (self.maximized)
	{
		fullscreenTitle = @"Exit Full Screen";
	}
	
	[kc addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:UIKeyModifierCommand|UIKeyModifierShift action:@selector(snapLeft:) discoverabilityTitle:@"Snap Window Left"]];
	[kc addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:UIKeyModifierCommand|UIKeyModifierShift action:@selector(snapRight:) discoverabilityTitle:@"Snap Window Right"]];
	
	/*
	 [kc addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:UIKeyModifierCommand|UIKeyModifierShift action:@selector(unsnap:) discoverabilityTitle:@"Leave Snapped Mode"]];
	 
	 [kc addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:UIKeyModifierCommand|UIKeyModifierShift action:@selector(maximize:)]];
	 */
	
	if ((self.windowMask & WKWindowResizable))
		[kc addObject:[UIKeyCommand keyCommandWithInput:@"F" modifierFlags:UIKeyModifierCommand|UIKeyModifierControl action:@selector(maximize:) discoverabilityTitle:fullscreenTitle]];
	
	return kc;
}

-(void)snapRight:(id)sender
{
	[self snap:WKWindowSnapRight];
}

-(void)snapLeft:(id)sender
{
	[self snap:WKWindowSnapLeft];
}

-(void)unsnap:(id)sender
{
	[self snap:WKWindowSnapNone];
}

-(void)snap:(WKWindowSnap)snap
{
	CGRect potentialFrame = CGRectZero;
	_snapTargetView.alpha = 0;
	
	if (self.windowManager.view.bounds.size.width < self.minimumSize.width)
	{
		self.snapped = NO;
		//[self maximize:self];
		return;
	}
	
	if (snap == WKWindowSnapNone)
	{
		if (self.snapState != WKWindowSnapNone)
			self.frame = _savedPreSnapFrame;
	}
	
	
	if (snap == WKWindowSnapLeft)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapRight)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapFullscreen)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapTopLeft)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapBottomLeft)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(0, kMenuBarHeight+self.windowManager.bounds.size.height/2, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapTopRight)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapBottomRight)
	{
		if (self.snapState == WKWindowSnapNone)
			_savedPreSnapFrame = self.frame;
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, kMenuBarHeight+self.windowManager.bounds.size.height/2, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2+kMenuBarHeight);
		
	}
	
	potentialFrame = CGRectInset(potentialFrame, -kWindowResizeGutterSize, -kWindowResizeGutterSize);
	
	if (snap != WKWindowSnapNone)
	{
		self.frame = potentialFrame;
		
		self.snapped = YES;
	}
	
	self.maximized = NO;
	self.snapState = snap;
	[_frameView _adjustMask];
}

CGRect _snapTargetViewPreviousPotentialFrame;

-(void)showTargetForSnap:(WKWindowSnap)snap
{
	CGRect potentialFrame = CGRectZero;
	
	if (snap == WKWindowSnapNone)
	{
		_snapTargetView.alpha = 0;
		return;
	}
	
	
	if (snap == WKWindowSnapLeft)
	{
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapRight)
	{
		
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapFullscreen)
	{
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width, self.windowManager.bounds.size.height-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapTopLeft)
	{
		
		potentialFrame = CGRectMake(0, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapBottomLeft)
	{
		
		
		potentialFrame = CGRectMake(0, kMenuBarHeight+self.windowManager.bounds.size.height/2, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapTopRight)
	{
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, kStatusBarHeight+kMenuBarHeight, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2-kStatusBarHeight+kMenuBarHeight);
		
	}
	else if (snap == WKWindowSnapBottomRight)
	{
		
		potentialFrame = CGRectMake(self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2, self.windowManager.bounds.size.width/2, self.windowManager.bounds.size.height/2+kMenuBarHeight);
		
	}
	
	for (WKWindow *window in self.windowManager.windows)
	{
		if (window == self)
			continue;
		
		if (window.snapState == snap)
		{
			if (snap == WKWindowSnapLeft)
				[window snap:WKWindowSnapRight];
			else if (snap == WKWindowSnapRight)
				[window snap:WKWindowSnapLeft];
			else if (snap == WKWindowSnapTopLeft)
				[window snap:WKWindowSnapBottomLeft];
			else if (snap == WKWindowSnapBottomLeft)
				[window snap:WKWindowSnapTopLeft];
			else if (snap == WKWindowSnapTopRight)
				[window snap:WKWindowSnapBottomRight];
			else if (snap == WKWindowSnapBottomRight)
				[window snap:WKWindowSnapTopRight];
			
		}
		
		if (window.snapState == WKWindowSnapFullscreen)
		{
			if (snap == WKWindowSnapLeft)
				[window snap:WKWindowSnapRight];
			else if (snap == WKWindowSnapRight)
				[window snap:WKWindowSnapLeft];
		}
		
		if (((snap == WKWindowSnapTopLeft) || (snap == WKWindowSnapBottomLeft)) && (window.snapState == WKWindowSnapLeft))
		{
			if (snap == WKWindowSnapTopLeft)
				[window snap:WKWindowSnapBottomLeft];
			else if (snap == WKWindowSnapBottomLeft)
				[window snap:WKWindowSnapTopLeft];
		}
		
		if (((snap == WKWindowSnapTopRight) || (snap == WKWindowSnapBottomRight)) && (window.snapState == WKWindowSnapRight))
		{
			if (snap == WKWindowSnapTopRight)
				[window snap:WKWindowSnapBottomRight];
			else if (snap == WKWindowSnapBottomRight)
				[window snap:WKWindowSnapTopRight];
		}
		
	}
	
	//potentialFrame = CGRectInset(potentialFrame, -kWindowResizeGutterSize, -kWindowResizeGutterSize);
	
	if (snap != WKWindowSnapNone)
	{
		if (!CGRectEqualToRect(_snapTargetViewPreviousPotentialFrame, self.frame))
		{
			[CATransaction begin];
			[CATransaction setDisableActions:YES];
			_snapTargetView.frame = self.frame;
			[CATransaction commit];
		}
		
		_snapTargetViewPreviousPotentialFrame = self.frame;
		_snapTargetView.frame = potentialFrame;
		_snapTargetView.alpha = 1;
	}
}

@end
