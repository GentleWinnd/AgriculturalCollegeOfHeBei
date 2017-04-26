//
//  ClassVTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//
@class HaventSignUpViewController;

@protocol ClassVTableViewCellDelegate <NSObject>

- (void)ClassVTableViewCellPushSuperView:(HaventSignUpViewController *)VC animation:(BOOL)animated;

@end

#import <UIKit/UIKit.h>
#import "CLVideoCollectionViewCell.h"
#import "BaseTableViewCell.h"
#import "FirstPageContentModel.h"
#import "HaventSignUpViewController.h"

@interface ClassVTableViewCell : BaseTableViewCell


@property (strong, nonatomic) IBOutlet UICollectionView *classVideoInfo;
@property (strong, nonatomic) FirstPageContentModel *entity;
@property (strong, nonatomic) id<ClassVTableViewCellDelegate>delegate;

@end
