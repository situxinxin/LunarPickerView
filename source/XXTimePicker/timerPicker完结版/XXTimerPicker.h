//
//  XXTimerPicker.h
//  GiftFaction
//
//  Created by 新新 on 15/12/23.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XXTimerPicker : UIView


//初始化对象
+(XXTimerPicker *)getChooseTimerView;
//调用数据方法
- (void)main;
//显示
- (void)show;

@property (nonatomic, strong) void (^saveBlock)(NSString * year,NSString * month , NSString * day);
@end
