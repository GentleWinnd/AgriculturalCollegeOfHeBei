//
//  SignedStuView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SignedStuView.h"
#import "StusCollectionViewCell.h"
#import "NSArray+Extension.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@interface SignedStuView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

static NSString *cellID = @"cellId";
static NSString *headerViewID = @"headerView";

@implementation SignedStuView

+ (instancetype)initViewLayout {
    SignedStuView *slf = [[[NSBundle mainBundle] loadNibNamed:@"SignedStuView" owner:self options:nil]  lastObject];
    return slf;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self creatCustomCollectioView];
    [self bringSubviewToFront:self.stuCollectionView];
    
}

#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.stuCollectionView.collectionViewLayout = layOut;
    self.stuCollectionView.delegate = self;
    self.stuCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.stuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.stuCollectionView registerNib:[UINib nibWithNibName:@"StusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.stuCollectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.signedStuInfo.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger number = section == 1?((NSArray *)self.signedStuInfo[SHOULD_STU]).count:((NSArray *)self.signedStuInfo[SUBMIT_STU]).count;

    return number;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *title;
        if (self.stuType == StuInfoTypeSigne) {
            title = indexPath.section == 0?@"已签到学生":@"上课应到学生";
        } else if(self.stuType == StuInfoTypeTest) {
            title = indexPath.section == 0?@"已完成测验学生":@"本课程所有学生";
        } else {
            title = indexPath.section == 0?@"已交作业学生":@"本课程所有学生";
        }
        HeaderView  *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        headerView.stuName.text = title;
        reusableView = headerView;
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSString *name = [self getSignedStudentNameWithIndexPath:indexPath];
    NSString *avatar = [NSString safeString:[self getSignedStudentAvatarWithIndexPath:indexPath]];
    
    [cell.headPortriat sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:nil];
    cell.stuName.text = name;
    
    return cell;
}

#pragma mark - get signed student name

- (NSString *)getSignedStudentNameWithIndexPath:(NSIndexPath *)indexPath {
    NSString *name ;
    if (indexPath.section == 0) {
        name = [NSArray arrayWithArray:self.signedStuInfo[SUBMIT_STU]][indexPath.row][@"FullName"];
    } else {
        name = [NSArray arrayWithArray:self.signedStuInfo[SHOULD_STU]][indexPath.row][@"FullName"];
    }
    return name;
}

#pragma mark - get signed student name

- (NSString *)getSignedStudentAvatarWithIndexPath:(NSIndexPath *)indexPath {
    NSString *name ;
    if (indexPath.section == 0) {
        name = [NSArray safeArray:self.signedStuInfo[SUBMIT_STU]][indexPath.row][@"Avatar"];
    } else {
        name = [NSArray safeArray:self.signedStuInfo[SHOULD_STU]][indexPath.row][@"Avatar"];
    }
    return name;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-9)/4;
    return CGSizeMake(width, width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(WIDTH, 30);
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return;
    }
    if (self.stuType != StuInfoTypeSigne) {
        NSString *stuId = [NSArray safeArray:self.signedStuInfo[SUBMIT_STU]][indexPath.row][@"Id"];
        self.selectedStu(stuId);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@interface HeaderView()

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect LFrame = self.bounds;
        LFrame.origin.x = 5;
        _stuName = [[UILabel alloc] initWithFrame:LFrame];
        _stuName.font = [UIFont systemFontOfSize:13];
        _stuName.textColor = MaintextColor_LightBlack;
        [self addSubview:_stuName];
        self.backgroundColor = MainBackgroudColor_GrayAndWhite;
        
    }
    return self;
}

@end

