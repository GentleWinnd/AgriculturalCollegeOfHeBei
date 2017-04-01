//
//  CurrentClassView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^classSelectedClick)(UIButton *sender);

@interface CurrentClassView : UIView

@property (strong, nonatomic) IBOutlet UILabel *courceName;

@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;

@property (copy, nonatomic) classSelectedClick selectedClick;

+ (instancetype)initViewLayout;

@end
