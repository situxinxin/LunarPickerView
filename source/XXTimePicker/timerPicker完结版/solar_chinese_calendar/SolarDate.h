/**
 * SolarDate.h
 * @Author   Tu Yongce <yongce@126.com>
 * @Created  2008-12-13 
 * @Modified 2008-12-13   
 * @Version  0.1
 */

#ifndef SOLAR_DATE_H_INCLUDED
#define SOLAR_DATE_H_INCLUDED

#ifdef _MSC_VER
#pragma once
#endif

#include <cassert>

class ChineseDate;  // 前置声明

/*
 * 阳历日期类
 * @note: 能够表示从公元1年1月1日开始的任何一天
 */
class SolarDate
{
private:
    int m_year;      // 1~?
    int m_month;     // 1~12
    int m_day;       // 1~[28|29|30|31]
    
    static const int sm_monthDay[12];    // 平年中每一个月的天数
    static const int sm_yearDays[12];    // 平年中每一个月之前所有月的天数
    
public:
    SolarDate();
    SolarDate(int year, int month, int day);
    //!! 使用编译器生成的拷贝构造函数、拷贝赋值操作符和析构函数
    
    int GetYear() const;
    int GetMonth() const;
    int GetDay() const;
    
    // 判断是否为有效日期
    bool IsValidDate() const;
    // 判断是否为闰年
    bool IsLeapYear() const;
    
    // 判断是否在指定日期之前
    bool IsPrior(const SolarDate &ref) const;
    // 判断是否为同一日期
    friend bool operator== (const SolarDate &lhs, const SolarDate &rhs);
    friend bool operator!= (const SolarDate &lhs, const SolarDate &rhs);
    
    // 计算某年的全年天数
    int GetYearDays() const;
    // 计算是该年中的第几天
    int YearDay() const;
    // 从该年的某天计算日期（如果无对应日期，则操作失败并返回false；否则返回true）
    bool FromYearDay(int days);
    
    // 转换为星期，返回0~6，分别代表星期日~星期六
    int ToWeek() const;
    
    // 计算和指定日期相差的天数
    // 如果this->IsPrior(ref)为真，则返回负数；否则返回正数
    int Diff(const SolarDate &ref) const;
    
    // 向前或者向后调整指定天数（注意：不能调整到公元1年1月1日之前）
    // 如果days大于0，则向前调整(未来）；否则向后调整（过去）
    // 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
    bool AdjustDays(int days);
    
    // 转换为农历（把公元1901年2月19日到公元2051年2月29日期间的公历日期转换为农历日期）
    // 如果转换成功，返回true；否则返回false
    bool ToChineseDate(ChineseDate &date) const;
    
private:
    // 计算某年之前的闰年数
    static int GetLeapYears(int year);
    
    // 计算*this和ref之间相差的天数，要求!IsPrior(ref)为真
    int DoDiff(const SolarDate &ref) const;
    
    // 向前（未来）调整指定天数（始终返回true）
    bool DoAdjustForward(int days);
    
    // 向后（过去）调整指定天数（注意：不能调整到公元1年1月1日之前）
    // 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
    bool DoAdjustBackward(int days);
};

inline SolarDate::SolarDate(): m_year(1), m_month(1), m_day(1)
{
}

inline SolarDate::SolarDate(int year, int month, int day): m_year(year), m_month(month), m_day(day) 
{
    //assert(IsValidDate());  // 当ChineseDate对象内部数据变化时确保仍是正确的日期
}

inline int SolarDate::GetYear() const
{
    return m_year;
}

inline int SolarDate::GetMonth() const
{
    return m_month;
}

inline int SolarDate::GetDay() const
{
    return m_day;
}

// 判断是否为闰年
inline bool SolarDate::IsLeapYear() const
{
    return (!(m_year % 4) && (m_year % 100)) || !(m_year % 400);    
}

// 判断是否在指定日期之前
inline bool SolarDate::IsPrior(const SolarDate &ref) const
{
    return m_year < ref.m_year || 
    ((m_year == ref.m_year && (m_month < ref.m_month || (m_month == ref.m_month && m_day < ref.m_day))));
}

// 判断是否为同一日期
inline bool operator== (const SolarDate &lhs, const SolarDate &rhs)
{
    return lhs.m_year == rhs.m_year && lhs.m_month == rhs.m_month && lhs.m_day == rhs.m_day;
}

inline bool operator!= (const SolarDate &lhs, const SolarDate &rhs)
{
    return !(lhs == rhs);
}

// 计算某年的全年天数
inline int SolarDate::GetYearDays() const
{
    return IsLeapYear() ? 366 : 365;
}

// 计算是该年中的第几天
inline int SolarDate::YearDay() const
{
    size_t days = sm_yearDays[m_month - 1] + m_day;
    if (m_month > 2 && IsLeapYear())
        ++days;
    return (int)days;
}

// 计算某年之前的闰年数
inline int SolarDate::GetLeapYears(int year)
{
    if (year == 0)
        return 0;
    
    int y = year - 1;
    return y / 4 - y / 100 + y / 400;
}

// 转换为星期，返回0~6，分别代表星期日~星期六
inline int SolarDate::ToWeek() const
{
    // 公式：W = [Y-1] + [(Y-1)/4] - [(Y-1)/100] + [(Y-1)/400] + D 
    // Y是年份数，D是这一天在这一年中是第几天。
    // 算出来的W除以7，余数是几就是星期几。如果余数是0，则为星期日。
    // 注：365 = 52 * 7 + 1，公元元年1月1日为星期一
    return (m_year - 1 + GetLeapYears(m_year) + YearDay()) % 7;
}

// 计算和指定日期相差的天数
// 如果this->IsPrior(ref)为真，则返回负数；否则返回正数
inline int SolarDate::Diff(const SolarDate &ref) const
{
    return this->IsPrior(ref) ? -ref.DoDiff(*this) : this->DoDiff(ref);
}

// 向前或者向后调整指定天数（注意：不能调整到公元1年1月1日之前）
// 如果days大于0，则向前调整(未来）；否则向后调整（过去）
// 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
inline bool SolarDate::AdjustDays(int days)
{
    if (days > 0) 
        return DoAdjustForward(days);
    else if (days < 0)
        return DoAdjustBackward(-days);
    
    assert(IsValidDate());  // 当ChineseDate对象内部数据变化时确保仍是正确的日期
    return true;
}

#endif // SOLAR_DATE_H_INCLUDED
