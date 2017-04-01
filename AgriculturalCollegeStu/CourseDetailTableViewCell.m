//
//  CourseDetailTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/4.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "CourseDetailTableViewCell.h"

@implementation CourseDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 7)];
        imageViewTop.backgroundColor = RGB_COLOR(239, 239, 239);
        [self.contentView addSubview:imageViewTop];
        
        static const CGFloat myHeight = 100;
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, imageViewTop.frame.origin.y +imageViewTop.frame.size.height +5, myHeight, myHeight)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x +_iconImageView.frame.size.width +5, _iconImageView.frame.origin.y, WIDTH -_iconImageView.frame.origin.x -_iconImageView.frame.size.width -15, 20)];
        _title.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_title];
        
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, _title.frame.origin.y +_title.frame.size.height -3, _title.frame.size.width, _iconImageView.frame.size.height -_title.frame.origin.y -_title.frame.size.height )];
        _detail.numberOfLines = 0;
        _detail.textColor = LIGHTGRAY_COLOR;
        _detail.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_detail];
        
        _periodLabel = [[UILabel alloc]initWithFrame:CGRectMake(_detail.frame.origin.x, _detail.frame.origin.y +_detail.frame.size.height -3, _detail.frame.size.width, 21)];
        _periodLabel.font = _detail.font;
        _periodLabel.textColor = LIGHTGRAY_COLOR;
        _periodLabel.textColor = _detail.textColor;
        [self.contentView addSubview:_periodLabel];
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
