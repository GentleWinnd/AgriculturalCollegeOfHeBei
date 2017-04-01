//
//  BaseTableViewCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPageModel.h"

@interface BaseTableViewCell : UITableViewCell

@property (strong, nonatomic) UIViewController *myParentViewController;
@property (strong, nonatomic) UITableView *myHostTableView;
@property (strong, nonatomic) UITableView *myTitleTableView;

@property (assign, nonatomic) int randomValue;

- (void) pushToVideoPage:(NSString *) courseId courseCover:(NSString *)cover pageCategoryId:(NSString *) categoryId;

- (void) pushToListPage:(NSString *) subCategroyId pageName:(NSString *) subCategroyName;

- (IBAction)onMoreButtonClick:(id)sender;

@end