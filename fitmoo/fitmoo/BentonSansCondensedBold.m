//
//  BentonSansCondensedBold.m
//  fitmoo
//
//  Created by hongjian lin on 5/22/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansCondensedBold.h"

@implementation BentonSansCondensedBold

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    //        for(NSString* family in [UIFont familyNames]) {
    //            NSLog(@"%@", family);
    //            for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
    //                NSLog(@"  %@", name);
    //            }
    //        }
    UIFont *font = [UIFont fontWithName:@"BentonSans-CondensedBold" size:self.font.pointSize];
    
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    [self setAttributedText:attributedString];
    [super drawRect:rect];
    
}

@end
