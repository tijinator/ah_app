//
//  Address.h
//  fitmoo
//
//  Created by hongjian lin on 9/9/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * address_type_id;
@property (nonatomic, retain) NSString * city;

@property (nonatomic, retain) NSString * country_id;
@property (nonatomic, retain) NSString * country_name;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * address_id;

@property (nonatomic, retain) NSString * is_default_billing;
@property (nonatomic, retain) NSString * is_default_shipping;
@property (nonatomic, retain) NSString * order_total;
@property (nonatomic, retain) NSString * phone;

@property (nonatomic, retain) NSString * shipping_rate;
@property (nonatomic, retain) NSString * state_id;
@property (nonatomic, retain) NSString * state_name;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * zipcode;

@end
