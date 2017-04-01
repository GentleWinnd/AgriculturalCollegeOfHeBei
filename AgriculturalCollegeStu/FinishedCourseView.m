//
//  FinishedCourseView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "FinishedCourseView.h"
#import "CourseNumCollectionViewCell.h"

@interface FinishedCourseView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *courseNumCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backViewTop;

@end
static NSString *cellID = @"cellID";

@implementation FinishedCourseView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self creatCustomCollectioView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.tapView addGestureRecognizer:tap];

}

- (void)tapAction:(UIGestureRecognizer *)gesture {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
        
    }];
}


- (IBAction)courseBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
        
    }];

}

#pragma mark - 创建collectionView

- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.courseNumCollectionView.collectionViewLayout = layOut;
    self.courseNumCollectionView.delegate = self;
    self.courseNumCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.courseNumCollectionView.backgroundColor = [UIColor whiteColor];
    [self.courseNumCollectionView registerNib:[UINib nibWithNibName:@"CourseNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _courseNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.courseNumLabel.text = [NSString stringWithFormat:@"%tu",indexPath.row+1];
    cell.courseNumLabel.highlighted = NO;
    for (NSNumber *index in self.finishedArray) {
        if (indexPath.row  == [index integerValue]) {
            [cell setSelectedColor];
            cell.courseNumLabel.highlighted = YES;
            break;
        }
  
    }
    
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
    
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-8)/6;
    
    return CGSizeMake(width, width);
}


#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedNum(indexPath.row);
    [self removeFromSuperview];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
