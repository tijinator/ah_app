//
//  ShopEventOrderCell.h
//  fitmoo
//
//  Created by hongjian lin on 10/12/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "ShopOrder.h"
@interface ShopEventOrderCell : UITableViewCell
- (void) buildCell;
@property (strong, nonatomic)  ShopOrder *order;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *billAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellerLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPaidLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;


@property (strong, nonatomic) RTLabel *rtLabel;
@property (strong, nonatomic) RTLabel *rtLabel1;

@property (strong, nonatomic) IBOutlet UIImageView *barCodeImage;

@end
