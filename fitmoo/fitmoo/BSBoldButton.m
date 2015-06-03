//
//  BSBoldButton.m
//  fitmoo
//
//  Created by hongjian lin on 6/3/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BSBoldButton.h"

@implementation BSBoldButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (BSBoldButton*) underlinedButton {
    BSBoldButton* button = [[BSBoldButton alloc] init];
    return button ;
}

- (void) drawRect:(CGRect)rect {
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:self.titleLabel.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName: font}  ];
    if (self.tag==1000||self.tag==1||self.tag==2||self.tag==3) {
        float spacing = 1.5f;
        [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [self.titleLabel.text length])];
        
    }
    
    
    [self.titleLabel setAttributedText:attributedString];
    [self.titleLabel sizeToFit];
    [super drawRect:rect];
}


@end
