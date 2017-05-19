
    //
//  SenconTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenconTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *progressView;
@property (strong, nonatomic) NSArray *dayScheduleArray;
@property (copy, nonatomic) void(^reloadData)(BOOL reload);

@property (strong, nonatomic) IBOutlet UIButton *nodataBtn;


@end
