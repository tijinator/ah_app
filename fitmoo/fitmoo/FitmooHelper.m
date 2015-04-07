//
//  FitmooHelper.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FitmooHelper.h"

@implementation FitmooHelper

+ (FitmooHelper*)sharedInstance
{
    static dispatch_once_t pred;
    static FitmooHelper *settings = nil;
    
    dispatch_once(&pred, ^{ settings = [[self alloc] init]; });
    return settings;
    
}

- (CGRect) resizeFrameWithFrame:(UIView *) view  respectToSuperFrame: (UIView *) superView
{
    double Radio= superView.frame.size.width / 320;
    
    view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    
    return view.frame;
}

- (id) init;{
    
    if ((self = [super init])) {
        
        
        
    }
    
    return self;
}


@end