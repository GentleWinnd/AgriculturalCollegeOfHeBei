//
//  CategoryTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/3.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        _myTitleLabel.textAlignment = NSTextAlignmentCenter;
        _myTitleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_myTitleLabel];
        UIView *bgView = [[UIView alloc]initWithFrame:_myTitleLabel.frame];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-38, 40, bgView.frame.size.width, 2)];
        imageView.image = [UIImage imageNamed:@"指示线"];
        [bgView addSubview:imageView];
        imageView.transform = CGAffineTransformMakeRotation( M_PI /2.f );
        self.selectedBackgroundView = bgView;
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
