//
//  ShopDetailViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/1/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import <Foundation/Foundation.h>
#import "User.h"
#import "ShareTableViewCell.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "HomeFeed.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VimeoHelper.h"
#import "YTVimeoExtractor.h"
#import "ComposeViewController.h"
#import "ShopTableViewCell.h"
#import "Variants.h"
#import "Matrixs.h"
#import "ShopCartViewController.h"
@interface ShopDetailViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;


@property (strong, nonatomic)  HomeFeed * homeFeed;
@property (strong, nonatomic)  NSString * postText;
@property (strong, nonatomic)  NSString * searchId;
@property (strong, nonatomic)  UITextView * textView;
@property (strong, nonatomic)  NSString * action;

@property (strong, nonatomic)  UIButton * variantButton1;
@property (strong, nonatomic)  UIButton * variantButton2;
@property (strong, nonatomic)  UIButton * variantButton3;
@property (strong, nonatomic)  UIButton * variantButton4;
@property (strong, nonatomic)  UIButton * SelectedVariantButton;


@property (strong, nonatomic)  NSMutableArray * pickerDisplayArray;

@property (strong, nonatomic)  NSString * searchCommunityId;
@property (strong, nonatomic)  Variants * selectedVariants;
@property (strong, nonatomic)  Matrixs * selectedMatrixs;

@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIView *typePickerView;

@end
