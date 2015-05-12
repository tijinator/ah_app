//
//  BentonSansExtraComp.m
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansExtraComp.h"

@implementation BentonSansExtraComp

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib;
{
    [super awakeFromNib];
    
    
}

- (void)drawRect:(CGRect)rect
{
//    for(NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@"  %@", name);
//        }
//    }
    UIFont *font = [UIFont fontWithName:@"BentonSans-ExtraCondensedBold" size:self.font.pointSize];
    
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    [self setAttributedText:attributedString];
    [super drawRect:rect];
    
}

@end
