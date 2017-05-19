//
//  SenconTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SenconTableViewCell.h"
#import "AlertCollectionViewCell.h"

@interface SenconTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end
static NSString *cellID = @"CellID";

@implementation SenconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self creatCustomCollectioView];
    
}

- (void)setDayScheduleArray:(NSArray *)dayScheduleArray {
    _dayScheduleArray = dayScheduleArray;
    self.progressView.numberOfPages = self.dayScheduleArray.count%4 == 0?self.dayScheduleArray.count/4:self.dayScheduleArray.count/4+1;
}

#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = layOut;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AlertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayScheduleArray.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *scheduleInfo = [NSDictionary safeDictionary:self.dayScheduleArray[indexPath.row]];
    cell.titleView.text = scheduleInfo[@"Name"];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", scheduleInfo[@"Count"]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger gap = 2*(_dayScheduleArray.count-1);
    float width = (WIDTH-gap)/_dayScheduleArray.count;
//    float width = (WIDTH-7)/4;
    return CGSizeMake(width, 120);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float width = (WIDTH-9)/4+1;
    CGFloat originX = scrollView.contentOffset.x;
    NSInteger page = originX>width?1:0;
    _progressView.currentPage = page;
    
}

- (IBAction)nodataBtnAction:(UIButton *)sender {
    
    if (self.reloadData) {
        self.reloadData(sender.selected);
    }
}




@end
