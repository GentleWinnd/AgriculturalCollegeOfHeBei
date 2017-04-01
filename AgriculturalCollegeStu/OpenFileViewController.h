//
//  OpenFileViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/28.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OpenFileViewController : BaseViewController

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) SourceType SType;

@end
