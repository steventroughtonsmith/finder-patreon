//
//  WKWindowFrameView.m
//  WindowKit
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import <WindowKit/WindowKit.h>
#import "WKWindowFrameView.h"

@implementation UIImage (AspectRatio)

- (UIImage *)imageScaledToSize:(CGSize)size
{
	//create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
	
	//draw
	[self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	
	//capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage *)imageScaledToFitSize:(CGSize)size
{
	//calculate rect
	CGFloat aspect = self.size.width / self.size.height;
	if (size.width / aspect <= size.height)
	{
		return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
	}
	else
	{
		return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
	}
}

@end

@implementation WKWindowFrameView


-(void)_commonInit
{
	self.windowButtons = @[].mutableCopy;
	
	{
		UIButton *windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		windowButton.frame = CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize, kWindowButtonFrameSize, kWindowButtonFrameSize);
		windowButton.contentMode = UIViewContentModeCenter;
		windowButton.adjustsImageWhenHighlighted = YES;
		
		[windowButton addTarget:self.containingWindow action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIColor *fillColor = [UIColor colorWithRed:0.953 green:0.278 blue:0.275 alpha:1.000] ;
		UIColor *strokeColor = [UIColor colorWithRed:0.839 green:0.188 blue:0.192 alpha:1.000];
		
		UIColor *inactiveFillColor = [UIColor colorWithWhite:0.765 alpha:1.000];
		UIColor *inactiveStrokeColor = [UIColor colorWithWhite:0.608 alpha:1.000];
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[fillColor setFill];
		[strokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
		UIGraphicsEndImageContext();
		
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[inactiveFillColor setFill];
		[inactiveStrokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateDisabled];
		UIGraphicsEndImageContext();
		
		[self addSubview:windowButton];
		
		[self.windowButtons addObject:windowButton];
		
	}
	
	{
		UIButton *windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		windowButton.frame = CGRectMake(kWindowResizeGutterSize+12+kWindowButtonSize, kWindowResizeGutterSize, kWindowButtonFrameSize, kWindowButtonFrameSize);
		windowButton.contentMode = UIViewContentModeCenter;
		windowButton.adjustsImageWhenHighlighted = YES;
		[windowButton addTarget:self.containingWindow action:@selector(minimize:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIColor *fillColor = [UIColor colorWithRed:1.000 green:0.833 blue:0.000 alpha:1.000] ;
		UIColor *strokeColor = [UIColor colorWithRed:0.800 green:0.700 blue:0.000 alpha:1.000];
		
		UIColor *inactiveFillColor = [UIColor colorWithWhite:0.765 alpha:1.000];
		UIColor *inactiveStrokeColor = [UIColor colorWithWhite:0.608 alpha:1.000];
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[fillColor setFill];
		[strokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
		UIGraphicsEndImageContext();
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[inactiveFillColor setFill];
		[inactiveStrokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateDisabled];
		UIGraphicsEndImageContext();
		
		[self addSubview:windowButton];
		[self.windowButtons addObject:windowButton];
	}
	
	{
		UIButton *windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		windowButton.frame = CGRectMake(kWindowResizeGutterSize+12+kWindowButtonSize+12+kWindowButtonSize, kWindowResizeGutterSize, kWindowButtonFrameSize, kWindowButtonFrameSize);
		windowButton.contentMode = UIViewContentModeCenter;
		windowButton.adjustsImageWhenHighlighted = YES;
		[windowButton addTarget:self.containingWindow action:@selector(maximize:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIColor *fillColor = [UIColor colorWithRed:0.188 green:0.769 blue:0.196 alpha:1.000] ;
		UIColor *strokeColor = [UIColor colorWithRed:0.165 green:0.624 blue:0.125 alpha:1.000];
		
		UIColor *inactiveFillColor = [UIColor colorWithWhite:0.765 alpha:1.000];
		UIColor *inactiveStrokeColor = [UIColor colorWithWhite:0.608 alpha:1.000];
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[fillColor setFill];
		[strokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
		UIGraphicsEndImageContext();
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[inactiveFillColor setFill];
		[inactiveStrokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateDisabled];
		UIGraphicsEndImageContext();
		
		[self addSubview:windowButton];
		[self.windowButtons addObject:windowButton];
	}
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	panRecognizer.delegate = self;
	[self addGestureRecognizer:panRecognizer];
	
	UITapGestureRecognizer *focusRecognizers = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	focusRecognizers.delegate = self;
	focusRecognizers.cancelsTouchesInView = NO;
	[self addGestureRecognizer:focusRecognizers];
	
	
	
	self.layer.shadowRadius = 30.0;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.3;
}

-(void)updateWindowButtons
{
	if (self.containingWindow.minimized)
	{
		self.windowButtons[0].alpha = 0;
		self.windowButtons[1].alpha = 0;
		self.windowButtons[2].alpha = 0;
	}
	else
	{
		if (self.containingWindow.isKeyWindow)
		{
			self.windowButtons[0].alpha = 1;
			self.windowButtons[1].alpha = 1;
			self.windowButtons[2].alpha = 1;
		}
		else
		{
			self.windowButtons[0].alpha = 0.3;
			self.windowButtons[1].alpha = 0.3;
			self.windowButtons[2].alpha = 0.3;
		}
	}
	
	self.windowButtons[0].enabled = (self.containingWindow.windowMask & WKWindowClosable);
	self.windowButtons[1].enabled = (self.containingWindow.windowMask & WKWindowMiniaturizable);
	self.windowButtons[2].enabled = (self.containingWindow.windowMask & WKWindowResizable);
	
	if (self.containingWindow.windowManager.allowsFreeformWindowing == NO)
	{
		self.windowButtons[0].alpha = (self.containingWindow.windowMask & WKWindowClosable) ? 1 : 0;
		self.windowButtons[1].alpha = 0;//(self.containingWindow.windowMask & WKWindowMiniaturizable);
		self.windowButtons[2].alpha = 0;//(self.containingWindow.windowMask & WKWindowResizable);
	}
}

-(void)layoutSubviews
{
	UIView *rootView = self.containingWindow.rootViewController.view;
	
	CGRect contentRect = CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize+kTitleBarHeight, self.bounds.size.width-(kWindowResizeGutterSize*2), self.bounds.size.height-kTitleBarHeight-(kWindowResizeGutterSize*2));
	
	rootView.frame = contentRect;
	[self _adjustMask];
	[self updateWindowButtons];
}

-(BOOL)isOpaque
{
	return NO;
}

- (instancetype)initWithContainingWindow:(WKWindow *)window
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.containingWindow = window;
		[self _commonInit];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self _commonInit];
	}
	return self;
}

-(void)addSubview:(UIView *)view
{
	[super addSubview:view];
	for (UIButton *btn in self.windowButtons)
	{
		[self bringSubviewToFront:btn];
	}
}

-(void)didTap:(UIGestureRecognizer *)rec
{
	
	if (self.containingWindow.minimized)
	{
		[self.containingWindow minimize:self];
		return;
	}
	
	if ((self.containingWindow.windowMask & WKWindowNonActivating))
		return;
	
	[self.containingWindow becomeKeyWindow];
	[self _adjustMask];
}

-(void)setFrame:(CGRect)frame
{
	
}

-(void)setFrameFrame:(CGRect)frame
{
	
	[super setFrame:frame];
	[self setNeedsDisplay];
}


-(void)didPan:(UIPanGestureRecognizer *)recognizer
{
	
	CGRect titleBarRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+kWindowResizeGutterTargetSize, self.bounds.size.width, kMoveGrabHeight);
	CGPoint gp = [recognizer locationInView:[UIApplication sharedApplication].windows[0]];
	CGPoint lp = [recognizer locationInView:self];
	
	CGRect leftResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, kWindowResizeGutterTargetSize, self.bounds.size.height);
	CGRect rightResizeRect = CGRectMake(self.bounds.origin.x+self.bounds.size.width-kWindowResizeGutterTargetSize, self.bounds.origin.y, kWindowResizeGutterTargetSize, self.bounds.size.height);
	
	CGRect topResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, kWindowResizeGutterTargetSize);
	CGRect bottomResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.size.height-kWindowResizeGutterTargetSize, self.bounds.size.width, kWindowResizeGutterTargetSize);
	
	if (self.containingWindow.minimized)
	{
		return;
		//		lp.x /= 3;
		//		lp.y /= 3;
	}
	
	leftResizeRect = CGRectInset(leftResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	rightResizeRect = CGRectInset(rightResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	bottomResizeRect = CGRectInset(bottomResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	topResizeRect = CGRectInset(topResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	topResizeRect = CGRectOffset(topResizeRect, 0, -kWindowResizeGutterTargetSize);
	
	if (self.containingWindow.maximized)
		return;
	
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		_originPoint = lp;
		
		if (self.containingWindow.minimized || CGRectContainsPoint(titleBarRect, lp))
		{
			_inWindowMove = YES;
			_inWindowResize = NO;
			
			//			self.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
			
			if (!self.containingWindow.snapped)
				_originalBounds = self.bounds;
			
			
			{
				if (_originalBounds.size.width < self.containingWindow.minimumSize.width)
					_originalBounds.size.width = self.containingWindow.minimumSize.width;
				
				if (_originalBounds.size.height < self.containingWindow.minimumSize.height)
					_originalBounds.size.height = self.containingWindow.minimumSize.height;
			}
			
			
			if (!(self.containingWindow.windowMask & WKWindowNonActivating))
			{
				[self.containingWindow becomeKeyWindow];
			}
			
			if (self.containingWindow.minimized)
			{
				_originalBounds.origin.x /= 3;
				_originalBounds.origin.y /= 3;
				_originalBounds.size.width /= 3;
				_originalBounds.size.height /= 3;
			}
			
			return;
		}
		
		if (!self.containingWindow.isKeyWindow)
			return;
		
		if (!(self.containingWindow.windowMask & WKWindowResizable))
			return;
		
		if (self.containingWindow.minimized)
		{
			return;
		}
		
		if (self.containingWindow.snapped)
		{
			return;
		}
		
		if (CGRectContainsPoint(leftResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeLeft;
		}
		
		if (CGRectContainsPoint(rightResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeRight;
		}
		
		
		if (CGRectContainsPoint(topResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeTop;
		}
		
		if (CGRectContainsPoint(bottomResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeBottom;
		}
	}
	else if (recognizer.state == UIGestureRecognizerStateChanged)
	{
		
		if (_inWindowMove)
		{
			CGRect potentialFrame = CGRectMake(gp.x-_originPoint.x, gp.y-_originPoint.y, self.frame.size.width, self.frame.size.height);;
			BOOL animate = NO;
			
			WKWindowSnap possibleSnap = WKWindowSnapNone;
			
			if (gp.x < 40 && !self.containingWindow.minimized) // Snap Left
			{
				if (gp.y < self.containingWindow.windowManager.bounds.size.height/4)
				{
					possibleSnap = WKWindowSnapTopLeft;
					
				}
				else if (gp.y > self.containingWindow.windowManager.bounds.size.height-(self.containingWindow.windowManager.bounds.size.height/4))
				{
					possibleSnap = WKWindowSnapBottomLeft;
				}
				else
					possibleSnap = WKWindowSnapLeft;
				animate = YES;
				
			} else if (gp.x > self.containingWindow.windowManager.bounds.size.width-40 && !self.containingWindow.minimized) // Snap Right
			{
				if (gp.y < self.containingWindow.windowManager.bounds.size.height/4)
				{
					possibleSnap = WKWindowSnapTopRight;
					
				}
				else if (gp.y > self.containingWindow.windowManager.bounds.size.height-(self.containingWindow.windowManager.bounds.size.height/4))
				{
					possibleSnap = WKWindowSnapBottomRight;
				}
				else
					possibleSnap = WKWindowSnapRight;
				
				animate = YES;
			}
			else if (gp.y < 40 && !self.containingWindow.minimized) // Snap Right
			{
				possibleSnap = WKWindowSnapFullscreen;
				animate = YES;
			}
			else
			{
				potentialFrame.size.width = _originalBounds.size.width;
				potentialFrame.size.height = _originalBounds.size.height;
				
				if (self.containingWindow.snapped)
				{
					_originPoint.x = _originalBounds.size.width/2;
				}
			}
			
			if (animate)
			{
				[UIView animateWithDuration:0.15 delay:0 options:0 animations:^{
					[self.containingWindow showTargetForSnap:possibleSnap];
				} completion:nil];
				
				
			}
			else
			{
				[UIView animateWithDuration:0.15 delay:0 options:0 animations:^{
					[self.containingWindow showTargetForSnap:WKWindowSnapNone];
				} completion:nil];
				
				if (self.containingWindow.snapped)
				{
					self.containingWindow.snapped = NO;
					[self _adjustMask];
					
				}
				
				
				self.containingWindow.frame = potentialFrame;
			}
			
		}
		if (_inWindowResize)
		{
			if (resizeAxis == WMResizeRight)
			{
				self.containingWindow.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, gp.x-self.frame.origin.x, self.frame.size.height);
			}
			
			if (resizeAxis == WMResizeLeft)
			{
				self.containingWindow.frame = CGRectMake(gp.x, self.frame.origin.y, (-gp.x+self.frame.origin.x)+self.frame.size.width, self.frame.size.height);
			}
			
			if (resizeAxis == WMResizeBottom)
			{
				self.containingWindow.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,gp.y-self.frame.origin.y);
			}
			
			if (resizeAxis == WMResizeTop)
			{
				self.containingWindow.frame = CGRectMake(self.frame.origin.x, gp.y, self.frame.size.width, self.frame.size.height+(self.frame.origin.y-gp.y));
			}
		}
	}
	else if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		if (_inWindowMove)
		{
			CGRect potentialFrame = CGRectMake(gp.x-_originPoint.x, gp.y-_originPoint.y, self.frame.size.width, self.frame.size.height);;
			BOOL animate = NO;
			
			WKWindowSnap possibleSnap = WKWindowSnapNone;
			
			if (gp.x < 40 && !self.containingWindow.minimized) // Snap Left
			{
				if (gp.y < self.containingWindow.windowManager.bounds.size.height/4)
				{
					possibleSnap = WKWindowSnapTopLeft;
					
				}
				else if (gp.y > self.containingWindow.windowManager.bounds.size.height-(self.containingWindow.windowManager.bounds.size.height/4))
				{
					possibleSnap = WKWindowSnapBottomLeft;
				}
				else
					possibleSnap = WKWindowSnapLeft;
				animate = YES;
				
			} else if (gp.x > self.containingWindow.windowManager.bounds.size.width-40 && !self.containingWindow.minimized) // Snap Right
			{
				if (gp.y < self.containingWindow.windowManager.bounds.size.height/4)
				{
					possibleSnap = WKWindowSnapTopRight;
					
				}
				else if (gp.y > self.containingWindow.windowManager.bounds.size.height-(self.containingWindow.windowManager.bounds.size.height/4))
				{
					possibleSnap = WKWindowSnapBottomRight;
				}
				else
					possibleSnap = WKWindowSnapRight;
				
				animate = YES;
			}
			else if (gp.y < 40 && !self.containingWindow.minimized) // Snap Right
			{
				possibleSnap = WKWindowSnapFullscreen;
				animate = YES;
			}
			else
			{
			
				
				
				potentialFrame.size.width = _originalBounds.size.width;
				potentialFrame.size.height = _originalBounds.size.height;
				self.containingWindow.snapped = NO;
			}
			
			if (animate)
			{
				[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
					[self.containingWindow snap:possibleSnap];
				} completion:nil];
			}
			else
			{
				if (self.containingWindow.windowManager.allowsFreeformWindowing)
				{
					self.containingWindow.frame = potentialFrame;
				}
				else
				{
					[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
						[self.containingWindow snap:self.containingWindow.snapState];
					} completion:nil];
				}
				
			}
		}
		
		
		//		self.layer.transform = CATransform3DMakeScale(1, 1, 1);
		
		
		_inWindowMove = NO;
		_inWindowResize = NO;
		[self setNeedsDisplay];
	}
	
	
}

-(void)_adjustMask
{
	CGRect contentBounds = self.containingWindow.rootViewController.view.bounds;
	CGRect contentFrame = CGRectMake(self.bounds.origin.x+kWindowResizeGutterSize, self.bounds.origin.y+kWindowResizeGutterSize, self.bounds.size.width-(kWindowResizeGutterSize*2), self.bounds.size.height-(kWindowResizeGutterSize*2));
	
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	
	if ((self.containingWindow.windowMask & WKWindowNonActivating) || self.containingWindow.snapped)
	{
		maskLayer.path = [UIBezierPath bezierPathWithRect:contentBounds].CGPath;
		
		self.containingWindow.rootViewController.view.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3].CGColor;
		self.containingWindow.rootViewController.view.layer.borderWidth = 0.25;
	}
	else
	{
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:contentBounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)].CGPath;
		
		self.containingWindow.rootViewController.view.layer.borderWidth = 0;
	}
	
	
	maskLayer.frame = contentBounds;
	
	self.containingWindow.rootViewController.view.layer.mask = maskLayer;
	
	self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:contentFrame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)].CGPath;
	
	if (self.containingWindow.isKeyWindow || self.containingWindow.minimized)
		self.layer.shadowRadius = 30.0;
	else
		self.layer.shadowRadius = 10.0;
	
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.3;
	
	if (self.containingWindow.maximized || self.containingWindow.snapped)
		self.layer.shadowOpacity = 0;
}

