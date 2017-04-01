//
//  VideoPageDetailView.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/21.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPageDetailView.h"
#import "EpisodesCell.h"
#import "HOMEHeader.h"
#import "Header_key.h"
#import "SubTableViewModel.h"
#import "AFHTTPSessionManager.h"
#import "VideoRecommandCell.h"
#import "UIImageView+AFNetworking.h"
#import "VideoPageController.h"

#define TABVIEW_TYPE_1 0x57a1
#define TABVIEW_TYPE_2 0x8B33

@interface  VideoPageDetailView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VideoPageDetailView
{
    int currentPlayIndex;
    int pageNum;
    NSMutableArray *recommandArray;
    BOOL isFavoriteChecked;
}

@synthesize lbl_title;
@synthesize lbl_subTitle;
@synthesize lbl_desc;
@synthesize lbl_otherInfo1;
@synthesize tabv_episodes = _tabv_episodes;
@synthesize tabv_recommend = _tabv_recommend;
@synthesize videoPlayer = _videoPlayer;

@synthesize btn_favorite = _btn_favorite;
@synthesize btn_share;

@synthesize parentViewCnl;
@synthesize entity;


- (void) fillContent:(VideoView *) videoPlayer videoModel:(VideoPageModel *) model {
    
    if(_videoPlayer == nil) {
        
        _videoPlayer = videoPlayer;
        
        _tabv_episodes.delegate = self;
        _tabv_episodes.dataSource = self;
        _tabv_episodes.separatorStyle = NO;
        _tabv_episodes.showsVerticalScrollIndicator = NO;
        _tabv_episodes.tag = TABVIEW_TYPE_1;
        
        _tabv_episodes.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
        _tabv_episodes.hidden = NO;
        
        
        _tabv_recommend.delegate = self;
        _tabv_recommend.dataSource = self;
        _tabv_recommend.separatorStyle = NO;
        _tabv_recommend.showsVerticalScrollIndicator = NO;
        _tabv_recommend.tag = TABVIEW_TYPE_2;
    }
    
    entity = model;
    currentPlayIndex = 0;
    [lbl_title setText:entity.Name];
    [lbl_desc setText:entity.Information];
    int num = (arc4random() % 100) + 1;
    [lbl_subTitle setText:[NSString stringWithFormat:@"%d 人正在观看",num]];
    [_tabv_episodes reloadData];
    [self performSelectorInBackground:@selector(checkFavoriteCache:) withObject:entity.Id];
    if(recommandArray == nil || recommandArray.count == 0) {
        recommandArray = [NSMutableArray array];
        [self performSelectorInBackground:@selector(loadRecommand:) withObject:entity.parentCategoryId];
    }
}

-(void) loadRecommand:(NSString *) recommandId {
    NSDictionary *parameter = @{@"URL":[NSString stringWithFormat:URL_COURSE_LIST, recommandId, @"MVC", 1]};
    [NetServiceAPI getCourseListInfoWithParameters:parameter success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"PageListInfos"]) {
            SubTableViewModel *model = [[SubTableViewModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [recommandArray addObject:model];
        }
        
        _tabv_recommend.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
        [_tabv_recommend reloadData];
        _tabv_recommend.hidden = NO;

    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);

    }];
        
}


+ (instancetype) initViewLayout {
    
    VideoPageDetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"video_course_detail" owner:nil options:nil]  lastObject];
    
    return view;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    _tabv_episodes.hidden = YES;
    _tabv_recommend.hidden = YES;
    
    [self bringSubviewToFront:_tabv_episodes];
    [self bringSubviewToFront:_tabv_recommend];

}

- (IBAction) favoriteClick:(id)sender {
    
    if(isFavoriteChecked) {
        [self performSelectorInBackground:@selector(deleteFavoriteCache:) withObject:entity.Id];
    } else {
        [self performSelectorInBackground:@selector(saveFavoriteCache:) withObject:entity.Id];
    }
}

- (void) checkFavoriteCache:(NSString *) courseId {

    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    NSDictionary *originDic = [appCaches objectForKey:HISTORY_CACHE_KEY];
    
    if(originDic) {
        NSObject *obj = [originDic objectForKey:courseId];
        BOOL isFavorite = NO;
        if(obj) isFavorite = YES;
        [self performSelectorOnMainThread:@selector(setFavoriteState:) withObject:[NSNumber numberWithBool:isFavorite] waitUntilDone:NO];
    }
}

