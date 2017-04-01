//
//  QuestionHeaderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *questionType;
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UILabel *selectedAnswer;
@property (assign, nonatomic) NSInteger type;

@end
