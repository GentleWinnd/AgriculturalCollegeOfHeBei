//
//  HistoryListController.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineViewController.h"
#import "HistoryListController.h"
#import "ListCell.h"
#import "Header_key.h"
#import "VideoPageModel.h"
#import "VideoEpisodesModel.h"


@interface HistoryListController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HistoryListController
{
    NSArray *listData;
    CATransition *animation;
}

@synthesize v_bottomContainer;
@synthesize v_titleContainer;
@synthesize tbv_listTabv;
@synthesize btn_back = _btn_back;
@synthesize minePageViewController;
@synthesize isTobeFavoritePage;
@synthesize lbl_title;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    lbl_title.font = [UIFont fontWithName:@"Microsoft Yahei" size:16];
    
    if(isTobeFavoritePage) {
        [lbl_title setText:@"收藏历史"];
    } else {
        [lbl_title setText:@"播放历史"];
    }
    
    animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    tbv_listTabv.hidden = YES;
    tbv_listTabv.delegate = self;
    tbv_listTabv.dataSource = self;
    tbv_listTabv.separatorStyle = NO;
    tbv_listTabv.showsVerticalScrollIndicator = NO;

    [self performSelectorInBackground:@selector(getHistoryList) withObject:nil];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    v_titleContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    v_titleContainer.layer.shadowOffset = CGSizeMake(0, 1);
    v_titleContainer.layer.shadowOpacity = 0.5;
    v_titleContainer.layer.shadowRadius = 1;
    
}

- (IBAction) backClick:(id)sender {
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [minePageViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void) getHistoryList {
    
    NSMutableArray *ld = [[NSMutableArray alloc] init];
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *historyCache = nil;
    
    if(!isTobeFavoritePage) {
        historyCache = [appCaches objectForKey:HISTORY_CACHE_KEY];
    } else {
        historyCache = [appCaches objectForKey:FAVORITE_CACHE_KEY];
    }
    
    NSArray *keys = [historyCache allKeys];
    
    for (NSString *key in keys) {
        
        NSDictionary *dic = [historyCache objectForKey:key];
        VideoPageModel *pageModel = [[VideoPageModel alloc] init];
        if (![dic isEqual:[NSNull null]]) {
            pageModel.Information = dic[@"Information"];
            pageModel.Id = dic[@"Id"];
            pageModel.Name = dic[@"Name"];
            pageModel.Period = dic[@"Period"];
            pageModel.Public = dic[@"Public"];
            pageModel.Cover = dic[@"Cover"];
            pageModel.parentCategoryId = dic[@"BelongToId"];
        }
        [ld addObject:pageModel];
    }
    
    [self performSelectorOnMainThread:@selector(getHistoryListFinished:) withObject:ld waitUntilDone:NO];
}


-(void) getHistoryListFinished:(NSMutableArray *) array {
    
    listData = [[NSArray alloc] initWithArray:array];
    if(listData.count != 0) {
        
        [tbv_listTabv reloadData];
        tbv_listTabv.hidden = NO;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(listData != nil) return listData.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoPageModel *model = [listData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"history_list_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        ListCell *lc = [ListCell initViewLayout];
        lc.myParentViewController = self;
        [lc.lbl_desc setText:model.Information];
        [lc.lbl_title setText:model.Name];
        [lc.lbl_num setText:[NSString stringWithFormat:@"%@集", model.Period]];
        [lc.imgv_leftIcon setImageWithURL:[[NSURL alloc] initWithString:model.Cover]];
        cell = lc;
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoPageModel *model = [listData objectAtIndex:indexPath.row];
    ListCell *currentCell = (ListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [currentCell pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:model.parentCategoryId];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

@end