//
//  EvaluationHeaderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^ReselectedCourse)();

#import <UIKit/UIKit.h>

@interface EvaluationHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *oneLabel;
@property (strong, nonatomic) IBOutlet UILabel *EoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoLabel;
@property (strong, nonatomic) IBOutlet UILabel *ETwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeLabel;
@property (strong, nonatomic) IBOutlet UILabel *EThreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UIButton *reselectedBtn;

@property (strong, nonatomic) IBOutlet UILabel *TOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *TTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *TThreeLabel;


@property (copy, nonatomic) ReselectedCourse reselecteCourse;

- (NSDictionary *)setEvaluationScoreColorWithScore:(CGFloat)score;
@end
