//
//  HistoryTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/6.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80 /160.f *220.f, 80)];
        [self.contentView addSubview:_iconImageView];
        
        UIImageView *iconBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_iconImageView.frame.size.width /2.f -15, _iconImageView.frame.size.height /2.f -15, 30, 30)];
        iconBgImageView.image = [UIImage imageNamed:@"play_icon"];
        [_iconImageView addSubview:iconBgImageView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x +_iconImageView.frame.size.width +10, _iconImageView.frame.origin.y, WIDTH -_iconImageView.frame.origin.x -_iconImageView.frame.size.width -10, 20)];
        _detailLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_detailLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_detailLabel.frame.origin.x, _iconImageView.frame.origin.y +_iconImageView.frame.size.height -25, _detailLabel.frame.size.width, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = LIGHTGRAY_COLOR;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
