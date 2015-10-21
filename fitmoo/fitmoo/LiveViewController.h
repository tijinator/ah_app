//
//  LiveViewController.h
//  fitmoo
//
//  Created by hongjian lin on 10/11/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import <Foundation/Foundation.h>
#import "User.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ComposeViewController.h"
#import "LiveCell.h"
#import "LiveFeed.h"
#import "RTLabel.h"
@interface LiveViewController : UIViewController<RTLabelDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSDictionary * commentNoteDic;

@property (strong, nonatomic)  LiveFeed * liveFeed;

@property (strong, nonatomic) IBOutlet UIButton *advertiseButton;
- (IBAction)adverButonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@property (strong, nonatomic) AsyncImageView *bannerImageView;

@property (strong, nonatomic) UIView *textViewBackgroundView;

- (IBAction)postButtonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *heanderImage1;
@property (strong, nonatomic) IBOutlet UIButton *headerImage2;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

@end
