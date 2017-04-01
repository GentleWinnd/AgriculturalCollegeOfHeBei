//
//  ClassRecordHeaderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRecordHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *sigendLabel;
@property (strong, nonatomic) IBOutlet UILabel *signedCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *leavedLabel;
@property (strong, nonatomic) IBOutlet UILabel *leavedCOuntLabel;
@property (assign, nonatomic) UserRole userRole;

@end
