//
//  InputViewLeaveModel.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/19.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>


@interface InputViewLeaveModel : NSObject<YWInputViewPluginProtocol>

// 加载该插件的inputView
@property (nonatomic, weak) YWMessageInputView *inputViewRef;

@end
