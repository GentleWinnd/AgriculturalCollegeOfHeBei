//
//  MBProgressManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/4.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "MBProgressManager.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface MBProgressManager()
@property (strong, nonatomic) MBProgressHUD *MBHUd;

@end
@implementation MBProgressManager

- (instancetype)init {
    self = [super init];
    if (self) {
//        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        View.backgroundColor = [UIColor clearColor];
//        [self.showView addSubview:View];
        if (self.showView == nil) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            self.showView = window;
        }

        
    }
    return self;
}

- (void)showProgress {
    switch (self.progressType) {
        case MBProgressTypeLittleChrysanthemum:
            [self indeterminateExample];
            break;
        case MBProgressTypeWithLoadingTitle:
            [self loadingWithTitleProgress:nil];
            break;

        default:
            break;
    }
}

- (void)hiddenProgress {
    // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the HUD added to the
    // view hierarchy.
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        
//        // Do something useful in the background
//        [self doSomeWork];
//        
//        // IMPORTANT - Dispatch back to the main thread. Always access UI
//        // classes (including MBProgressHUD) on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_MBHUd hideAnimated:YES];
        });
//    });


}

#pragma mark - Examples

//no text progress
- (void)indeterminateExample {
    // Show the HUD on the root view (self.view is a scrollable table view and thus not suitable,
    // as the HUD would move with the content as we scroll).
    _MBHUd = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
}

- (void)loadingWithTitleProgress:(NSString *)title {
    _MBHUd = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    NSString *loading = title == nil ?@"Loading...":title;
    // Set the label text.
    _MBHUd.label.text = NSLocalizedString(loading, @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MBHUd hideAnimated:YES];
        });
    });
}

- (void)detailsLabelExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    // Set the details label text. Let's make it multiline this time.
    hud.detailsLabel.text = NSLocalizedString(@"Parsing data\n(1/1)", @"HUD title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)windowExample {
    // Covers the entire screen. Similar to using the root view controller view.
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView.window animated:YES];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)determinateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)determinateNSProgressExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Set up NSProgress
    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
    hud.progressObject = progressObject;
    
    // Configure a cancel button.
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgressObject:progressObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)annularDeterminateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)barDeterminateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the bar determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)customViewExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
    
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)cancelationExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Configure the button.
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)modeSwitchingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)networkingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    [self doSomeNetworkWorkWithProgress];
}

- (void)dimBackgroundExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)colorExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}

- (void)doSomeWorkWithProgress {
//    self.canceled = NO;
//    // This just increases the progress indicator in a loop.
//    float progress = 0.0f;
//    while (progress < 1.0f) {
//        if (self.canceled) break;
//        progress += 0.01f;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Instead we could have also passed a reference to the HUD
//            // to the HUD to myProgressTask as a method parameter.
//            [MBProgressHUD HUDForView:self.showView].progress = progress;
//        });
//        usleep(50000);
//    }
}

- (void)doSomeWorkWithMixedProgress {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.showView];
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title");
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(2);
}

- (void)doSomeNetworkWorkWithProgress {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

- (void)cancelWork:(id)sender {
   // self.canceled = YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MBExample *example = self.examples[indexPath.section][indexPath.row];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    [self performSelector:example.selector];
//#pragma clang diagnostic pop
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    });
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.showView];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.showView];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}



@end
