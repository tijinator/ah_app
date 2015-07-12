//
//  BentonSansBold.m
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansBold.h"

@implementation BentonSansBold

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
    
//    for(NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@"  %@", name);
//        }
//    }
    @try {
        UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:self.font.pointSize];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
        if (self.tag==1000) {
            float spacing = 1.5f;
            [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [self.text length])];
        }else if (self.tag==1001)
        {
            float spacing = 1.0f;
            [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [self.text length])];
        }else if (self.tag==1002)
        {
            self.layer.cornerRadius=self.frame.size.width/2;
        }
        
        
        [self setAttributedText:attributedString];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
       
    }
       [super drawRect:rect];
    
}

@end