-(void)_snapShotContentsForMinimization
{
	UIGraphicsBeginImageContextWithOptions (self.bounds.size, NO, self.window.screen.scale);
	
	if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
	{
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	}
	
	_thumbnail = [UIGraphicsGetImageFromCurrentImageContext() imageScaledToFitSize:CGSizeMake(128, 128)];
	
	UIGraphicsEndImageContext();
}

-(void)_adjustContentForMinimization
{
	[self _snapShotContentsForMinimization];
	if (self.containingWindow.minimized)
	{
		//		self.opaque = self.containingWindow.minimized;
		//self.backgroundColor = self.containingWindow.rootViewController.view.backgroundColor;
	}
	else
	{
		//		self.opaque = NO;
		//self.backgroundColor = nil;
	}
	[self updateWindowButtons];
	
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if (self.containingWindow.isKeyWindow)
		return YES;
	
	return NO;
}



- (void)drawRect:(CGRect)rect
{
	if (!(self.containingWindow.windowMask & WKWindowResizable))
		return;
	
	if (self.containingWindow.minimized)
	{
		
		CGSize sz = _thumbnail.size;
		
		[_thumbnail drawInRect:CGRectMake((self.bounds.size.width-sz.width)/2, (self.bounds.size.height-sz.height)/2, sz.width, sz.height)];
		return;
	}
	
	if (self.containingWindow.snapped)
	{
		[[UIColor colorWithWhite:0 alpha:0.2] set];
		UIRectFill(CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize, 1, self.bounds.size.height-(kWindowResizeGutterSize*2)));
		UIRectFill(CGRectMake(self.bounds.size.width-kWindowResizeGutterSize, kWindowResizeGutterSize, 1, self.bounds.size.height-(kWindowResizeGutterSize*2)));
		
	}
	
	if (self.containingWindow.isKeyWindow && !self.containingWindow.maximized && !self.containingWindow.snapped)
	{
		if (_inWindowResize)
		{
			CGRect leftResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+kWindowResizeGutterSize, kWindowResizeGutterSize, self.bounds.size.height-(kWindowResizeGutterSize*2));
			CGRect rightResizeRect = CGRectMake(self.bounds.origin.x+self.bounds.size.width-kWindowResizeGutterSize, self.bounds.origin.y+kWindowResizeGutterSize, kWindowResizeGutterSize, self.bounds.size.height-(kWindowResizeGutterSize*2));
			
			CGRect bottomResizeRect = CGRectMake(self.bounds.origin.x+kWindowResizeGutterSize, self.bounds.origin.y+self.bounds.size.height-kWindowResizeGutterSize, self.bounds.size.width-(kWindowResizeGutterSize*2), kWindowResizeGutterSize);
			
			CGRect topResizeRect = CGRectMake(self.bounds.origin.x+kWindowResizeGutterSize, self.bounds.origin.y, self.bounds.size.width-(kWindowResizeGutterSize*2), kWindowResizeGutterSize);
			
			
			[[UIColor colorWithWhite:0.0 alpha:0.3] setFill];
			
			if (resizeAxis == WMResizeRight)
			{
				[[UIBezierPath bezierPathWithRoundedRect:rightResizeRect cornerRadius:3.0] fill];
			}
			
			if (resizeAxis == WMResizeLeft)
			{
				[[UIBezierPath bezierPathWithRoundedRect:leftResizeRect cornerRadius:3.0] fill];
			}
			
			if (resizeAxis == WMResizeBottom)
			{
				[[UIBezierPath bezierPathWithRoundedRect:bottomResizeRect cornerRadius:3.0] fill];
			}
			
			if (resizeAxis == WMResizeTop)
			{
				[[UIBezierPath bezierPathWithRoundedRect:topResizeRect cornerRadius:3.0] fill];
			}
		}
		
		[[UIColor colorWithWhite:1 alpha:0.3] setFill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMidX(self.bounds)-kWindowResizeGutterKnobSize/2, CGRectGetMinY(self.bounds), kWindowResizeGutterKnobSize, kWindowResizeGutterKnobWidth) cornerRadius:2] fill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMidX(self.bounds)-kWindowResizeGutterKnobSize/2, CGRectGetMaxY(self.bounds)-kWindowResizeGutterKnobWidth-(kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, kWindowResizeGutterKnobSize, kWindowResizeGutterKnobWidth) cornerRadius:2] fill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, CGRectGetMidY(self.bounds)-kWindowResizeGutterKnobSize/2, kWindowResizeGutterKnobWidth, kWindowResizeGutterKnobSize) cornerRadius:2] fill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMaxX(self.bounds)-kWindowResizeGutterKnobWidth-(kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, CGRectGetMidY(self.bounds)-kWindowResizeGutterKnobSize/2, kWindowResizeGutterKnobWidth, kWindowResizeGutterKnobSize) cornerRadius:2] fill];
		
		
	}
}



@end
