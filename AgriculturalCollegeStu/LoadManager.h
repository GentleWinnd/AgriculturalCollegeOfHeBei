//
//  LoadManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/20.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDownloadManager.h"

@interface LoadManager : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) MCDownloadReceipt *receiptM;

- (MCDownloadReceipt *)downloadReceiptForURL:(NSString *)url;


@end
