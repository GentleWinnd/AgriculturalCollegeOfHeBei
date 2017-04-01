//
//  VideoView.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/23.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoView.h"
#import "VideoPageController.h"
#import "Header_key.h"

@interface VideoView ()

@end

@implementation VideoView
{
    float originX;
    float originY;
    float originWidth;
    float originHeight;
    
    NSMutableArray *autoPlayList;
    BOOL autoToNext;
    BOOL isFoceToStop;
    int currentPlayerIndex;
    
    NSTimer *updateVideoPregressTimer;
    NSTimer *hiddenControllerBarTimer;
    NSTimer *lazyPlayTimer;
    
    long long timerCount;
    long long maxVideoDuration;
    BOOL fullScreenWanted;
    BOOL pauseWanted;
    BOOL hiddenControllerBarWanted;

    NSMutableArray *lazyPlayList;
}

@synthesize videoPlayer = _videoPlayer;
@synthesize ve_bottomContainer = _ve_bottomContainer;
@synthesize pv_loadingview = _pv_loadingview;
@synthesize btn_stopAndBack = _btn_stopAndBack;
@synthesize btn_fullScreen = _btn_fullScreen;
@synthesize btn_playState = _btn_playState;
@synthesize videoPageViewController = _parentVc;
@synthesize slider_videoProgress = _slider_videoProgress;
@synthesize lbl_currentPlayTime = _lbl_currentPlayTime;
@synthesize lbl_totalPlayTime = _lbl_totalPlayTime;
@synthesize btn_tapReceiver = _btn_tapReceiver;

+ (instancetype) initViewLayout {
    
    VideoView *mySelf = [[[NSBundle mainBundle] loadNibNamed:@"video_view" owner:nil options:nil]  lastObject];
    
    return mySelf;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    //[self initMediaPlayer];
    
    lazyPlayList = [NSMutableArray array];
    
    [_btn_tapReceiver setTitle:@"" forState:UIControlStateNormal];
    
    fullScreenWanted = YES;
    pauseWanted = YES;
    hiddenControllerBarWanted = YES;
    isFoceToStop = NO;
    autoToNext = NO;
    timerCount = 0;
    currentPlayerIndex = 0;
    [_pv_loadingview startAnimating];
    _slider_videoProgress.minimumValue = 0;
    
//    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(reciveNotice:) name:NOTICE_PLAYER_TO_CHANGE object:nil];
}


- (void)reciveNotice:(NSNotification *) notification {
    
    NSString *indexStr = [notification.userInfo objectForKey:@"index"];
    if(currentPlayerIndex != indexStr.intValue) {
        [self videoToPlayAtIndex:indexStr.intValue forceToStop: YES];
    }
    
}

- (void) layoutSubviews {
    
    originX = self.frame.origin.x;
    originY = self.frame.origin.y;
    originWidth = self.frame.size.width;
    originHeight = self.frame.size.height;
}

- (void) initMediaPlayer {
    
    if(_videoPlayer != nil) {
        [_videoPlayer.view removeFromSuperview];
        _videoPlayer = nil;
    }
    
    _videoPlayer = [[MPMoviePlayerController alloc] init];
    
    _videoPlayer.view.frame = self.bounds;
    [self addSubview:_videoPlayer.view];
    
    _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _videoPlayer.controlStyle = MPMovieControlStyleNone;
    _videoPlayer.shouldAutoplay = YES;
    
    [self bringSubviewToFront:_pv_loadingview];
    [self bringSubviewToFront:_ve_bottomContainer];
    [self bringSubviewToFront:_btn_tapReceiver];
    [self bringSubviewToFront:_btn_stopAndBack];
    
    [self addNotification];
}

- (void)addNotification {
    
    // 1.添加播放状态的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    // 2。添加完成的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // 3.全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifFullScreenToPlay) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    //准备好了开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifPreparedToPlay) name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifPreparedToPlay) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

}

- (void) videoToPlayList:(NSMutableArray *)videoList {
    
    if(autoPlayList != nil) {
        [autoPlayList removeAllObjects];
        autoPlayList = nil;
    }
    
    autoPlayList = videoList;
    autoToNext = YES;
    currentPlayerIndex = 0;
    
    
    NSURL *vurl = [autoPlayList objectAtIndex:currentPlayerIndex];
    //[self videoToPlay:vurl];
    [self lazyToPlay:vurl];
}

