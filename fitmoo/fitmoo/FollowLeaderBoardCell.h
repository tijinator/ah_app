//
//  FollowLeaderBoardCell.h
//  fitmoo
//
//  Created by hongjian lin on 8/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface FollowLeaderBoardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CountLabel;
@property (strong, nonatomic) IBOutlet UIButton *headerButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workoutPostCount;
@property (strong, nonatomic) IBOutlet UILabel *workoutWeekCount;
@property (strong, nonatomic) IBOutlet UILabel *workoutWeekLabel;
@property (strong, nonatomic) IBOutlet UILabel *workoutPostLabel;
@property (strong, nonatomic) IBOutlet UIView *seprelaterView;
@property (strong, nonatomic) User * tempUser;
- (void) buildCell;
@end
