//
//  NoDataView.h
//  AgriculturalCollegeStu
//
//  Created by SUPADATA on 2017/5/12.
//  Copyright © 2017年 YH. All rights reserved.
//

typedef NS_ENUM(NSInteger, NoDataType) {
    NoDataTypeDefualt,
    NoDataTypeLoadFailed

};

#import <UIKit/UIKit.h>

@interface NoDataView : UIView
@property (strong, nonatomic) IBOutlet UIButton *clickBtn;
@property (assign, nonatomic) NoDataType type;
@property (copy, nonatomic) void(^reloadData)();


+ (instancetype)layoutNoDataView;
- (void)removeNoDataView;

@end
