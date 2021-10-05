//
//  WKWindowFrameView.h
//  WindowKit
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
	WMResizeLeft,
	WMResizeRight,
	WMResizeTop,
	WMResizeBottom
} WMResizeAxis;

@class WKWindow;

@interface WKWindowFrameView : UIView <UIGestureRecognizerDelegate>
{
	BOOL _inWindowMove;
	BOOL _inWindowResize;
	CGPoint _originPoint;
	WMResizeAxis resizeAxis;
	CGRect _originalBounds;
	UIImage *_thumbnail;
}

-(void)_adjustMask;
-(void)_adjustContentForMinimization;
-(void)updateWindowButtons;
-(void)setFrameFrame:(CGRect)frame;

- (instancetype)initWithContainingWindow:(WKWindow *)window;

@property (weak) WKWindow *containingWindow;
@property NSMutableArray <UIButton *>*windowButtons;

@end
