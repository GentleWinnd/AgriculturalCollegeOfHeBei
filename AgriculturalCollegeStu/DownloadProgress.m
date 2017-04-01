//
//  DownloadProgress.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "DownloadProgress.h"

@implementation DownloadProgress

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createGrayCircle];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createGrayCircle];
}

- (void)createGrayCircle {
    NSInteger kLineWidth = 2;
    CGRect frame = self.bounds;
    self.outLayer = [CAShapeLayer layer];
    CGRect rect1 = {kLineWidth / 2, kLineWidth / 2,
        frame.size.width - kLineWidth, frame.size.height - kLineWidth};
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:rect1];
    self.outLayer.strokeColor = RulesLineColor_DarkGray.CGColor;
    self.outLayer.lineWidth = kLineWidth;
    self.outLayer.fillColor =  [UIColor clearColor].CGColor;
    self.outLayer.lineCap = kCALineCapRound;
    self.outLayer.path = path1.CGPath;
    [self.layer addSublayer:self.outLayer];
    
    CGRect rect = {kLineWidth / 2, kLineWidth / 2,
        frame.size.width - 2*kLineWidth, frame.size.height - 2*kLineWidth};
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = RulesLineColor_DarkGray.CGColor;
    self.progressLayer.lineWidth = kLineWidth*2;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.path = path.CGPath;
    [self.layer addSublayer:self.progressLayer];

    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)updateProgressWithNumber:(CGFloat)number {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd =  number;
    [CATransaction commit];
}


@end
