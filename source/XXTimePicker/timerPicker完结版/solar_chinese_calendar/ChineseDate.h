/**
 * ChineseDate.h
 * @Author   Tu Yongce <yongce@126.com>
 * @Created  2008-12-13 
 * @Modified 2008-12-13   
 * @Version  0.1
 */

#ifndef CHINESE_DATE_H_INCLUDED
#define CHINESE_DATE_H_INCLUDED

#ifdef _MSC_VER
#pragma once
#endif

#include <cassert>
#include "ChineseCalendarDB.h"

class SolarDate;  // 前置声明

/*
 * 农历日期类
 * @note: 只能表示农历1901年1月1日到农历2050年12月30日期间的日期
 */
class ChineseDate
{
private:
    int m_year;      // 1901~2050
    int m_month;     // 1~13
    int m_day;       // 1~[29|30]
    
public:
    ChineseDate();
    ChineseDate(int year, int month, int day);
    //!! 使用编译器生成的拷贝构造函数、拷贝赋值操作符和析构函数
    
    int GetYear() const;
    int GetMonth() const;
    int GetDay() const;
    
    // 判断是否为有效日期
    bool IsValidDate() const;
    
    // 判断是否在指定日期之前
    bool IsPrior(const ChineseDate &ref) const;
    // 判断是否为同一日期
    friend bool operator== (const ChineseDate &lhs, const ChineseDate &rhs);
    friend bool operator!= (const ChineseDate &lhs, const ChineseDate &rhs);
    
    // 计算当前日期是该年的第几天
    int YearDay() const;
    // 从该年的某天计算日期（如果无对应日期，则操作失败并返回false；否则返回true）
    bool FromYearDay(int days);
    
    // 计算和指定日期相差的天数
    // 如果this->IsPrior(ref)为真，则返回负数；否则返回正数
    int Diff(const ChineseDate &ref) const;
    
    // 向前或者向后调整指定天数（有效日期范围：农历1901年1月1日到农历2050年12月30日）
    // 如果days大于0，则向前调整(未来）；否则向后调整（过去）
    // 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
    bool AdjustDays(int days);
    
    // 转换为阳历
    SolarDate ToSolarDate() const;
    
private:
    // 计算*this和ref之间相差的天数，要求!IsPrior(ref)为真
    int DoDiff(const ChineseDate &ref) const;
    
    // 向前（未来）调整指定天数（注意：不能调整到农历2050年12月30日之后）
    // 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
    bool DoAdjustForward(int days);
    
    // 向后（过去）调整指定天数（注意：不能调整到农历1901年1月1日之前）
    // 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
    bool DoAdjustBackward(int days);
};

inline ChineseDate::ChineseDate(): m_year(1901), m_month(1), m_day(1)
{
}

inline ChineseDate::ChineseDate(int year, int month, int day): m_year(year), m_month(month), m_day(day)
{
    //assert(IsValidDate());  // 当ChineseDate对象内部数据变化时确保仍是正确的日期
}

inline int ChineseDate::GetYear() const
{
    return m_year;
}

inline int ChineseDate::GetMonth() const
{
    return m_month;
}

inline int ChineseDate::GetDay() const
{
    return m_day;
}

// 判断是否在指定日期之前
inline bool ChineseDate::IsPrior(const ChineseDate &ref) const
{
    return m_year < ref.m_year || (m_year == ref.m_year && (m_month < ref.m_month || (m_month == ref.m_month && m_day < ref.m_day)));
}

// 判断是否为同一日期
inline bool operator== (const ChineseDate &lhs, const ChineseDate &rhs)
{
    return lhs.m_year == rhs.m_year && lhs.m_month == rhs.m_month && lhs.m_day == rhs.m_day;
}

inline bool operator!= (const ChineseDate &lhs, const ChineseDate &rhs)
{
    return !(lhs == rhs);
}

// 计算和指定日期相差的天数
// 如果this->IsPrior(ref)为真，则返回负数；否则返回正数
inline int ChineseDate::Diff(const ChineseDate &ref) const
{
    return this->IsPrior(ref) ? -ref.DoDiff(*this) : this->DoDiff(ref);
}

// 向前或者向后调整指定天数（注意：不能调整到公元1年1月1日之前）
// 如果days大于0，则向前调整(未来）；否则向后调整（过去）
// 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
inline bool ChineseDate::AdjustDays(int days)
{
    if (days > 0) 
        return DoAdjustForward(days);
    else if (days < 0)
        return DoAdjustBackward(-days);
    
    assert(IsValidDate());  // 当ChineseDate对象内部数据变化时确保仍是正确的日期
    return true;
}


#endif //CHINESE_DATE_H_INCLUDED
