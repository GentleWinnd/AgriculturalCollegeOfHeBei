//
//  VideoPageFaceCourse2.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/18.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPageFaceCourse2.h"
#import "VideoPageModel.h"
#import "VideoEpisodesModel.h"
#import "Header_key.h"


@interface VideoPageFaceCourse2 ()

@end

@implementation VideoPageFaceCourse2
{
    
}

- (void) viewDidLoad {
    
    UIFont *font = [UIFont fontWithName:@"Microsoft Yahei" size:14];
    
    _lbl_centerDesc.font = font;
    [_lbl_topTitle setText:_topTitle];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    _textv_teacherDesc.attributedText = [[NSAttributedString alloc] initWithString:_teacherDesc attributes:attributes];
    [_textv_teacherDesc setTextColor:[UIColor darkGrayColor]];
    
    NSURL *pic = [[NSURL alloc] initWithString:_picUrl];
    [_imgv_coursePic setImageWithURL:pic];
}

- (void) viewDidAppear:(BOOL)animated {

    _v_topContainer.clipsToBounds = NO;
    _v_topContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _v_topContainer.layer.shadowOffset = CGSizeMake(0, 1);
    _v_topContainer.layer.shadowOpacity = 0.5;
    _v_topContainer.layer.shadowRadius = 1;
    
    [self.view bringSubviewToFront:_v_topContainer];
}

- (IBAction) onGobackClicked:(id)sender {
    
    [_parentVc dismissViewControllerAnimated:NO completion:nil];
}


@end
