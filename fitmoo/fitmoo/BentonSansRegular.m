//
//  BentonSansRegular.m
//  fitmoo
//
//  Created by hongjian lin on 4/27/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BentonSansRegular.h"

@implementation BentonSansRegular

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

-(CGSize)sizeOfMultiLineLabel{
    
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = [self text];
    
    //Label font
    UIFont *aLabelFont = [self font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = self.frame.size.width;
    
    
 
  
    
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;
        
    
    
    return [self bounds].size;
    
}


- (void)drawRect:(CGRect)rect
{
    if (self.text!=nil&&![self.text isEqualToString:@""]) {
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:self.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    if (self.tag==1000) {
        style.alignment=NSTextAlignmentCenter;
    }
    
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.text.length)];
    
    
    
    [self setAttributedText:attributedString];

    }
   //  self.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:self];
  //  self.frame= CGRectMake(self.frame.origin.x, 20, self.frame.size.width, 80);
    [super drawRect:rect];
  //   self.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:self];
  
}


@end
