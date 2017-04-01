//
//  CourseNumCollectionViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseNumCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *courseNumLabel;
- (void)setSelectedColor;

@end
