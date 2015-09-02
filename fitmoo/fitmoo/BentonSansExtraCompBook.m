//
//  BentonSansExtraCompBook.m
//  fitmoo
//
//  Created by hongjian lin on 9/2/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansExtraCompBook.h"

@implementation BentonSansExtraCompBook

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    UIFont *font = [UIFont fontWithName:@"BentonSans-ExtraCondensedBook" size:self.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    
    if (self.tag==1000) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:8];
        style.alignment=NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, self.text.length)];
    }
    
    
    
    
    [self setAttributedText:attributedString];
    [super drawRect:rect];
    
}

@end
