//
//  CourseInfoCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "CourseInfoCollectionViewCell.h"

@implementation CourseInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _answerTextView.delegate = self;
    
}

#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeHolderView.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {//将要停止编辑(不是第一响应者时)
    if (self.getAnswer) {
        self.getAnswer(textView.text);
    }
    if (textView.text.length == 0) {
        _placeHolderView.alpha = 1;
    }
    return YES;
}

- (void)setAnswerStr:(NSString *)answerStr {

    if (answerStr) {
        self.answerTextView.text = answerStr;
        _placeHolderView.alpha = 0;//开始编辑时

    }
}



@end
