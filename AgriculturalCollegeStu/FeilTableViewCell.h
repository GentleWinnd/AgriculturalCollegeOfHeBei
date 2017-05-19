//
//  FeilTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//
typedef NS_ENUM(NSInteger, FeilBtn) {
    FeilBtnSelected,
    FeilBtnShare,
    FeilBtnDownload,
    FeilBtnDeleted
};

typedef void(^SelectedFeilBtnType)(FeilBtn btnType,BOOL selected);

#import <UIKit/UIKit.h>
#import "DownloadProgress.h"

@interface FeilTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UILabel *feilName;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *capacitylabel;
@property (strong, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *capacityTrail;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingPace;
@property (nonatomic, strong) IBOutlet DownloadProgress *loadProgress;
@property (strong, nonatomic) IBOutlet UIButton *openBtn;

@property (copy, nonatomic) void(^openSource)(BOOL open);

@property (nonatomic, copy) NSString *url;
@property (assign, nonatomic) long long totalSize;
@property (copy, nonatomic) SelectedFeilBtnType selectedBtnType;
@property (assign, nonatomic) SourceType Stype;
@property (assign, nonatomic) NSString * SType;
@property (assign, nonatomic) BOOL loadSource;

//@property (assign, nonatomic) BOOL isDownload;
@property (strong, nonatomic) UIViewController *superViewM;
- (void)openLoadedSource;
- (void)downloadSource;

@end
