//
//  ShopEarningCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Earning.h"
@interface ShopEarningCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;

@property (strong, nonatomic) IBOutlet UILabel *redeemLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleLabel;
@property (strong, nonatomic) IBOutlet UILabel *endorsLabel;

@property (strong, nonatomic) IBOutlet UILabel *pendingSaleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pendingEndorseLabel;
@property (strong, nonatomic) IBOutlet UILabel *previouslyReddeemLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalEarningLabel;

@property (strong, nonatomic) Earning *earning;
- (void) buildCell;
@end
