//
//  ShopPurchaseCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrder.h"
#import "RTLabel.h"
@interface ShopPurchaseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *ImageButton;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;

@property (strong, nonatomic) IBOutlet UIView *seprelatorView;


@property (strong, nonatomic)  ShopOrder *order;
- (void) buildCell;
@end
