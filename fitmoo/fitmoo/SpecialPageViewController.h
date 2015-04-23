//
//  SpecialPageViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "HomeFeed.h"
#import "PeoplePageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SpecialPageViewController : UIViewController <UITableViewDataSource , UITableViewDelegate , UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  HomeFeed * homeFeed;
@property (strong, nonatomic)  NSString * postText;
@property (strong, nonatomic)  UITextView * textView;
@property (strong, nonatomic)  NSString * action;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;

@end
