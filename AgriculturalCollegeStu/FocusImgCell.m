//
//  FocusImgCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/29.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FocusImgCell.h"
#import "VideoPageModel.h"
#import "UIImageView+AFNetworking.h"


@interface  FocusImgCell()

@end

@implementation FocusImgCell
{
    
}

@synthesize imgv = _imgv;

+ (instancetype) initViewLayout {
    
    FocusImgCell * view = [[[NSBundle mainBundle] loadNibNamed:@"focus_view_2_cell" owner:nil options:nil] lastObject];
    
    return view;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void) setImageUrl:(NSString *) cover {
    
    NSURL *coverURL = [[NSURL alloc] initWithString:cover];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:coverURL];
    
    [_imgv setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"logo_setting"] success:
    ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"success");
        [_imgv setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"load img failed");
    }];
}


@end
