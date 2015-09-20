//
//  ShopRedemCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Redeem.h"
@interface ShopRedemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;


@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *depositedLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *feeLabel;

@property (strong, nonatomic) Redeem *redeem;

- (void) buildCell;
@end
