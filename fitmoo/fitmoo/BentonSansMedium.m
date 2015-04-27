//
//  BentonSansMedium.m
//  fitmoo
//
//  Created by hongjian lin on 4/27/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansMedium.h"

@implementation BentonSansMedium

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


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
   
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:self.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    [self setAttributedText:attributedString];
    [super drawRect:rect];
    
}

@end
