//
//  FitmooHelper.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FitmooHelper : NSObject{
    
}
+ (FitmooHelper*) sharedInstance;
- (CGRect) resizeFrameWithFrame:(UIView *) view  respectToSuperFrame: (UIView *) superView;

@end