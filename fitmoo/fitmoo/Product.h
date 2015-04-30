//
//  Product.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *type_product;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;  //not using
@property (nonatomic, strong) NSString *gender;  //not using

@property (nonatomic, strong) NSString *original_price;
@property (nonatomic, strong) NSString *selling_price;
@property (nonatomic, strong) NSString *brand;   //not using
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *videos;

@end
