//
//  CropImageViewController.m
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "CropImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "TKImageView.h"
#import "JKAssets.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CROP_PROPORTION_IMAGE_WIDTH 30.0f
#define CROP_PROPORTION_IMAGE_SPACE 48.0f
#define CROP_PROPORTION_IMAGE_PADDING 20.0f

@interface CropImageViewController () {
    
    NSMutableArray *changeArray;
    int currentIndex;
    BOOL finished;
}

@property (strong, nonatomic) IBOutlet UIButton *frontBtn;
@property (strong, nonatomic) UIImage *currentImage;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishedBtn;
@property (strong, nonatomic) IBOutlet TKImageView *tkImageView;
@property (strong, nonatomic) IBOutlet UIButton *confirmbtn;

@end

@implementation CropImageViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"剪裁图片";
    
    [self setButtonFrame:_frontBtn];
    [self setButtonFrame:_nextBtn];
    [self setButtonFrame:_finishedBtn];
    [self setButtonFrame:_confirmbtn];
    
    currentIndex = 0;
    changeArray = [NSMutableArray arrayWithArray:self.imagesArr];
    [self setUpTKImageView];
    [self getImageWithAsset:self.imagesArr[0]];
    
}

- (void)setButtonFrame:(UIButton *)btn {

    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = MainThemeColor_Blue.CGColor;
    btn.layer.borderWidth = 1;

}

- (void)setUpTKImageView {
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 4;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 1.0;
}

- (void)getImageWithAsset:(JKAssets *)asset {

    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            _currentImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.01)];
            _tkImageView.toCropImage = _currentImage;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag == 1) {//上一张
        currentIndex--;
        if (currentIndex<0) {
            [Progress progressShowcontent:@"没有更多的照片了" currView:self.view];
            currentIndex = 0;
            return;
        }
        [self getImageWithAsset:self.imagesArr[currentIndex]];
        
    } else if (sender.tag == 2) {//下一张
        currentIndex++;

        if (currentIndex > self.imagesArr.count-1) {
            currentIndex = self.imagesArr.count-1;
            [Progress progressShowcontent:@"没有更多的照片了" currView:self.view];
            return;
        }
        [self getImageWithAsset:self.imagesArr[currentIndex]];
    } else if (sender.tag == 3){//完成
        for (id obj in changeArray) {
            if ([obj isKindOfClass: [JKAssets class]]) {
                [Progress progressShowcontent:@"请完成所有照片的剪裁" currView:self.view];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendSelectedImages" object:nil userInfo:@{@"image":changeArray}];

        [self dismissViewControllerAnimated:YES completion:nil];
    } else {//确定
        if (currentIndex>self.imagesArr.count-1) {
            [Progress progressShowcontent:@"没有更多的照片了" currView:self.view];
            currentIndex = self.imagesArr.count-1;
            return;
        }
        
        [changeArray replaceObjectAtIndex:currentIndex withObject:[_tkImageView currentCroppedImage]];
        currentIndex++;
        if (currentIndex > self.imagesArr.count-1) {

            return;
        }

        [self getImageWithAsset:[self.imagesArr objectAtIndex:currentIndex]];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
