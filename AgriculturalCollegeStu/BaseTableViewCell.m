//
//  BaseTableViewCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"
#import "ListPageViewController.h"

@interface  BaseTableViewCell()

@end

@implementation BaseTableViewCell
{
    
}

- (IBAction) onMoreButtonClick:(id)sender {}

@synthesize myParentViewController;
@synthesize myHostTableView;
@synthesize myTitleTableView;
@synthesize randomValue;

- (void) pushToVideoPage:(NSString *) courseId courseCover:(NSString *)cover pageCategoryId:(NSString *) categoryId {
    
    
    UIStoryboard* storyboard =
    [UIStoryboard storyboardWithName:@"video_page" bundle:[NSBundle mainBundle]];
    
//    VideoPageController *videoPageController = (VideoPageController *)[storyboard instantiateViewControllerWithIdentifier:@"video_page_controller"];
//    videoPageController.parentVc = myParentViewController;
//    videoPageController.courseId = courseId;
//    videoPageController.pageCategoryId = categoryId;
//    videoPageController.courseCover = cover;
//    videoPageController.isFromCache = NO;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    /*常見的轉換類型（type）：
     kCATransitionFade               //淡出
     kCATransitionMoveIn          //覆盖原图
     kCATransitionPush               //推出
     kCATransitionReveal          //底部显出来
     SubType:
     kCATransitionFromRight
     kCATransitionFromLeft    // 默认值
     kCATransitionFromTop
     kCATransitionFromBottom
     设置其他动画类型的方法(type):
     pageCurl   向上翻一页
     pageUnCurl 向下翻一页
     rippleEffect 滴水效果
     suckEffect 收缩效果，如一块布被抽走
     cube 立方体效果
     oglFlip 上下翻转效果 */
    
    [myParentViewController.view.window.layer addAnimation:animation forKey:nil];
//    [myParentViewController presentViewController:videoPageController animated:NO completion:nil];
    
}

- (void) pushToListPage:(NSString *) subCategroyId pageName:(NSString *) subCategroyName {

    NSLog(@"go to search page.");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"list_page" bundle:[NSBundle mainBundle]];
    ListPageViewController *listController = (ListPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"list_page_vc"];
    listController.parentVc = self.myParentViewController;
    listController.subCategoryId = subCategroyId;
    listController.subCategoryName = subCategroyName;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    [self.myParentViewController.view.window.layer addAnimation:animation forKey:nil];
    [self.myParentViewController presentViewController:listController animated:NO completion:nil];
}


@end