- (void) videoToPlayAtIndex:(int) index forceToStop:(BOOL) foceStop {
    isFoceToStop = foceStop;
    currentPlayerIndex = index;
    if(_videoPlayer != nil) {
        [_videoPlayer pause];
        [_videoPlayer stop];
    }
    
    NSURL *vurl = [autoPlayList objectAtIndex:currentPlayerIndex];
    //[self videoToPlay:vurl];
    [self lazyToPlay:vurl];
}

- (void) lazyToPlay:(NSURL *) url {
    
    [lazyPlayList addObject: url];
    if(lazyPlayTimer != nil) {
        [lazyPlayTimer invalidate];
        lazyPlayTimer = nil;
    }
    
    lazyPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getUrlToPlay) userInfo:nil repeats:NO];
}

- (void) getUrlToPlay {
    [self videoToPlay:[lazyPlayList lastObject]];
    [lazyPlayList removeAllObjects];
}

- (void) videoToPlay:(NSURL *) videoUrl {
    
    NSLog(@"video url : %@", videoUrl);
    [self performSelectorInBackground:@selector(getVideoDurationWidthURL:) withObject:videoUrl];
    
    [self initMediaPlayer];
    
    [_videoPlayer setContentURL:videoUrl];
    [_videoPlayer prepareToPlay];
    
    if(hiddenControllerBarTimer != nil) {
        [hiddenControllerBarTimer invalidate];
        hiddenControllerBarTimer = nil;
    }
    
    hiddenControllerBarTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hiddenControllerBar) userInfo:nil repeats:NO];
}

- (void) readlyTohiddenControllerBar {
    
    hiddenControllerBarTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hiddenControllerBar) userInfo:nil repeats:NO];
}

- (void) videoStateChanged {
    
    /*
    MPMoviePlaybackStateStopped
    MPMoviePlaybackStatePlaying
    MPMoviePlaybackStatePaused
    MPMoviePlaybackStateInterrupted
    MPMoviePlaybackStateSeekingForward
    MPMoviePlaybackStateSeekingBackward
     */
    
    switch (_videoPlayer.playbackState) {
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"开始播放");
            if(updateVideoPregressTimer == nil) {
                updateVideoPregressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateVideoProgressValue) userInfo:nil repeats:YES];
            }
            _pv_loadingview.hidden = YES;
            [_btn_playState setImage:[UIImage imageNamed:@"pause.png"]  forState:UIControlStateNormal];
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            _pv_loadingview.hidden = NO;
            [updateVideoPregressTimer invalidate];
            updateVideoPregressTimer = nil;
            [_btn_playState setImage:[UIImage imageNamed:@"play.png"]  forState:UIControlStateNormal];
            break;
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"中断");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止");
            timerCount = 0;
            _pv_loadingview.hidden = NO;
            [updateVideoPregressTimer invalidate];
            updateVideoPregressTimer = nil;
            [_btn_playState setImage:[UIImage imageNamed:@"play.png"]  forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction) btnBackClick:(id)sender {
    [_videoPlayer pause];
    _videoPlayer = nil;
    [_parentVc dismissViewControllerAnimated:NO completion:nil];
}

- (void) videoFinished {
//    NSLog(@"video finished ...");
//    if(isFoceToStop) return;
//    
//    if(autoToNext) {
//        timerCount = 0;
//        [updateVideoPregressTimer invalidate];
//        updateVideoPregressTimer = nil;
//        
//        currentPlayerIndex ++;
//        if(currentPlayerIndex >= autoPlayList.count) currentPlayerIndex = 0;
//        NSURL *vurl = [autoPlayList objectAtIndex:currentPlayerIndex];
//        [self videoToPlay:vurl];
//    }
    
}

- (void) ifFullScreenToPlay {
    //TODO
}

- (void) ifPreparedToPlay {
    //TODO
}

- (void) getVideoDurationWidthURL:(NSURL *) videoUrl {

    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts];  // 初始化视频媒体文件
    long long totalSecond = 0;
    totalSecond = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    NSString *ts = [NSString stringWithFormat:@"%lld", totalSecond];
    [self performSelectorOnMainThread:@selector(setVideoDuration:) withObject:ts waitUntilDone:NO];
}

- (void) setVideoDuration:(NSString *) ts{
    
    long long minute = 0, second = 0, totalSecond = 0;
    totalSecond = ts.longLongValue;
    maxVideoDuration = totalSecond;
    _slider_videoProgress.maximumValue = totalSecond;
    _slider_videoProgress.minimumValue = 0;
    
    if (totalSecond >= 60) {
        long long index = totalSecond / 60;
        minute = index;
        second = totalSecond - index*60;
        
        [_lbl_totalPlayTime setText:[NSString stringWithFormat:@"%lld'%lld\"",  minute, second]];
    } else {
        
        [_lbl_totalPlayTime setText:[NSString stringWithFormat:@"%lld\"", second]];
    }
}

