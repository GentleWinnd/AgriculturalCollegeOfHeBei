//
//  ThirdTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ThirdTableViewCell.h"
#import "ItemCollectionViewCell.h"

@interface ThirdTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UILabel *tileLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end
static NSString *cellID = @"CellId";

@implementation ThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self creatCustomCollectioView];
}



#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.contentCollectionView.collectionViewLayout = layOut;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.contentCollectionView.scrollEnabled = NO;
    self.contentCollectionView.backgroundColor = MainLineColor_LightGray;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    number = self.itemsTitleArray.count/4==0?self.itemsTitleArray.count:(self.itemsTitleArray.count/4+1)*4;
    return number;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 1, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.row <self.itemsTitleArray.count) {
        cell.logoImage.image = [UIImage imageNamed:self.itemsIconArray[indexPath.row]];
        cell.titeLabel.text = self.itemsTitleArray[indexPath.row];
    } else {
        cell.logoImage.hidden = YES;
        cell.titeLabel.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=self.itemsTitleArray.count) {
        return;
    }
    self.itemSelectedIndex(indexPath);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-3)/4;
    return CGSizeMake(width, width);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
