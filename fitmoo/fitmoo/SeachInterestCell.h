//
//  SeachInterestCell.h
//  fitmoo
//
//  Created by hongjian lin on 8/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "CreatedByCommunity.h"
@interface SeachInterestCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic)  IBOutlet UIScrollView *scrollView;
- (void) addScrollView;
@property (strong, nonatomic)  NSString * selectedKeywordId;
@property (strong, nonatomic)  NSMutableArray * searchArrayKeyword;
@property (strong, nonatomic)  NSMutableArray * colorArray;
@property (assign, nonatomic)  int * selectedIndex;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)  NSString * searchType;
@end