- (void) saveFavoriteCache:(NSString *) courseId {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *originDic = [appCaches objectForKey:FAVORITE_CACHE_KEY_CHECK];
    NSMutableDictionary *checkDic = [[NSMutableDictionary alloc] init];
    if(originDic) [checkDic addEntriesFromDictionary:originDic];
    [checkDic setObject:courseId forKey:courseId];
    [appCaches setObject:checkDic forKey:FAVORITE_CACHE_KEY_CHECK];
    [appCaches synchronize];
    
    NSDictionary *originDicKv = [appCaches objectForKey:FAVORITE_CACHE_KEY];
    NSMutableDictionary *kvAllDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *kvDic = [[NSMutableDictionary alloc] init];
    if(originDicKv) [kvAllDic addEntriesFromDictionary:originDicKv];
    [kvDic setObject:entity.Id forKey:@"Id"];
    [kvDic setObject:entity.Cover forKey:@"Cover"];
    [kvDic setObject:entity.parentCategoryId forKey:@"BelongToId"];
    [kvDic setObject:entity.Information forKey:@"Information"];
    [kvDic setObject:entity.Name forKey:@"Name"];
    [kvDic setObject:entity.Period forKey:@"Period"];
    [kvDic setObject:entity.Public forKey:@"Public"];
    [kvAllDic setObject:kvDic forKey:courseId];
    [appCaches setObject:kvAllDic forKey:FAVORITE_CACHE_KEY];
    [appCaches synchronize];
    
    [self performSelectorOnMainThread:@selector(setFavoriteState:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
}

- (void) deleteFavoriteCache:(NSString *) courseId {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *originDic = [appCaches objectForKey:FAVORITE_CACHE_KEY_CHECK];
    NSMutableDictionary *checkDic = [[NSMutableDictionary alloc] init];
    if(originDic) [checkDic addEntriesFromDictionary:originDic];
    [checkDic removeObjectForKey:courseId];
    [appCaches setObject:checkDic forKey:FAVORITE_CACHE_KEY_CHECK];
    [appCaches synchronize];
    
    NSDictionary *originDicKv = [appCaches objectForKey:FAVORITE_CACHE_KEY];
    NSMutableDictionary *kvDic = [[NSMutableDictionary alloc] init];
    if(originDicKv) [kvDic addEntriesFromDictionary:originDicKv];
    [kvDic removeAllObjects];
    [appCaches setObject:kvDic forKey:FAVORITE_CACHE_KEY];
    [appCaches synchronize];
    
    [self performSelectorOnMainThread:@selector(setFavoriteState:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
}

- (void) setFavoriteState:(NSNumber *) isFavorite {
    
    if([isFavorite compare:[NSNumber numberWithBool:YES]] == NSOrderedSame) {
        isFavoriteChecked = YES;
        [_btn_favorite setBackgroundImage:[UIImage imageNamed:@"sc_"] forState:UIControlStateNormal];
    } else {
        isFavoriteChecked = NO;
        [_btn_favorite setBackgroundImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    }
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView.tag == TABVIEW_TYPE_1) {
        return entity.episodesArray.count;
    } else if(tableView.tag == TABVIEW_TYPE_2){
        return recommandArray.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag == TABVIEW_TYPE_1) {
        
        static NSString *CellIdentifier = @"video_episodes_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            
            EpisodesCell *ec = [EpisodesCell initViewLayout];
            [ec.lbl_numb setText:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
            if(indexPath.row == currentPlayIndex) [ec.lbl_numb setTextColor:[UIColor orangeColor]];
            cell = ec;
            cell.transform = CGAffineTransformMakeRotation(M_PI /2.f);
        }
    
        return cell;
        
    } else if(tableView.tag == TABVIEW_TYPE_2) {
        
        static NSString *CellIdentifier = @"video_recommand_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            
            VideoRecommandCell *rc = [VideoRecommandCell initViewLayout];
            SubTableViewModel *model =  [recommandArray objectAtIndex:indexPath.row];
            NSURL *coverUrl = [[NSURL alloc] initWithString:model.Cover];
            [rc.imgv_cover setImageWithURL: coverUrl];
            [rc.imgv_cover_bg setImageWithURL: coverUrl];
            [rc.lbl_title setText:model.Name];
            [rc.lbl_count setText:[NSString stringWithFormat:@"更新%@集", model.Period]];
            
            cell = rc;
            cell.transform = CGAffineTransformMakeRotation(M_PI /2.f);
            
        }
        
        return cell;
        
    } else {
        
        
        return [[UITableViewCell alloc] init];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubTableViewModel *mod = nil;
    
    if(_videoPlayer.videoPlayer != nil) [_videoPlayer.videoPlayer stop];
    
    switch (tableView.tag) {
        case TABVIEW_TYPE_1:
            currentPlayIndex = (int) indexPath.row;
            [_tabv_episodes reloadData];
            [_videoPlayer videoToPlayAtIndex:currentPlayIndex forceToStop:YES];
            break;
        case TABVIEW_TYPE_2:
            if(recommandArray == nil || recommandArray.count == 0) break;
            mod =  [recommandArray objectAtIndex:indexPath.row];
            ((VideoPageController *)parentViewCnl).courseId = mod.Id;
            [((VideoPageController *)parentViewCnl) loadDetailInfo];
            break;
        default:
            break;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TABVIEW_TYPE_1) return 50;
    else if((tableView.tag == TABVIEW_TYPE_2)) return 110;
    else return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

@end
