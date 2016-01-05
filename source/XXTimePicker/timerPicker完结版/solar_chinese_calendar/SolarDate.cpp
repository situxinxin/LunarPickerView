/**
 * SolarDate.cpp
 * @Author   Tu Yongce <yongce@126.com>
 * @Created  2008-12-13 
 * @Modified 2008-12-13   
 * @Version  0.1
 */

#include "SolarDate.h"
#include "ChineseDate.h"

// 平年中每一个月的天数
const int SolarDate::sm_monthDay[12] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};

// 平年中每一个月之前所有月的天数
const int SolarDate::sm_yearDays[12] = {
    0, 31, 59 , 90, 120, 151, 181, 212, 243, 273, 304, 334
};


// 判断是否为有效日期
bool SolarDate::IsValidDate() const
{
    if (m_year < 1 || m_month < 1 || m_month > 12 || m_day < 1)
        return false;
    
    if (m_month != 2 && m_day > sm_monthDay[m_month - 1])
        return false;
    
    int feb = (IsLeapYear() ? 29 : 28);
    if (m_month == 2 && m_day > feb)
        return false;
    
    return true;
}

// 从该年的某天计算日期
// 如果无对应日期，则操作失败并返回false；否则返回true
bool SolarDate::FromYearDay(int days)
{
    if (days < 1 || days > (IsLeapYear() ? 366 : 365))
        return false;
    
    int m = 11;
    for (; m > 0; --m) {
        if (sm_yearDays[m] < days)
            break;
    }
    
    m_month = m + 1;
    m_day = days - sm_yearDays[m];
    
    if (m_month > 2 && IsLeapYear()) {
        // 闰年
        if (m_day > 1)
            --m_day;
        else {
            --m_month;
            m_day = sm_monthDay[m_month - 1];
        }
    }
    
    assert(IsValidDate());  // 当ChineseDate对象内部数据变化时确保仍是正确的日期
    return true;
}

// 计算*this和ref之间相差的天数，要求!IsPrior(ref)为真
int SolarDate::DoDiff(const SolarDate &ref) const
{
    assert(!IsPrior(ref));  // *this >= ref
    
    // 首先计算两个年份的1月1日相差的天数
    int days = (m_year - ref.m_year) * 365;
    
    // 算上闰年的额外天数
    days += GetLeapYears(m_year);
    days -= GetLeapYears(ref.m_year);
    
    // 再处理月和日
    days += YearDay();
    days -= ref.YearDay();
    
    return days;
}

// 向前（未来）调整指定天数（始终返回true）
bool SolarDate::DoAdjustForward(int days)
{
    assert(days > 0);
    
    // 以每年最后一天为参考点进行计算
    days += YearDay();
    
    // 400年一个轮回
    const int t1 = 400 * 365 + 100 - 3;
    m_year += days / t1 * 400;
    days  -= days / t1 * t1;
    
    int y = days / 365;
    int leapYears = GetLeapYears(m_year + y) - GetLeapYears(m_year);
    
    days -= y * 365;
    
    if (days > leapYears) {
        m_year += y;
        FromYearDay(days - leapYears);
    } else {
        m_year += y - 1;
        int yearDays = GetYearDays();
        FromYearDay(days + yearDays - leapYears);
    }
    
    return true;
}

// 向后（过去）调整指定天数（注意：不能调整到公元1年1月1日之前）
// 如果调整成功，则返回true；否则返回false（此时*this在调用前后不会发生改变）
bool SolarDate::DoAdjustBackward(int days)
{
    assert(days > 0);
    if (this->DoDiff(SolarDate(1, 1, 1)) < days)
        return false;  // 不能调整时间到公元前
    
    // 以每年第一天（1月1日）为参考点进行计算
    days += GetYearDays() - YearDay();
    
    // 400年一个轮回
    const int t1 = 400 * 365 + 100 - 3;
    m_year -= days / t1 * 400;
    days  -= days / t1 * t1;
    
    int y = days / 365;
    int leapYears = GetLeapYears(m_year + 1) - GetLeapYears(m_year - y + 1);
    
    days -= y * 365;
    
    if (days >= leapYears) {
        m_year -= y;
        days -= leapYears;
        FromYearDay(GetYearDays() - days);
    } else {
        m_year -= y - 1;
        FromYearDay(leapYears - days);
    }
    
    return true;
}

// 转换为农历（把公元1901年2月19日到公元2051年2月10日期间的公历日期转换为农历日期）
// 如果转换成功，返回true；否则返回false
bool SolarDate::ToChineseDate(ChineseDate &date) const
{
    if (this->IsPrior(SolarDate(1901, 12, 19)) || SolarDate(2051, 2, 10).IsPrior(*this))
        return false; // 只能转换公元1901年2月19日到公元2051年2月10日期间的公历日期
    
    // 参考日期：公元2000年2月5日就是农历2000年1月1日
    SolarDate refDay(2000, 2, 5);
    
    // 计算出当前日期与参考日期之间的天数
    int days = this->Diff(refDay);
    
    ChineseDate tmp(2000, 1, 1);
    tmp.AdjustDays(days);
    date = tmp;
//    assert(tmp.Diff(ChineseDate(2000, 1, 1)) == days);
    
    return true;
}
