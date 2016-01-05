/**
 * ChineseCalendarDB.h
 * @Author   Tu Yongce <yongce@126.com>
 * @Created  2008-12-13 
 * @Modified 2011-11-28 Lihaifeng Add funtion GetEraAndYear(), QQ:61673110, Company:www.idianjing.com.
 * @Version  0.1
 */

#ifndef CHINESE_CALENDAR_DB_H_INCLUDED
#define CHINESE_CALENDAR_DB_H_INCLUDED

#ifdef _MSC_VER
#pragma once
#endif

#include <exception>
#include <stdint.h>
#include <utility>

class ChineseCalendarDB
{
private:
    
    static const int YEAR_BASE = 1901;   // 阴历数据的起始年
    static const int YEAR_NUM  = 150;    // 阴历数据的年数
    
    static const uint8_t  sm_leapMonth[YEAR_NUM];       // 每年的闰月月份
    static const uint16_t sm_monthDay[YEAR_NUM];        // 每年的所有月的月天数
    static const uint8_t  sm_solarTerm[YEAR_NUM][12];   // 每年的二十四节气数据
    
public:
    // 当表示参数无效时抛出的异常类型
    class InvalidParamter: public std::exception
    {
    };
    
public:
    /*
     * 查询农历某年的闰月
     * @param year: 要查询的年份，有效取值范围1901~2050
     * @return: 返回该年的闰月（如果没有闰月则返回0）
     *          如果参数year不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static int GetLeapMonth(int year)
    {
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        return sm_leapMonth[year - YEAR_BASE];
    }
    
    /*
     * 查询农历某年的月数
     * @param year: 要查询的年份，有效取值范围1901~2050
     * @return: 返回该年的月数（如果没有闰月则返回12，有闰月返回13）
     *          如果参数year不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static int GetYearMonths(int year)
    {
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        return sm_leapMonth[year - YEAR_BASE] ? 13 : 12;
    }
    
    /*
     * 查询农历某年某月的天数
     * @param year: 要查询的年份，有效取值范围1901~2050
     * @param month: 要查询的月份，有效取值范围为1~12或1~13（有闰月）
     * @return: 返回该月的天数（30或29）
     *          如果参数year或month不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static int GetMonthDays(int year, int month)
    {
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        
        int num = 12 + (sm_leapMonth[year - YEAR_BASE] ? 1 : 0);
        if (month < 1 || month > num)
            throw InvalidParamter(); // 没有该年的数据
        
        return (sm_monthDay[year - YEAR_BASE] & (1 << (month - 1))) ? 30 : 29;
    }
    
    /*
     * 查询农历某年的天数
     * @param year: 要查询的年份，有效取值范围1901~2050
     * @return: 返回该年的天数
     *          如果参数year不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static int GetYearDays(int year)
    {
        // 实现注记：以后可以考虑把每年的天数保存起来，直接查找
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        
        uint16_t num = sm_monthDay[year - YEAR_BASE];
        
        // 计算num的二进制位中“1”的个数
        num = ((num >> 1) & 0x5555) + (num & 0x5555);
        num = ((num >> 2) & 0x3333) + (num & 0x3333);
        num = ((num >> 4) & 0x0F0F) + (num & 0x0F0F);
        num = ((num >> 8) & 0x00FF) + (num & 0x00FF);
        
        int monthNum = 12 + (sm_leapMonth[year - YEAR_BASE] ? 1 : 0);
        return monthNum * 29 + num;
    }
    
    /*
     * 查询节气日期（返回的是公历日期）
     * @param year: 要查询的年份，有效取值范围1901~2050
     * @param index: 要查询的节气，有效取值范围1~24
     * @return: 返回该节气的日期（公历日期）
     *          如果参数year或index不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static int GetSolarTerm(int year, int index) 
    {
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        
        if (index < 1 || index > 24)
            throw InvalidParamter(); // 没有该年的数据
        
        --index;  // 把取值范围转换为[0, 23]
        uint8_t data = sm_solarTerm[year - YEAR_BASE][index / 2];
        return (index % 2) ? ((data & 0x0F) + 15) : (data >> 4);
    }
    
    /*
     * 查询指定年份的农历年代和农历甲子 Add By Lihaifeng 2011-11-28
     * @param year: 要查询的年份，有效取值范围1901-2050
     * @return: 返回农历的年代和甲子
     *          如果参数year不在有效值范围内，则抛出异常ChineseCalendarDB::InvalidParamter
     */
    static std::pair<int, int> GetEraAndYearOfLunar(int year)
    {
        if (year < YEAR_BASE || year >= YEAR_BASE + YEAR_NUM)
            throw InvalidParamter(); // 没有该年的数据
        static int era_1901=76;//设定起始年份的年代
        static int year_1901=38;//设定起始年份的甲子年份
        int diff_year=year-(YEAR_BASE-year_1901);
        int times=diff_year/60;
        int modes=diff_year%60;
        if (modes==0) {
            modes=60;
        }
        if (times==0) {
            return std::make_pair(era_1901, modes);
        } else {
            return std::make_pair(era_1901+(modes==60?times-1:times), modes);
        }
    }
};

#endif //CHINESE_CALENDAR_DB_H_INCLUDED
