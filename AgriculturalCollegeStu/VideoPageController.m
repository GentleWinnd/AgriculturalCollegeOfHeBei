//
//  VideoPage.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/21.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPageController.h"
#import "VideoPageDetailView.h"
#import "VideoPageModel.h"
#import "VideoEpisodesModel.h"
#import "VideoView.h"
#import "Header_key.h"

#define CONTENTSIZE_HEIGHT 500

@interface VideoPageController ()

@end

@implementation VideoPageController
{
    CATransition *animation;
    VideoView *videoView;
}

@synthesize v_videoContainer = _v_videoContainer;
@synthesize v_detailContainer = _v_detailContainer;
@synthesize parentVc = _parentVc;
@synthesize v_detail = _v_detail;
@synthesize courseId = _courseId;
@synthesize btn_back = _btn_back;
@synthesize pageCategoryId = _pageCategoryId;
@synthesize btn_playVideo = _btn_playVideo;
@synthesize imgv_videoPlayIcon = _imgv_videoPlayIcon;
@synthesize courseCover = _courseCover;
@synthesize coverLayer = _coverLayer;
@synthesize coverLayerBoring = _coverLayerBoring;

@synthesize isFromCache;
@synthesize pageModel;


- (void) viewDidLoad {
    [super viewDidLoad];
    
    animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    videoView = [VideoView initViewLayout];
    videoView.videoPageViewController = self;
    
    pageModel = [[VideoPageModel alloc] init];
    pageModel.episodesArray = [[NSMutableArray alloc] init];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    _v_detailContainer.contentSize = CGSizeMake(WIDTH, CONTENTSIZE_HEIGHT);
    _v_detail = [VideoPageDetailView initViewLayout];
    _v_detail.parentViewCnl = self;
    _v_detail.frame = CGRectMake(0, 0, WIDTH, CONTENTSIZE_HEIGHT);
    [_v_detailContainer addSubview:_v_detail];
    
    videoView.hidden = YES;
    videoView.frame = _v_videoContainer.frame;
    videoView.v_referenceBunds = _v_videoContainer;
    [self.view addSubview:videoView];
    [self.view bringSubviewToFront:videoView];
    
    if(isFromCache) {
        [self performSelectorInBackground:@selector(loadDetailInfoFromCache) withObject:nil];
    } else {
        [self performSelectorInBackground:@selector(loadDetailInfo) withObject:nil];
    }
}

- (void) loadDetailInfoFromCache {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    NSDictionary *originDic = [appCaches objectForKey:HISTORY_CACHE_KEY];
    NSDictionary *dic = [originDic objectForKey:_courseId];
    [self performSelectorOnMainThread:@selector(processData:) withObject:dic waitUntilDone:NO];
}

- (void)loadDetailInfo {
    
    pageModel = [[VideoPageModel alloc] init];
    pageModel.episodesArray = [[NSMutableArray alloc] init];
    NSDictionary *parameter = @{@"courseID":_courseId};
    [NetServiceAPI getMicroCourseInfoWithParameters:parameter success:^(id responseObject) {
        [self processData:responseObject];
        
        [self performSelectorInBackground:@selector(saveHistoryCache:) withObject:responseObject];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);

    }];
}

- (void) processData:(NSDictionary *) dic {
    
    NSMutableArray *autoPlayList = [[NSMutableArray alloc] init];
    
    if (![dic isEqual:[NSNull null]]) {
        pageModel.Information = dic[@"Information"];
        pageModel.Id = dic[@"Id"];
        pageModel.Name = dic[@"Name"];
        pageModel.Period = dic[@"Period"];
        pageModel.Public = dic[@"Public"];
        pageModel.Cover = _courseCover;
        pageModel.parentCategoryId = _pageCategoryId;
    }
    
    if (pageModel.episodesArray != nil && pageModel.episodesArray.count != 0) {
        [pageModel.episodesArray removeAllObjects];
    }
    
    for (NSDictionary *unit in dic[@"Units"]) {
        
        if(![unit isEqual:[NSNull null]]) {
            
            VideoEpisodesModel *episodes = [[VideoEpisodesModel alloc] init];
            episodes.Id = unit[@"Id"];
            episodes.Title = unit[@"Title"];
            episodes.OrderBy = (NSInteger) unit[@"OrderBy"];
            episodes.Url = unit[@"Url"];
            [autoPlayList addObject:[[NSURL alloc] initWithString:unit[@"Url"]]];
            [pageModel.episodesArray addObject:episodes];
        }
        
    }
    
    videoView.hidden = NO;
    _coverLayer.hidden = YES;

    [_v_detail fillContent:videoView videoModel:pageModel];
    if(pageModel.episodesArray.count != 0) [videoView videoToPlayList:autoPlayList];
    //[self startToPalyVideo:autoPlayList];
    //[self performSelectorInBackground:@selector(startToPalyVideo:) withObject:autoPlayList];
    
}

- (void) startToPalyVideo:(NSMutableArray *) autoPlayList {
    [NSThread sleepForTimeInterval:2];
    //[videoView videoToPlayList:autoPlayList];
    [self performSelectorOnMainThread:@selector(tempMethod:) withObject:autoPlayList waitUntilDone:NO];
}

- (void) tempMethod:(NSMutableArray *) arr {
    [videoView videoToPlayList:arr];
}


- (void) saveHistoryCache:(NSDictionary *) dic {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    NSDictionary *originDic = [appCaches objectForKey:HISTORY_CACHE_KEY];
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    [mutableDic addEntriesFromDictionary:originDic];
    
    NSMutableDictionary *kvDic = [[NSMutableDictionary alloc] init];
//    [kvDic addEntriesFromDictionary:dic];
//    [kvDic setObject:_courseCover forKey:@"Cover"];
//    [kvDic setObject:_pageCategoryId forKey:@"BelongToId"];
//    
//    [mutableDic setObject:kvDic forKey:_courseId];
//    [appCaches setObject:mutableDic forKey:HISTORY_CACHE_KEY];
//    
    [self performSelectorOnMainThread:@selector(saveLog) withObject:nil waitUntilDone:NO];
}

- (void) saveLog {
    NSLog(@"save history info %@ finished.", _courseId);
}

- (IBAction) onBackClick:(id)sender {
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [_parentVc dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
