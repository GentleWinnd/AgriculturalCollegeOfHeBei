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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
