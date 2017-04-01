//
//  DetailViewController.h
//  OldUniversity
//
//  Created by mahaomeng on 15/7/23.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HOMEBaseViewController.h"

typedef void(^DetailViewControllerBlock)(void);

@interface DetailViewController : HOMEBaseViewController

@property (nonatomic, copy) NSString *subId;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *subCover;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) DetailViewControllerBlock refreshBlock;

-(instancetype)initWithIsDownloadViewController:(BOOL)flag;

@end
