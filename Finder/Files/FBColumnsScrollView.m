//
//  FBColumnsScrollView.m
//  Files
//
//  Created by Steven Troughton-Smith on 27/02/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FBColumnsScrollView.h"

@implementation FBColumnsScrollView


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
	return [otherGestureRecognizer.view.superview isKindOfClass:[UITableView class]];
}

@end
