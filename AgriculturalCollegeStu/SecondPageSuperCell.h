//
//  SecondPageSuperCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SecondPageSuperCell : BaseTableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSString *categroyId;
@property (retain, nonatomic) NSArray *categroyList;
@property (retain, nonatomic) NSDictionary *categroyAllMap;

@property (retain, nonatomic) NSMutableDictionary *itemTypeMap;
@property (retain, nonatomic) NSMutableDictionary *pageContentMap;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actvi_loadingbar;

- (void) loadPageInfo;

+ (instancetype) initViewLayout;

@end
