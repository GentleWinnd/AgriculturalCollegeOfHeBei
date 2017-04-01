//
//  SignInfoTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *signedState;
@property (strong, nonatomic) IBOutlet UILabel *stuCome;
@property (strong, nonatomic) IBOutlet UIProgressView *stuComePro;
@property (strong, nonatomic) IBOutlet UILabel *stuSigned;
@property (strong, nonatomic) IBOutlet UIProgressView *stuSignedPro;

@property (strong, nonatomic) IBOutlet UILabel *leavedCount;




@end
