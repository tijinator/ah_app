//
//  InfluenceCell.h
//  fitmoo
//
//  Created by hongjian lin on 8/13/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfluenceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bodyLabel1;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel2;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel3;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel4;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel5;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel6;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel7;

@property (strong, nonatomic) IBOutlet UILabel *bodyButton1;
@property (strong, nonatomic) IBOutlet UILabel *bodyButton2;
@property (strong, nonatomic) IBOutlet UILabel *bodyButton3;
@property (strong, nonatomic) IBOutlet UILabel *bodyButton4;
@property (strong, nonatomic) NSString *influence_factor;
@end
