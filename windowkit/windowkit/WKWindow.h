//
//  WMWindow.h
//  WindowManager
//
//  Created by Steven Troughton-Smith on 23/12/2015.
//  Copyright © 2015 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleBarHeight 0.0
#define kMoveGrabHeight 44.0

#define kWindowButtonFrameSize 44.0
#define kWindowButtonSize 24.0
#define kWindowResizeGutterSize 8.0
#define kWindowResizeGutterTargetSize 24.0
#define kWindowResizeGutterKnobSize 48.0
#define kWindowResizeGutterKnobWidth 4.0

typedef enum : NSUInteger {
	WKWindowClosable		= 1<<0,
	WKWindowMiniaturizable	= 1<<1,
	WKWindowResizable		= 1<<2,
	WKWindowNonActivating	= 1<<3
} WKWindowMask;

typedef enum : NSUInteger {
	WKWindowSnapNone = 0,
	WKWindowSnapLeft,
	WKWindowSnapRight,
	WKWindowSnapFullscreen,
	WKWindowSnapTopLeft,
	WKWindowSnapBottomLeft,
	WKWindowSnapTopRight,
	WKWindowSnapBottomRight
} WKWindowSnap;

@class WKWindowFrameView, WKWindowManager;

@interface WKWindow : UIViewController
{
	CGRect _savedFrame;
	CGRect _savedPreSnapFrame;
	CGRect _frame;
	WKWindowFrameView *_frameView;
	UIView *_snapTargetView;
}

@property (weak) WKWindowManager *windowManager;
@property (nonatomic) UIViewController *rootViewController;

@property BOOL snapped;
@property BOOL maximized;
@property BOOL minimized;
@property BOOL hidden;
@property BOOL isKeyWindow;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGSize minimumSize;
@property NSUInteger windowLevel;
@property WKWindowMask windowMask;
@property NSUInteger index;
@property WKWindowSnap snapState;

- (instancetype)initWithWindowManager:(WKWindowManager *)manager mask:(WKWindowMask)mask;

-(void)minimize:(id)sender;
-(void)maximize:(id)sender;
-(void)makeKeyAndVisible;
-(void)close:(id)sender;
- (void)becomeKeyWindow;
- (void)resignKeyWindow;

-(void)snap:(WKWindowSnap)snap;
-(void)unsnap:(id)sender;
-(void)showTargetForSnap:(WKWindowSnap)snap;
-(void)update;

@end
