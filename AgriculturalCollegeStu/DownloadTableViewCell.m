//
//  DownloadTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/7.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "HOMEHeader.h"
#import "HOMEBaseViewController.h"

@implementation DownloadTableViewCell
{
    UIProgressView *_progressView;
    UIButton *_pauseBtn;
    NSInteger _flag;
    UILabel *_progressLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80 /160.f *220.f, 80)];
        [self.contentView addSubview:_iconImageView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x +_iconImageView.frame.size.width +10, _iconImageView.frame.origin.y , WIDTH -_iconImageView.frame.origin.x -_iconImageView.frame.size.width -15, 20)];
        _detailLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_detailLabel];
        


        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseBtn.frame = CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y +_detailLabel.frame.size.height +15, 30, 30);
//        [_pauseBtn setTitle:@"开始" forState:UIControlStateNormal];
//        [_pauseBtn setTitle:@"暂停" forState:UIControlStateSelected];
        [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"offline_pause"] forState:UIControlStateNormal];
        [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"offline_downing"] forState:UIControlStateSelected];
        [_pauseBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_pauseBtn setTitleColor:BLACK_COLOR forState:UIControlStateSelected];
//        _pauseBtn.layer.borderColor = LIGHTGRAY_COLOR.CGColor;
//        _pauseBtn.layer.borderWidth = 0.5f;
//        _pauseBtn.layer.cornerRadius = 5.f;
//        _pauseBtn.layer.masksToBounds = YES;
        [_pauseBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_pauseBtn];
        
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(_pauseBtn.frame.origin.x +_pauseBtn.frame.size.width +10,  10, WIDTH -_pauseBtn.frame.origin.x -_pauseBtn.frame.size.width -70, 10)];
        [self.contentView addSubview:_progressView];
        _progressView.center = CGPointMake(_progressView.center.x, _pauseBtn.center.y);
        
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH -100, _pauseBtn.frame.origin.y, 90, _pauseBtn.frame.size.height)];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_progressLabel];
    }
    return self;
}

-(void)onBtnClick:(UIButton *)sender
{
    if (!sender.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStart" object:_videoInfo];
    } else {
        NSLog(@"%@", [NSString stringWithFormat:@"%@x", _videoInfo[@"aFileName"]]);
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@x", _videoInfo[@"Id"]] object:_videoInfo];
    }
    sender.selected = !sender.selected;
}

-(void)setVideoInfo:(NSDictionary *)videoInfo
{
    _videoInfo = videoInfo;
    [_iconImageView setImageWithURL:[NSURL URLWithString:videoInfo[@"Cover"]] placeholderImage:[UIImage imageNamed:@"placehodlerimg"]];
    _detailLabel.text = videoInfo[@"Title"];
    if ([_videoInfo[@"downloadFinish"] isEqualToString:@"1"]) {
        _progressView.progress = 1.f;
//        [_pauseBtn setTitle:@"已完成" forState:UIControlStateNormal];
        _progressLabel.text = @"100%";
        [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"offline_over"] forState:UIControlStateNormal];
        _pauseBtn.enabled = NO;
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProgressChange:) name:videoInfo[@"Id"] object:nil];
    }
}

-(void)onProgressChange:(NSNotification *)userinfo
{
    _progressView.progress = [userinfo.object floatValue];
    if ([userinfo.object floatValue] *100 >= 100) {
        _progressLabel.text = @"100%";
    } else {
        _progressLabel.text = [NSString stringWithFormat:@"%.f%%", [userinfo.object floatValue]*100];
    }
    if (!_pauseBtn.selected &&_flag !=1) {
        _flag =1;
        _pauseBtn.selected = YES;
    }
    NSLog(@"%f", _progressView.progress);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
