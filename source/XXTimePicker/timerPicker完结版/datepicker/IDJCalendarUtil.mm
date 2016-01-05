//
//  IDJCalendarUtil.mm
//  本文件使用了C++混编，所以扩展名为.mm
//
//  Created by lihaifeng on 11-11-30, QQ:61673110.
//  Copyright (c) 2011年 www.idianjing.com. All rights reserved.
//

#import "IDJCalendarUtil.h"
#import "SolarDate.h"
#import "ChineseDate.h"

@implementation IDJCalendarUtil
+ (NSDateComponents *)toSolarDateWithYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day {
    ChineseDate chineseDate = ChineseDate(_year, [IDJCalendarUtil monthFromMineToCppWithYear:_year month:_month], _day);
    SolarDate solarDate=chineseDate.ToSolarDate();
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=solarDate.GetYear();
    dc.month=solarDate.GetMonth();
    dc.day=solarDate.GetDay();
    return dc;
}

+ (NSDateComponents *)toChineseDateWithYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day {
    SolarDate solarDate=SolarDate(_year, [_month intValue], _day);
    ChineseDate chineseDate;
    solarDate.ToChineseDate(chineseDate);
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=chineseDate.GetYear();
    dc.month=chineseDate.GetMonth();
    dc.day=chineseDate.GetDay();
    return dc;
}

+ (int)weekDayWithSolarYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day {
    SolarDate solarDate=SolarDate(_year, [_month intValue], _day);
    return solarDate.ToWeek();
}

+ (int)weekDayWithChineseYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day {
    NSDateComponents *dc=[IDJCalendarUtil toSolarDateWithYear:_year month:_month day:_day];
    return [IDJCalendarUtil weekDayWithSolarYear:dc.year month:[NSString stringWithFormat:@"%ld", (long)dc.month] day:dc.day];
}

+ (NSUInteger)monthFromMineToCppWithYear:(NSUInteger)_year month:(NSString *)_month {
    int runMonth=ChineseCalendarDB::GetLeapMonth(_year);
    NSArray *array=[_month componentsSeparatedByString:@"-"];
    int month_=0;
    if ([[array objectAtIndex:0]isEqualToString:CHINESE_MONTH_LUNAR]) {
        month_=[[array objectAtIndex:1]intValue]+1;
    } else {
        if (runMonth!=0&&[[array objectAtIndex:1]intValue]>runMonth)
            month_=[[array objectAtIndex:1]intValue]+1;
        else 
            month_=[[array objectAtIndex:1]intValue];
    }
    return month_;
}

+ (NSString *)monthFromCppToMineWithYear:(NSUInteger)_year month:(NSUInteger)_month {
    int run=ChineseCalendarDB::GetLeapMonth(_year);
    if (run==0) {
        return [NSString stringWithFormat:@"%@-%d", CHINESE_MONTH_NORMAL, _month];
    } else {
        if (_month==run+1) {
            return [NSString stringWithFormat:@"%@-%d", CHINESE_MONTH_LUNAR, _month-1];
        } else if(_month<=run) {
            return [NSString stringWithFormat:@"%@-%d", CHINESE_MONTH_NORMAL, _month];
        } else {
            return [NSString stringWithFormat:@"%@-%d", CHINESE_MONTH_NORMAL, _month-1];
        }
    }
}

+ (NSString *)animalWithJiazi:(NSUInteger)jiazi {
    NSString *animal=nil;
    switch (jiazi%12) {
        case 1:{
            animal=@"鼠";
            break;
        }
        case 2:{
            animal=@"牛";
            break;
        }
        case 3:{
            animal=@"虎";
            break;
        }
        case 4:{
            animal=@"兔";
            break;
        }
        case 5:{
            animal=@"龙";
            break;
        }
        case 6:{
            animal=@"蛇";
            break;
        }
        case 7:{
            animal=@"马";
            break;
        }
        case 8:{
            animal=@"羊";
            break;
        }
        case 9:{
            animal=@"猴";
            break;
        }
        case 10:{
            animal=@"鸡";
            break;
        }
        case 11:{
            animal=@"狗";
            break;
        }
        case 0:{
            animal=@"猪";
            break;
        }
        default:
            break;
    }
    return animal;
}

+ (void)jiaziWithYear:(NSUInteger)_year outEra:(int *)era outJiazi:(int *)jiazi {
    std::pair<int, int> p = ChineseCalendarDB::GetEraAndYearOfLunar(_year);
    *era=p.first;
    *jiazi=p.second;
}

+ (NSMutableDictionary *)jieqiWithYear:(NSUInteger)_year {
    NSArray *arrayJieqi=[NSArray arrayWithObjects:@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", nil];
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]initWithCapacity:24];
    for (int i=1; i<=24; i++) {
        int day = ChineseCalendarDB::GetSolarTerm(_year, i);
        div_t dt=div(i, 2);
        NSDateComponents *dc=[IDJCalendarUtil toChineseDateWithYear:_year month:[NSString stringWithFormat:@"%d", dt.rem+dt.quot] day:day];
        NSString *month=[IDJCalendarUtil monthFromCppToMineWithYear:dc.year month:dc.month];
        [dic setObject:[arrayJieqi objectAtIndex:i-1] forKey:[NSString stringWithFormat:@"%@-%ld", month, (long)dc.day]];
    }
    return dic;
}



@end