- (void) setTotalPlayTime:(NSArray *) arr {
    
    long long totalDuration = [((NSString *)[arr objectAtIndex:0]) longLongValue];
    
    maxVideoDuration = totalDuration;
    _slider_videoProgress.maximumValue = totalDuration;
    _slider_videoProgress.minimumValue = 0;
    
    if(arr.count > 2) {
        NSString *m = [arr objectAtIndex:1];
        NSString *s = [arr objectAtIndex:2];
        [_lbl_totalPlayTime setText:[NSString stringWithFormat:@"%@'%@\"",  m, s]];
    } else {
        NSString *s = [arr objectAtIndex:1];
        [_lbl_totalPlayTime setText:[NSString stringWithFormat:@"%@\"", s]];
    }
    
}

- (IBAction) sliderValueChange:(id)sender {
    
    UISlider* slider = (UISlider*) sender;
    
    [updateVideoPregressTimer invalidate];
    long long minute = 0, totalSecond = 0, second = 0;
    totalSecond = slider.value;
    timerCount = totalSecond;
    
    if (totalSecond >= 60) {
        long long index = totalSecond / 60;
        minute = index;
        second = totalSecond - index*60;
        [_lbl_currentPlayTime setText:[NSString stringWithFormat:@"%lld'%lld\"", minute, second]];
    } else {
        [_lbl_currentPlayTime setText:[NSString stringWithFormat:@"%lld\"", totalSecond]];
    }
    
//    [_videoPlayer setCurrentPlaybackTime:totalSecond];
    
}

- (IBAction) sliderTouchUpInside:(id)sender {
    
    UISlider* slider = (UISlider*) sender;
    long long totalSecond = slider.value;
    [_videoPlayer setCurrentPlaybackTime:totalSecond];
    updateVideoPregressTimer = nil;
    updateVideoPregressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateVideoProgressValue) userInfo:nil repeats:YES];
}

- (void) updateVideoProgressValue {
    
    long long minute = 0, totalSecond = 0, second = 0;
    totalSecond = ++ timerCount;
    
    if(timerCount >= maxVideoDuration) {
        totalSecond = maxVideoDuration;
    }
    
    [_slider_videoProgress setValue:totalSecond animated:NO];
    
    if (totalSecond >= 60) {
        long long index = totalSecond / 60;
        minute = index;
        second = totalSecond - index*60;
        [_lbl_currentPlayTime setText:[NSString stringWithFormat:@"%lld'%lld\"", minute, second]];
    } else {
        [_lbl_currentPlayTime setText:[NSString stringWithFormat:@"%lld\"", totalSecond]];
    }

}

- (void) hiddenControllerBar {

    hiddenControllerBarWanted = NO;
    _ve_bottomContainer.hidden = YES;

}

- (IBAction) btnFullScreen:(id)sender {
    
    if(fullScreenWanted) {
        fullScreenWanted = NO;
        [_btn_fullScreen setImage:[UIImage imageNamed:@"nfc.png" ]  forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.bounds = CGRectMake(originX, originY, HEIGHT, WIDTH);
        self.center = CGPointMake(WIDTH / 2 - 20, HEIGHT / 2);
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        _btn_stopAndBack.hidden = YES;
        
    } else {
        fullScreenWanted = YES;
        [_btn_fullScreen setImage:[UIImage imageNamed:@"fc.png" ]  forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.transform = CGAffineTransformMakeRotation(0);
        self.bounds = _v_referenceBunds.bounds;
        self.center = CGPointMake(WIDTH / 2, self.bounds.size.height / 2 + 20);
        _btn_stopAndBack.hidden = NO;
        
    }
    
}

- (IBAction) btnPlayState:(id)sender {
    
    if(pauseWanted) {
        pauseWanted = NO;
        [_videoPlayer pause];
        [_btn_playState setImage:[UIImage imageNamed:@"play.png"]  forState:UIControlStateNormal];
    } else {
        pauseWanted = YES;
        [_videoPlayer play];
        [_btn_playState setImage:[UIImage imageNamed:@"pause.png"]  forState:UIControlStateNormal];
    }
}

- (IBAction) tapReceived:(id)sender {
    
    if(!hiddenControllerBarWanted) {
    
        _ve_bottomContainer.hidden = NO;
        hiddenControllerBarWanted = YES;
        hiddenControllerBarTimer = nil;
        hiddenControllerBarTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hiddenControllerBar) userInfo:nil repeats:NO];
        
    }

}


@end
