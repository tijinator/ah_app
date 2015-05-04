//
//  CommentViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "FitmooHelper.h"
#import "UserManager.h"
#import "AsyncImageView.h"
@interface CommentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
- (IBAction)postButtonClick:(id)sender;

@property (strong, nonatomic)  HomeFeed * homeFeed;
@end
