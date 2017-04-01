//
//  FeilTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "FeilTableViewCell.h"
#import "MCDownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OpenFileViewController.h"
#import "OpenImageView.h"

@implementation FeilTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBtn.layer.borderWidth = 1;
    self.selectedBtn.layer.cornerRadius = 8;
    self.selectedBtn.layer.borderColor = RulesLineColor_LightGray.CGColor;
    
}

- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag == 1) {//下载
        self.selectedBtnType(FeilBtnDownload,sender.selected);
        if (self.isDownload) {
            [self downloadBtnAction];
        }
    } else if (sender.tag == 2) {//分享
        self.selectedBtnType(FeilBtnShare,sender.selected);
    } else {//选中
        self.selectedBtnType(FeilBtnSelected,sender.selected);
        sender.selected = !sender.selected;
        if (sender.selected) {
            [sender setBackgroundColor:MainThemeColor_Blue];
        } else {
            [sender setBackgroundColor:[UIColor clearColor]];
        }
    }
    
}

- (void)setUrl:(NSString *)url {
    _url = url;
 //   self.feilName.text = url.lastPathComponent;
//    self.loadProgress.progress = 0;
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:url];
    if (self.isDownload == NO) {
        receipt.totalSize = self.totalSize;
        receipt.sourceType = _Stype;
        return;
    }
    
    NSString *loadedProgress = [NSString stringWithFormat:@"%.2f%%",receipt.progress.fractionCompleted];
    if (receipt.state == MCDownloadStateDownloading) {//正在下载中
        self.capacityTrail.text = loadedProgress;
        if ([MCDownloadManager defaultInstance].tasks.count) {
            [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        } else {
            [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];
        }
        if (_isDownload) {
            [self downloadWithUrl:url];
        } else {
            [[MCDownloadManager defaultInstance] resumeWithDownloadReceipt:receipt];
        }
    }else if (receipt.state == MCDownloadStateCompleted) {//下载完成
        self.capacityTrail.text = [self caculateSourceSize:receipt.totalBytesWritten];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];

    }else if (receipt.state == MCDownloadStateFailed) {//下载失败
        self.capacityTrail.text = [self caculateSourceSize:receipt.totalBytesWritten];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];

    }else if (receipt.state == MCDownloadStateSuspened) {//下载暂停
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];

    }else if (receipt.state == MCDownloadStateWillResume) {//等待下载
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
        if (_isDownload) {
            [self downloadWithUrl:url];
        }
    }else {
        self.capacityTrail.text = [self caculateSourceSize:receipt.totalSize];

    }
}

#pragma mark - 点击事件

- (void)downloadBtnAction {
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.url];
    NSString *loadedProgress = [NSString stringWithFormat:@"%.2f%%",((float) receipt.totalBytesWritten)/((float)receipt.totalSize)*100];

    if (receipt.state == MCDownloadStateCompleted) {//完成
        if (_isDownload) {
            UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;

            if (receipt.sourceType == SourceTypeVedio) {
                MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
                [vc presentViewController:mpc animated:YES completion:nil];
                [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
            } else if (receipt.sourceType == SourceTypeFile) {
                OpenFileViewController *openFile = [[OpenFileViewController alloc] init];
                openFile.filePath = receipt.filePath;
                [_superViewM.navigationController pushViewController:openFile animated:YES];
            } else if (receipt.sourceType == SourceTypeImage) {
                OpenImageView *imageView =  [[OpenImageView alloc] initWithFrame:_superViewM.view.bounds];
                imageView.filePath = receipt.filePath;
                [UIView animateWithDuration:0.02 animations:^{
                    [_superViewM.view addSubview:imageView];
                }];
            } else {
                [Progress progressShowcontent:@"暂不支持查看此类文件"];
            }

        }
       
        
        self.capacityTrail.text = [self caculateSourceSize:receipt.totalSize];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateFailed) {//失败时重新开始下载
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];

        [self downloadWithUrl:self.url];
    }else if (receipt.state == MCDownloadStateDownloading) {//正在下载时点击停止下载
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateSuspened) {//挂起时点击继续下载
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        
        [self downloadWithUrl:receipt.url];
    }else if (receipt.state == MCDownloadStateWillResume) {//等待时点击停止下载
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] removeWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateNone) {//开始下载
        self.capacityTrail.text = loadedProgress;
          [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        [self downloadWithUrl:self.url];
    }
    
}

- (void)downloadWithUrl:(NSString *)url {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.capacityTrail.text = [NSString stringWithFormat:@"%.2f%%",downloadProgress.fractionCompleted];
                                                        });
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {

                                                        [self.downLoadBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];

                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         [self.downLoadBtn setImage:[UIImage imageNamed:@"puasebtn"] forState:UIControlStateNormal];
                                                     }];
    
}

#pragma mark - caculate source size

- (NSString *)caculateSourceSize:(NSInteger)size {
    NSString *sizeStr;
    if (size<1024) {//Bty
        sizeStr = [NSString stringWithFormat:@"%tu B",size];
    } else if (size <pow(1024,2)) {//KB
        sizeStr = [NSString stringWithFormat:@"%.2f K",size/1024.00];
    } else if (size <pow(1024, 3)) {//MB
        sizeStr = [NSString stringWithFormat:@"%.2f M",size/pow(1024.00, 2)];
    } else if (size <pow(1024, 4)) {//GB
        sizeStr = [NSString stringWithFormat:@"%.2f G",size/pow(1024.00, 3)];
    }
    return sizeStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
