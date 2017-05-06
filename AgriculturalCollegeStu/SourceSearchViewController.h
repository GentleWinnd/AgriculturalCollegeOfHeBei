//
//  SourceSearchViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^returnSearchResult)(NSDictionary *sourceInfo);

@interface SourceSearchViewController : BaseViewController
@property (copy, nonatomic) returnSearchResult searchResult;
@property (copy, nonatomic) NSString *courseId;


@end
