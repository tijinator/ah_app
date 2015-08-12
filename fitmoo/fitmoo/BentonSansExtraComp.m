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

- (void) addCircle
{
    int radius = self.frame.size.width/2;
    int strokeWidth = 8;
    CGColorRef color = [UIColor whiteColor].CGColor;
 
    
    CGFloat startAngle = (-1*M_PI/2);
    CGFloat endAngle =(3.00001*M_PI/2);
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                 radius:radius
                                             startAngle:startAngle
                                               endAngle:endAngle
                                              clockwise:NO].CGPath;
    
    circle.position = CGPointMake(0, -2);
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = color;
    circle.lineWidth = strokeWidth;
    [self.layer addSublayer:circle];
    
}

- (void)drawRect:(CGRect)rect
{
   if(self.text!=nil && ![self.text isEqualToString:@""])
   {
    UIFont *font = [UIFont fontWithName:@"BentonSans-ExtraCondensedBold" size:self.font.pointSize];
    
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}  ];
    
    [self setAttributedText:attributedString];
    
   }
    
    [super drawRect:rect];
    
    if (self.tag==1003) {
        [self addCircle];
        if (![self.text isEqualToString:@"0"] ) {
        
        int radius = self.frame.size.width/2;
        int strokeWidth = 8;
        CGColorRef color = [UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0].CGColor;
        int timeInSeconds = 5;
        
      
            
        CGFloat startAngle = (-1*M_PI/2);
        CGFloat endAngle =((4.1+0.0001)*M_PI/2);
            
            
        double percentage= self.text.doubleValue/100;
            
        if (percentage<=0.5) {
         endAngle = ((3.0+0.0001-(4*percentage))*M_PI/2);
        }else
        {
         endAngle = ((5.0+0.0001-(4*(percentage-0.5)))*M_PI/2);
        }

        CAShapeLayer *circle = [CAShapeLayer layer];
        circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                     radius:radius
                                                 startAngle:startAngle
                                                   endAngle:endAngle
                                                  clockwise:NO].CGPath;

        circle.position = CGPointMake(0, -2);
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = color;
        circle.lineWidth = strokeWidth;
        [self.layer addSublayer:circle];
        
        
      
            // Change the model layer's property first.
            circle.strokeEnd = endAngle;
            
            // Then apply the animation.
            CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            drawAnimation.duration            = timeInSeconds;
            drawAnimation.fromValue = [NSNumber numberWithFloat:startAngle];
            drawAnimation.toValue   = [NSNumber numberWithFloat:endAngle];
            
            drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        }
      

    }
    
    
}

@end
