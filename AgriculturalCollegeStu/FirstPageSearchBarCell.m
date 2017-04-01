//
//  FirstPageSearchBarCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstPageSearchBarCell.h"
#import "ListPageViewController.h"


@interface FirstPageSearchBarCell ()

@end

@implementation FirstPageSearchBarCell

@synthesize btn_searchBar = _btn_searchBar;

- (void) awakeFromNib {
    
    [super awakeFromNib];
    [self bringSubviewToFront:_btn_searchBar];
    _btn_searchBar.layer.cornerRadius = 13;
    
}

+ (instancetype) initViewLayout {
    
    FirstPageSearchBarCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"first_page_header_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (IBAction) onSearchClick:(id)sender {
    
    [self pushToListPage:nil pageName:@"搜索"];
    
}

@end
