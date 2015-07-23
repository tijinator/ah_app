//
//  WorkTypeViewController.h
//  fitmoo
//
//  Created by hongjian lin on 7/23/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"

#import "UserManager.h"
@interface WorkTypeViewController : UIViewController<UITextFieldDelegate>
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITextField * searchTermField;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *totalTypeArray;
@property (strong, nonatomic) NSMutableArray *searchTypeArray;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *searchTypeName;
@property (strong, nonatomic) IBOutlet UILabel *workoutTypeLabel;
@end
