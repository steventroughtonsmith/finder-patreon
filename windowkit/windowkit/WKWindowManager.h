//
//  WKWindowManager.h
//  WindowKit
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuBarHeight 0.0
#define kStatusBarHeight 20.0
#define WKDesktopViewTag 'WKDT'

@class WKWindow, WKMenuBar;

@interface WKWindowManager : UIViewController
{
	WKMenuBar *menuBar;
}

-(void)addWindow:(WKWindow *_Nonnull)window;

-(void)updateWindowIndices;

@property (nullable) NSMutableArray <WKWindow *>*windows;
@property (nullable) UIColor *backgroundColor;
@property (nullable) UIColor *defaultBackgroundColor;
@property BOOL allowsFreeformWindowing;

-(CGRect)bounds;
-(CGPoint)nextWindowOrigin;

@end
