//
//  AttachmentCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/7.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "AttachmentCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation AttachmentCollectionViewCell
- (IBAction)deletedBtnAction:(UIButton *)sender {
    if (self.deletedAttachment) {
        self.deletedAttachment();
    }
}


- (void)setAsset:(JKAssets *)asset{
    if (_asset != asset) {
        _asset = asset;
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                self.attachmentType.image = image;
                if (self.showImage) {
                    self.showImage(UIImageJPEGRepresentation(image, 0.01));
                }
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
