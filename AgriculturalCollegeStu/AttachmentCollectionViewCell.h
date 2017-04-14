//
//  AttachmentCollectionViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/7.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"

@interface AttachmentCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *attachmentType;
@property (strong, nonatomic) void(^deletedAttachment)();
@property (strong, nonatomic) void(^showImage)(NSData *imageData);

@property (nonatomic, strong) JKAssets  *asset;

@end
