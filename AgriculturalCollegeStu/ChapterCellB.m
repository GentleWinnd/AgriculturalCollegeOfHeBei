//
//  ChapterCellB.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseTableViewCell.h"
#import "ChapterCellB.h"
#import "HandoutViewController.h"

#define TAG_VIDEO       0x1
#define TAG_HANDOUT     0x2

@implementation ChapterCellB
{
    
}



+ (instancetype) initViewLayout {
    
    ChapterCellB * cell = [[[NSBundle mainBundle] loadNibNamed:@"chapter_cell_2" owner:nil options:nil] lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self bringSubviewToFront:_btn_toPlayVideo];
    [self bringSubviewToFront:_btn_toShowHandout];
    
    _btn_toPlayVideo.tag = TAG_VIDEO;
    _btn_toShowHandout.tag = TAG_HANDOUT;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (IBAction)onSomeButtonClick:(id)sender {
    
    int tag = (int) [sender tag];
    
    if (tag == TAG_VIDEO && _videoUrl != nil) {
        [_hostCell.videoView lazyToPlay:[NSURL URLWithString:_videoUrl]];
    
    } else if (tag == TAG_HANDOUT && _handoutContent != nil) {
    
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //animation.type = @"pageCurl";
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"handout" bundle:[NSBundle mainBundle]];
        HandoutViewController *handoutVc = (HandoutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"handout_page_vc"];
        
        handoutVc.faceCourseVideoVc = _hostCell.parentVc;
        handoutVc.handoutHtml = _handoutContent;
        
        [_hostCell.parentVc.view.window.layer addAnimation:animation forKey:nil];
        [_hostCell.parentVc presentViewController:handoutVc animated:NO completion:nil];
    }
}

@end