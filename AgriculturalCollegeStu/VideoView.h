//
//  VideoView.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/23.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"

@interface VideoView : UIView

@property (nonatomic, weak) IBOutlet UIVisualEffectView *ve_bottomContainer;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *pv_loadingview;
@property (nonatomic, weak) IBOutlet UIButton *btn_stopAndBack;
@property (nonatomic, weak) IBOutlet UIButton *btn_fullScreen;
@property (nonatomic, weak) IBOutlet UIButton *btn_playState;
@property (nonatomic, weak) IBOutlet UISlider *slider_videoProgress;
@property (nonatomic, weak) IBOutlet UILabel *lbl_currentPlayTime;
@property (nonatomic, weak) IBOutlet UILabel *lbl_totalPlayTime;
@property(nonatomic,strong) IBOutlet UIButton *btn_tapReceiver;

@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;

@property (nonatomic, strong) UIViewController *videoPageViewController;

@property (nonatomic, strong) UIView *v_referenceBunds;

+ (instancetype) initViewLayout;

- (void) videoToPlay:(NSURL *) videoUrl;

- (void) lazyToPlay:(NSURL *) url;

- (void) videoToPlayAtIndex:(int) index forceToStop:(BOOL) foceStop;

- (void) videoToPlayList:(NSMutableArray *) videoList;

- (IBAction) btnBackClick:(id)sender;
- (IBAction) btnFullScreen:(id)sender;
- (IBAction) sliderValueChange:(id)sender;
- (IBAction) sliderTouchUpInside:(id)sender;
- (IBAction) btnPlayState:(id)sender;
- (IBAction) tapReceived:(id)sender;

@end
