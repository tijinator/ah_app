//
//  ShopCart.h
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartDetail.h"
@interface ShopCart : NSObject

@property (nonatomic, strong) NSString *buyer_email;
@property (nonatomic, strong) NSString *shopcart_id;
@property (nonatomic, strong) NSString *item_count;
@property (nonatomic, strong) NSString *shipping;
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *tax;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *verify_for_checkout;

@property (nonatomic, strong) ShopCartDetail *shop_cart_detail;
@property (nonatomic, strong) NSMutableArray *shop_cart_details;

-(void) resetshopCartDetail;

@end
