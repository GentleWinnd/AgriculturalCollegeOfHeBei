//
//  TestResultTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *quenstionName;
@property (strong, nonatomic) IBOutlet UILabel *proporteLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end
