//
//  农历的日历类，从公历类继承而来
//  IDJChineseCalendar.h
//
//  Created by Lihaifeng on 11-11-28, QQ:61673110.
//  Copyright (c) 2011年 www.idianjing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDJCalendar.h"
#define MONTH_COUNTS_IN_YEAR_CHINESE 13//农历的每年的月份的最多的个数
#define DAY_COUNTS_IN_YEAR_CHINESE 30//农历的每月的天数的最多的个数

//这里要声明的是不要使用NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSChineseCalendar];的方式，也就是不要使用iOS自带的农历支持，因为存在很大的问题，例如：2012年8月17日iOS经过iOS的转换之后的农历为六月三十，但实际这一年的农历六月只有二十九天，我不明白苹果为什么会犯如此低级的错误。所以本程序的农历算法使用一个C++的开源库，我对其加了一些方法ChineseCalendarDB::GetEraAndYearOfLunar()等，以便和iOS的NSCalendar相匹配。
@interface IDJChineseCalendar : IDJCalendar {
    NSArray *chineseYears;//农历年份的天干地支
    NSArray *chineseMonths;//农历月份的文字
    NSArray *chineseDays;//农历月份的每天的文字
    NSString *jiazi;//农历的甲子年份
    NSString *animal;//农历的生肖
}
@property (nonatomic, retain) NSArray * chineseYears;
@property (nonatomic, retain) NSArray * chineseMonths;
@property (nonatomic, retain) NSArray * chineseDays;
@property (nonatomic, copy) NSString *jiazi;
@property (nonatomic, copy) NSString *animal;
@end
