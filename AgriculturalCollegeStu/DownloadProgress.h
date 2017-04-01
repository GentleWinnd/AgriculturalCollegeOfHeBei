//
//  DownloadProgress.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadProgress : UIView

@property (nonatomic, strong) CAShapeLayer *outLayer;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

- (void)updateProgressWithNumber:(CGFloat)number;

@end
