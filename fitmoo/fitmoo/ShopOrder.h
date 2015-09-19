//
//  ShopOrder.h
//  fitmoo
//
//  Created by hongjian lin on 9/19/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface ShopOrder : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *endorser_name;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *placed_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *payment_status;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *o_id;
@property (nonatomic, strong) NSString *tracking_number;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *order_shipping_total;
@property (nonatomic, strong) NSString *options;


@property (nonatomic, strong) Address *shippingAddress;
@property (nonatomic, strong) Address *billingAddress;

@end
