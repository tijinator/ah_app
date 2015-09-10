//
//  UITableView+reloadData.m
//  Interactive_PI
//
//  Created by hean on 7/16/13.
//  Copyright (c) 2013 instrux. All rights reserved.
//

#import "UITableView+reloadData.h"

@implementation UITableView (reloadData)

- (void)reloadData :(BOOL)animated{
    // NSLog(@"load slowly");
    [self reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFromTop];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:0.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}


@end
