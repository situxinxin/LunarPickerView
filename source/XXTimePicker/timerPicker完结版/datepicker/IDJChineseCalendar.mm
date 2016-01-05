//
//  IDJChineseCalendar.mm
//  本文件使用了C++混编，所以扩展名为.mm
//
//  Created by Lihaifeng on 11-11-28, QQ:61673110.
//  Copyright (c) 2011年 www.idianjing.com. All rights reserved.
//

#import "IDJChineseCalendar.h"
#import "SolarDate.h"
#import "ChineseDate.h"
#import "IDJCalendarUtil.h"

@implementation IDJChineseCalendar
@synthesize chineseYears, chineseMonths, chineseDays, jiazi, animal;

- (id)initWithYearStart:(NSUInteger)start end:(NSUInteger)end {
    self=[super initWithYearStart:start end:end];
    if (self) {
        //从父类的公历数据创建C++的公历类SolarDate的对象
        SolarDate solarDate=SolarDate([self.year intValue], [self.month intValue], [self.day intValue]);
        ChineseDate chineseDate;
        //从公历对象转为农历对象
        solarDate.ToChineseDate(chineseDate);
        //获取当年的公历年份对应的农历的年代和甲子年份
        std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar([self.year intValue]);
        
        //设置当前时间的农历日期字段
        self.era=[NSString stringWithFormat:@"%d", p.first];
        self.year=[NSString stringWithFormat:@"%d", chineseDate.GetYear()];
        self.jiazi=[NSString stringWithFormat:@"%d", p.second];
        self.animal=[IDJCalendarUtil animalWithJiazi:[self.jiazi intValue]];
        //获取当前年份的闰月的月份，没有闰月返回0
        self.month=[IDJCalendarUtil monthFromCppToMineWithYear:chineseDate.GetYear() month:chineseDate.GetMonth()];
        self.day=[NSString stringWithFormat:@"%d", chineseDate.GetDay()];
        
        self.chineseYears=[NSArray arrayWithObjects:@"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                           @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                           @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                           @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                           @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                           @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];
        self.chineseMonths=[NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", 
                            @"九月", @"十月", @"冬月", @"腊月", nil];
        self.chineseDays=[NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", 
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return self;
}

- (NSMutableArray *)yearsInRange {
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:yearEnd-yearStart+1];
    for (int i=yearStart; i<=yearEnd; i++) {
        SolarDate solarDate=SolarDate(i, 1, 1);
        ChineseDate chineseDate;
        solarDate.ToChineseDate(chineseDate);
        std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar(i);
        //我们要把农历的年份显示为甲寅年这样的文字，所以years容器中应该存储甲子年份，但是农历的甲子年份60年循环一次，无法与公历年份对应，所以我们额外存储年代、公历年份
        [array addObject:[NSString stringWithFormat:@"%d-%d-%d", p.first, p.second, i]];
    }
    return array;
}

- (NSMutableArray *)monthsInYear:(NSUInteger)_year {
    int monthCounts=ChineseCalendarDB::GetYearMonths(_year);
    NSMutableArray *myMonths=[[NSMutableArray alloc]initWithCapacity:monthCounts];
    for (int i=1; i<=monthCounts; i++) {
        [myMonths addObject:[IDJCalendarUtil monthFromCppToMineWithYear:_year month:i]];
    }
    return myMonths;
}

- (NSMutableArray *)daysInMonth:(NSString *)_month year:(NSUInteger)_year {
    //由于参数_month是a-1、b-5这样的文字，我们需要还原为这个C++算法要求的1 - 13的数字
    int month_=[IDJCalendarUtil monthFromMineToCppWithYear:_year month:_month];
    int dayCounts=ChineseCalendarDB::GetMonthDays(_year, month_);
    NSMutableArray *myDays=[[NSMutableArray alloc]initWithCapacity:DAY_COUNTS_IN_YEAR_CHINESE];
    for (int i=1; i<=dayCounts; i++) {
        [myDays addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return myDays;
}

@end
