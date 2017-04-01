//
//  ThirdTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^itemSelected)(NSIndexPath *indexPath);

@interface ThirdTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *itemsIconArray;
@property (nonatomic, strong) NSArray *itemsTitleArray;
@property (nonatomic, copy) itemSelected itemSelectedIndex;


@end
