//
//  Product.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Options.h"
#import "Variants.h"
#import "Matrixs.h"
@interface Product : NSObject

@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *type_product;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *gender;



@property (nonatomic, strong) NSString *original_price;
@property (nonatomic, strong) NSString *selling_price;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *videos;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *allowed_for_sale;

@property (nonatomic, strong) NSString *shipping_buyer_amount;
@property (nonatomic, strong) NSString *shipping_full_amount;
@property (nonatomic, strong) NSString *shipping_type_id;
@property (nonatomic, strong) NSString *sold_out;

@property (nonatomic, strong) NSMutableArray *variant_matrix_array;
@property (nonatomic, strong) Matrixs *variant_matrix;
@property (nonatomic, strong) Options *variant_options;
@property (nonatomic, strong) NSMutableArray *variant_options_array;
@property (nonatomic, strong) Variants *variants;
@property (nonatomic, strong) NSMutableArray *variant_array;

-(void) resetOptions;
-(void) resetVariants;
-(void) resetMatrixs;
@end
