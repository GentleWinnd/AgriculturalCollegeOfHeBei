//
//  OpinionCommitTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/10/19.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionCommitTableViewCell : UITableViewCell

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
- (IBAction)onCommitBtnClick:(UIButton *)sender;

@end
