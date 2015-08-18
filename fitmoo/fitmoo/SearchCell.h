//
//  SearchCell.h
//  fitmoo
//
//  Created by hongjian lin on 8/18/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Workout.h"
#import "Product.h"
@interface SearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *imageview;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) User *temUser;
@property (strong, nonatomic) Workout *temWk;
@property (strong, nonatomic) Product *temPd;
- (void) builtSearchCell;
- (void) builtWkSearchCell;
- (void) builtPdSearchCell;
@end
