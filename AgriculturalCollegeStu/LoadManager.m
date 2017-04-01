//
//  LoadManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/20.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "LoadManager.h"

@implementation LoadManager

+ (instancetype)defaultInstance {
    static LoadManager *loadM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadM = [[self alloc] init];
    });
    return loadM;
}



- (void)download {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:self.url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        self.receiptM = receipt;
                                                        
//                                                        if ([receipt.url isEqualToString:self.url]) {
//                                                            self.capacityTrail.text = [NSString stringWithFormat:@"%.0f%%",((float)receipt.totalBytesWritten)/((float)receipt.totalSize)*100];
//                                                        }
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         //                                                         self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
//                                                         [self.downLoadBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
                                                         
                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         //                                                          self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
//                                                         [self.downLoadBtn setImage:[UIImage imageNamed:@"puasebtn"] forState:UIControlStateNormal];
                                                     }];
    
}



@end
