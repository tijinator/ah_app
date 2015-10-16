//
//  ShopCartDetail.h
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartDetail : NSObject

@property (nonatomic, strong) NSString *cart_shipping;
@property (nonatomic, strong) NSString *cart_subtotal;
@property (nonatomic, strong) NSString *cart_total;
@property (nonatomic, strong) NSString *customer_service_email;
@property (nonatomic, strong) NSString *customer_service_no;
@property (nonatomic, strong) NSString *endorser;
@property (nonatomic, strong) NSString *endorser_name;
@property (nonatomic, strong) NSString *endorser_profile_photo_url;

@property (nonatomic, strong) NSString *shop_cart_detail_id;
@property (nonatomic, strong) NSString *item_count;
@property (nonatomic, strong) NSString *item_details;
@property (nonatomic, strong) NSString *item_photo_url;
@property (nonatomic, strong) NSString *item_price;
@property (nonatomic, strong) NSString *item_url;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *refund_policy;

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *seller_profile_photo_url;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *count_on_hand;
@property (nonatomic, strong) NSString *feed_id;

@property (nonatomic, strong) NSString *is_event;



@end
