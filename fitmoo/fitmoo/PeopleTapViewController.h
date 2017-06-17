//
//  PeopleTapViewController.h
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "SpecialPageViewController.h"
#import "ActionSheetViewController.h"
#import "PeoplePageViewController.h"
#import "CreatedByCommunity.h"
#import "FollowCollectionViewCell.h"
#import "SecondFollowViewController.h"
#import "FollowHeaderCell.h"
#import "InviteViewController.h"
#import "Workout.h"
#import "Product.h"
#import "SeachInterestCell.h"
#import "FollowPhotoCell.h"
#import "FollowLeaderBoardCell.h"
#import "SearchPhotoCell.h"
#import "SearchTapCell.h"
#import "SearchCell.h"

@interface PeopleTapViewController : BaseViewController <UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end
