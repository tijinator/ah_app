//
//  InviteViewController.h
//  fitmoo
//
//  Created by hongjian lin on 6/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UITextView+Placeholder.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface InviteViewController : UIViewController<MFMessageComposeViewControllerDelegate>
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UIView *topview;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UITextView *emailTextView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSArray * contacts;

@property (strong, nonatomic)  NSMutableArray * contactsPymic;
@end
