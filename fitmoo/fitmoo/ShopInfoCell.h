//
//  ShopInfoCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCart.h"
#import "ShopCartDetail.h"
#import "AsyncImageView.h"
@interface ShopInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *ItemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel1;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel2;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel3;
@property (strong, nonatomic) IBOutlet UIButton *infoButton1;
@property (strong, nonatomic) IBOutlet UIButton *infoButtons2;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;

@property (strong, nonatomic) ShopCart *shopCart;
@property (strong, nonatomic) ShopCartDetail *shopCartDetail;

- (void) buildCell;
@end
