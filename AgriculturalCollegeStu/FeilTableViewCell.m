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

- (IBAction)openSourceBtnAction:(UIButton *)sender {
    
    if (self.openSource) {
        self.openSource(!sender.hidden);
    }
}


- (void)setSType:(NSString *)SType{

    self.logoImage.image = [UIImage imageNamed:[self getTheSourceIcon:SType]];
    self.Stype = [self getTheSourceType:SType];

}

- (SourceType)getTheSourceType:(NSString  *)type {
    SourceType STYpe;
    
    if ([type isEqualToString:@"Video"]) {//all range
        STYpe = SourceTypeVedio;
    } else if ([type isEqualToString:@"Image"]){//vedio range
        STYpe = SourceTypeImage;
    } else if ([type isEqualToString:@"Document"]){//image range
        STYpe = SourceTypeFile;
    } else if ([type isEqualToString:@"Flash"]){//file range
        STYpe = SourceTypeFlash;
    } else {//flash range
        STYpe = SourceTypeOther;
    }
    
    return STYpe;
}

- (NSString *)getTheSourceIcon:(NSString *)type {
    
    NSString * STYpe;
    
    if ([type isEqualToString:@"Video"]) {//all range
        STYpe = @"mov";
    } else if ([type isEqualToString:@"Image"]){//vedio range
        STYpe = @"jpeg";
    } else if ([type isEqualToString:@"Document"]){//image range
        STYpe = @"text";
    } else if ([type isEqualToString:@"Flash"]){//file range
        STYpe = @"fla";
    } else if ([type isEqualToString:@"Other"]){//flash range
        STYpe = @"zip";
    }
    return STYpe;
}


- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag == 1) {//下载
        self.selectedBtnType(FeilBtnDownload,sender.selected);
        [self downloadBtnAction];
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
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:url];
    NSString *loadedProgress = [NSString stringWithFormat:@"%.0f%%",receipt.progress.fractionCompleted*100];
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:receipt.filePath error:nil].fileSize;
    
  if (receipt.state == MCDownloadStateCompleted) {
//        [self.button setTitle:@"播放" forState:UIControlStateNormal];
        self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"deletebtn"] forState:UIControlStateNormal];

  }else if (receipt.state == MCDownloadStateDownloading) {
      //        [self.button setTitle:@"停止" forState:UIControlStateNormal];
      [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
      self.capacityTrail.text = loadedProgress;
      [self downloadSource];
  } else if (receipt.state == MCDownloadStateFailed) {
//        [self.button setTitle:@"重新下载" forState:UIControlStateNormal];
        self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];

    }else if (receipt.state == MCDownloadStateSuspened) {
//        [self.button setTitle:@"继续下载" forState:UIControlStateNormal];
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];

    }else if (receipt.state == MCDownloadStateWillResume) {
//        [self.button setTitle:@"等待下载" forState:UIControlStateNormal];
        self.capacityTrail.text = loadedProgress;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];

    }else {
//        [self.button setTitle:@"下载" forState:UIControlStateNormal];
        self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];
    }
    
}


#pragma mark - 点击事件

- (void)downloadBtnAction {
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.url];
    
    if (receipt.state == MCDownloadStateCompleted) {//完成
        self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"deletebtn"] forState:UIControlStateNormal];
        if (self.selectedBtnType) {
            self.selectedBtnType(FeilBtnDeleted, YES);
        }
        
    }else if (receipt.state == MCDownloadStateFailed) {//失败时重新开始下载
        [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        [self downloadSource];
        
    }else if (receipt.state == MCDownloadStateDownloading) {//正在下载时点击停止下载
        [self.downLoadBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
        
    }else if (receipt.state == MCDownloadStateSuspened) {//挂起时点击继续下载
        [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        [self downloadSource];
        
    }else if (receipt.state == MCDownloadStateWillResume) {//等待时点击停止下载
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_arrow"] forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] removeWithDownloadReceipt:receipt];
        
    }else if (receipt.state == MCDownloadStateNone) {//开始下载
        [self.downLoadBtn setImage:[UIImage imageNamed:@"loadingbtn"] forState:UIControlStateNormal];
        [self downloadSource];
    }
    
}

- (void)downloadSource {

    [[MCDownloadManager defaultInstance] downloadFileWithURL:self.url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                            if (downloadProgress.fractionCompleted>1) {
//                                                                self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
//                                                                [self.downLoadBtn setImage:[UIImage imageNamed:@"deletebtn"] forState:UIControlStateNormal];
//                                                            } else {
                                                             self.capacityTrail.text = [NSString stringWithFormat:@"%.0f%%",downloadProgress.fractionCompleted*100];
//                                                            }
                                                           
                                                        });
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         self.capacityTrail.text = [self caculateSourceSize:self.totalSize];
                                                        [self.downLoadBtn setImage:[UIImage imageNamed:@"deletebtn"] forState:UIControlStateNormal];

                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         [self.downLoadBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
                                                     }];
    
}

- (void)getLoadReceipt {


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

#pragma mark - open loaded source

- (void)openLoadedSource {
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.url];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (receipt.state == MCDownloadStateCompleted) {
        if (self.Stype == SourceTypeVedio) {
            MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
            [vc presentViewController:mpc animated:YES completion:nil];
        } else if (self.Stype == SourceTypeFile) {
            OpenFileViewController *openFile = [[OpenFileViewController alloc] init];
            openFile.filePath = receipt.filePath;
            [_superViewM.navigationController pushViewController:openFile animated:YES];
        } else if (self.Stype == SourceTypeImage) {
            OpenImageView *imageView =  [[OpenImageView alloc] initWithFrame:_superViewM.view.bounds];
            imageView.filePath = receipt.filePath;
            [UIView animateWithDuration:0.02 animations:^{
                [_superViewM.view addSubview:imageView];
            }];
        } else {
            [Progress progressShowcontent:@"暂不支持查看此类文件"];
        }
    } else {
        [Progress progressShowcontent:@"未下载资源"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
