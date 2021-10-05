//
//  FBFilesIconCell.m
//  Files
//
//  Created by Steven Troughton-Smith on 26/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FBFilesIconCell.h"

@implementation FBFilesIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)drawRect:(CGRect)rect
{
	
	if (self.highlighted)
	{
	
		[[UIColor colorWithWhite:0.878 alpha:1.000] setFill];
		[[UIColor blueColor] setStroke];

		UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.width-4) cornerRadius:16];
		
		[path fill];
//		[path stroke];
		
		
		
	}
	
}

@end
