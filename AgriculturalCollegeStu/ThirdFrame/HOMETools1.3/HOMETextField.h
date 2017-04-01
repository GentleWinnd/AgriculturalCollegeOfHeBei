//
//  HOMETextField.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/7.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HOMEHeader.h"
     /** HOMETools:输入框为UIPickerView的UITextField(其他属性同UITextField一样) */
@interface HOMETextField : UITextField<UIPickerViewDelegate, UIPickerViewDataSource>
     /** HOMETools:HOMETextField的初始化方法
      <参数1:TextField的Frame>
      <参数2:PickerView的各行/列标题数组(传入多维数组就是有多列)> 
      <注意:多维有BUG!由于懒、没改!>*/
-(id)initWithFrame:(CGRect)frame andPickerTitleArr:(NSArray *)titleArr;

@end
