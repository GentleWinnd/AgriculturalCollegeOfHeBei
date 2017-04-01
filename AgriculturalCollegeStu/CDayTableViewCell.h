//
//  CDayTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/20.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDayTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *firstTime;
@property (strong, nonatomic) IBOutlet UILabel *secondTime;
@property (strong, nonatomic) IBOutlet UILabel *DTime;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *VLIne;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstTimePsace;
@property (strong, nonatomic) IBOutlet UILabel *thridTime;

@end
