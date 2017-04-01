//
//  OpinionTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/10/19.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OpinionTableViewCellBlock)(UIButton *sender);

@interface OpinionTableViewCell : UITableViewCell
- (IBAction)selectBtn:(UIButton *)sender;

@property (nonatomic, copy) OpinionTableViewCellBlock btnClickBlock;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
