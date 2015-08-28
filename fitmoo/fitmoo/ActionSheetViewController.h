//
//  ActionSheetViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UserManager.h"
#import "InviteViewController.h"

@interface ActionSheetViewController : UIViewController<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) NSString * action;
@property (strong, nonatomic) NSString * postType;
@property (strong, nonatomic) NSString * postId;
@property (strong, nonatomic) NSString * profileId;
@property (strong, nonatomic) NSString * communityId;
@property (strong, nonatomic) NSString * feedActionId;
@property (strong, nonatomic) NSString * ShareTitle;
@property (strong, nonatomic) NSString * ShareBody;
@property (assign, nonatomic) BOOL hideRepost;
@property (assign, nonatomic) BOOL hideInstegram;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareVideo;
- (IBAction)logoutButtonClick:(id)sender;
- (IBAction)settingButtonClick:(id)sender;

- (IBAction)endoseButtonClick:(id)sender;
- (IBAction)reportButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
- (IBAction) InviteButtonFunction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *endorseButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIView *shareButtomView;
@property (strong, nonatomic) IBOutlet UIButton *socialNetworkButton;

@property (strong, nonatomic) IBOutlet UIButton *cpLinkButton;

- (IBAction)copyLinkClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *shareCancelButton;
- (IBAction)shareClick:(id)sender;
- (IBAction)socialNewworkButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view0;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;

@property (strong, nonatomic)  NSString *shoplink;

- (IBAction)shopButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *InstagramButton;
- (IBAction)InstagramButtonClick:(id)sender;
- (IBAction)shareCancelClick:(id)sender;
@property(nonatomic,retain)UIDocumentInteractionController *docFile;

@property (strong, nonatomic) IBOutlet UIView *InviteView;
@property (strong, nonatomic) IBOutlet UIView *IVView1;
@property (strong, nonatomic) IBOutlet UIView *IVView2;
@property (strong, nonatomic) IBOutlet UIView *IVView3;
@property (strong, nonatomic) IBOutlet UIView *IVView4;
@property (strong, nonatomic) IBOutlet UIButton *InviteMyCTButton;
@property (strong, nonatomic) IBOutlet UIButton *CopyProfileLKButton;
@property (strong, nonatomic) IBOutlet UIButton *InviteCancelButton;
@property (strong, nonatomic) IBOutlet UIButton *ShareMyProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *InvitePostToInstagramButton;

@property (strong, nonatomic) IBOutlet UIView *menuBottomView;
@property (strong, nonatomic) IBOutlet UIView *menuView1;
@property (strong, nonatomic) IBOutlet UIView *menuView2;
@property (strong, nonatomic) IBOutlet UIView *menuView3;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *menuCancelButton;
@property (strong, nonatomic) IBOutlet UIButton *settingButton;



@end
