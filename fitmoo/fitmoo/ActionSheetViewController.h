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

@interface ActionSheetViewController : UIViewController<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) NSString * action;
@property (strong, nonatomic) NSString * postType;
@property (strong, nonatomic) NSString * postId;
@property (strong, nonatomic) NSString * profileId;
@property (strong, nonatomic) NSString * communityId;
@property (strong, nonatomic) NSString * feedActionId;
@property (strong, nonatomic) NSString * ShareTitle;
@property (strong, nonatomic) NSString * ShareBody;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareVideo;
-(void) performAnimation: (UIView *)view;
- (IBAction)endoseButtonClick:(id)sender;
- (IBAction)reportButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *endorseButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIView *shareButtomView;
@property (strong, nonatomic) IBOutlet UIButton *socialNetworkButton;

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
@property (strong, nonatomic) IBOutlet UIButton *shopButton;

@property (strong, nonatomic)  NSString *shoplink;

- (IBAction)shopButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *InstagramButton;
- (IBAction)InstagramButtonClick:(id)sender;
- (IBAction)shareCancelClick:(id)sender;
@property(nonatomic,retain)UIDocumentInteractionController *docFile;
@end
