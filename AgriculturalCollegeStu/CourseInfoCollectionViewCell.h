//
//  CourseInfoCollectionViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^getInputAnswer)(NSString *answer);

#import <UIKit/UIKit.h>

@interface CourseInfoCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderView;
@property (copy, nonatomic) getInputAnswer getAnswer;
@property (copy, nonatomic) NSString *answerStr;

@end
