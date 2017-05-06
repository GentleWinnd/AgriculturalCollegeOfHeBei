//
//  ClassVTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassVTableViewCell.h"

@interface ClassVTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

static NSString *cellID = @"videoCellID";

@implementation ClassVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self creatCustomCollectioView];
}


#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.classVideoInfo.collectionViewLayout = layOut;
    self.classVideoInfo.delegate = self;
    self.classVideoInfo.dataSource = self;
    layOut.minimumInteritemSpacing = 3;
    layOut.minimumLineSpacing = 3;
    self.classVideoInfo.backgroundColor = [UIColor whiteColor];
    [self.classVideoInfo registerNib:[UINib nibWithNibName:@"CLVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_entity.Courses.count<=5) {
        return _entity.Courses.count;
    } else {
        return 5;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.row > _entity.Courses.count-1) {
        return cell;
    }
    NSString *imgCover = _entity.Courses[indexPath.row][@"Cover"];
    NSString *title = _entity.Courses[indexPath.row][@"Name"];
    NSString *desc  = _entity.Courses[indexPath.row][@"Description"];

    [cell.showImag setImageWithURL:[NSURL URLWithString:imgCover]];
    cell.courceNM.text = title;
    cell.lookCount.hidden = YES;
    return cell;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *courseId = nil;
    NSString *pageCategoryId = nil;
    NSString *courseCover = nil;
    NSString *courseName = nil;
    courseId = _entity.Courses[indexPath.row][@"Id"];
    courseCover = _entity.Courses[indexPath.row][@"Cover"];
    pageCategoryId = _entity.Id;
    courseName = _entity.Courses[indexPath.row][@"Name"];
    
    HaventSignUpViewController *haventView = [[HaventSignUpViewController alloc] init];
    haventView.subId = courseId;
    haventView.subTitle = courseName;
    [self.delegate ClassVTableViewCellPushSuperView:haventView animation:YES];


}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-10)/7;
    return CGSizeMake(width*3, width*2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
