//
//  WKMenuBar.m
//  WindowKit
//
//  Created by Steven Troughton-Smith on 20/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "WKMenuBar.h"
#import "WKWindowManager.h"

@implementation WKMenuBar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
	}
	return self;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	

	
	NSDictionary *attribs = @{NSFontAttributeName : [UIFont systemFontOfSize:24]};
	
	CGFloat xoffset = 30;
	
	[@"File" drawAtPoint:CGPointMake(xoffset+8, kStatusBarHeight+8) withAttributes:attribs];
	[@"Edit" drawAtPoint:CGPointMake(xoffset+80,  kStatusBarHeight+8) withAttributes:attribs];
	[@"Window" drawAtPoint:CGPointMake(xoffset+150,  kStatusBarHeight+8) withAttributes:attribs];

	[[UIColor colorWithWhite:0 alpha:0.3] set];
	UIRectFillUsingBlendMode(CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5), kCGBlendModeNormal);
}


@end
