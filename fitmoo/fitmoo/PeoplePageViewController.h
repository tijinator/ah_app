//
//  PeoplePageViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"

#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
//#import "SpecialPageViewController.h"
#import "PeopleTitleCell.h"
#import "ActionSheetViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VimeoHelper.h"
#import "YTVimeoExtractor.h"
#import "CommentViewController.h"
#import "PhotoGalary.h"
#import "BioViewController.h"
#import "PhotoCell.h"
#import "ComposeViewController.h"
#import "CalendarCell.h"
@interface PeoplePageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonClick:(id)sender;

@property (strong, nonatomic)  NSString * searchId;
@property (strong, nonatomic)  NSString * feedType;
@property (strong, nonatomic)  NSString * CalendarModalType;
@property (strong, nonatomic)  NSDate * CalendarselectedDate;

@property (strong, nonatomic)  User * temSearchUser;
@property (strong, nonatomic)  NSMutableArray * heighArray;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSDictionary * responseDicWorkout;
@property (strong, nonatomic)  NSDictionary * responseDicStore;
@property (strong, nonatomic)  NSDictionary * responseDicCalendar;
@property (strong, nonatomic)  NSMutableArray * homeFeedArray;

@property (strong, nonatomic)  NSMutableArray * FeedArray;
@property (strong, nonatomic)  NSMutableArray * WorkoutFeedArray;
@property (strong, nonatomic)  NSMutableArray * StoreFeedArray;

@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *workoutButton;
@property (strong, nonatomic) IBOutlet UIButton *storeButton;

@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;
@property (assign, nonatomic)  int count;

@property (assign, nonatomic)  int FeedOffset;
@property (assign, nonatomic)  int WorkoutOffset;
@property (assign, nonatomic)  int StoreOffset;

@property (assign, nonatomic)  int photoLimit;
@property (assign, nonatomic)  int photoOffset;
@property (assign, nonatomic)  int photoCount;

@property (strong, nonatomic)  NSString * tableType;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerViewController *playerView;

@end
