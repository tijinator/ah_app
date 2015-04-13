//
//  LeftViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "User.h"
#import "UserManager.h"
#import "AsyncImageView.h"

@interface LeftViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic)  NSArray * imageArray;
@property (strong, nonatomic)  NSArray * textArray;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;

@end
