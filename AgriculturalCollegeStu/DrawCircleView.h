//
//  DrawCircleView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawCircleView : UIView

@property (nonatomic, assign) BOOL halfCircle;
@property (nonatomic, assign) BOOL grayCircle;
@property (nonatomic, assign) BOOL drawPicture;

- (void)drawRect:(CGRect)rect;
@end
