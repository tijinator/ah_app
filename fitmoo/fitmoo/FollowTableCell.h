//
//  FollowTableCell.h
//  fitmoo
//
//  Created by hongjian lin on 6/18/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BentonSansBold.h"
#import "AsyncImageView.h"
#import "UserManager.h"
#import "User.h"

@interface FollowTableCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet BentonSansBold *titleLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong, nonatomic) NSArray * totalArray;

@property (weak, nonatomic) IBOutlet UIView *bodyView;

@property (weak, nonatomic) UIButton *tempButton1;
@property (weak, nonatomic) User *tempUser1;
@end
