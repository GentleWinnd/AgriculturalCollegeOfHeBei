//
//  HOMETextField.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/7.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "HOMETextField.h"

@implementation HOMETextField
{
    NSArray *_dataArr;
    NSMutableDictionary *_myDic;
    NSString *_myText;
}

-(instancetype)initWithFrame:(CGRect)frame andPickerTitleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSArray arrayWithArray:titleArr];
        _myDic = [[NSMutableDictionary alloc]init];
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HEIGHT -200, WIDTH, 200)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        self.inputView = pickerView;
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_dataArr[1] isKindOfClass:[NSArray class]]) {
        return _dataArr.count;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_dataArr[1] isKindOfClass:[NSArray class]]) {
        return [_dataArr[component] count];
    }
    return _dataArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_dataArr[1] isKindOfClass:[NSArray class]]) {
        return _dataArr[component][row];
    }
    return _dataArr[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_dataArr[1] isKindOfClass:[NSArray class]]) {
        [_myDic setObject:[NSString stringWithFormat:@"%zd", row] forKey:[NSString stringWithFormat:@"%zd", component]];
        _myText = @"";
        for (NSString *key in [_myDic allKeys]) {
            NSString *value = _myDic[key];
            _myText = [NSString stringWithFormat:@"%@%@", _myText, _dataArr[key.integerValue][value.integerValue]];
        }
        self.text = _myText;
    } else {
        self.text = _dataArr[row];
    }

}

@end
