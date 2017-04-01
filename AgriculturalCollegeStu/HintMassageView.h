//
//  HintMassageView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^hiddenSelf)();

@protocol HintViewDelegate <NSObject>
@optional
- (void)hiddenSelfView;

@end


#import <UIKit/UIKit.h>

@interface HintMassageView : UIView
@property (strong, nonatomic) IBOutlet UIButton *hintLabel;
@property (nonatomic, copy) hiddenSelf hiddenSelf;
@property (assign, nonatomic)id<HintViewDelegate>delegate;
+ (instancetype)initLayoutView;
@end
