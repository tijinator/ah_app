//
//  Product.m
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)init
{
    _variant_options=[[Options alloc] init];
    _variant_options_array=[[NSMutableArray alloc] init];
    
    _variants=[[Variants alloc] init];
    _variant_array=[[NSMutableArray alloc] init];
    
    _variant_matrix=[[Matrixs alloc] init];
    _variant_matrix_array=[[NSMutableArray alloc] init];
    
    return self;
}

-(void) resetOptions
{
    _variant_options= [[Options alloc] init];
  
}

-(void) resetVariants
{
    _variants= [[Variants alloc] init];
  
}

-(void) resetMatrixs
{
    _variant_matrix= [[Matrixs alloc] init];
    
}

@end
