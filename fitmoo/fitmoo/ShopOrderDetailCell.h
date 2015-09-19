//
//  ShopOrderDetailCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/18/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrder.h"
#import "RTLabel.h"
@interface ShopOrderDetailCell : UITableViewCell
@property (strong, nonatomic)  ShopOrder *order;
- (void) buildCell;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeOnLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *fulfillStatusLabel;

@property (strong, nonatomic) IBOutlet UILabel *upsLabel;
@property (strong, nonatomic) IBOutlet UILabel *billAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPaidLabel;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;
@property (strong, nonatomic) IBOutlet UILabel *label8;
@property (strong, nonatomic) IBOutlet UILabel *label9;
@property (strong, nonatomic) IBOutlet UILabel *label10;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;

@property (strong, nonatomic) RTLabel *rtLabel;
@property (strong, nonatomic) RTLabel *rtLabel1;

@end
