//
//  XXTimerPicker.m
//  GiftFaction
//
//  Created by 新新 on 15/12/23.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import "XXTimerPicker.h"
#import "IDJChineseCalendar.h"
#import "IDJCalendarUtil.h"
#import "IDJCalendar.h"

#define YEAR_START 1970//滚轮显示的起始年份
#define YEAR_END 2049//滚轮显示的结束年份
//日历显示的类型
enum calendarType {
    Gregorian1=1,
    Chinese1
};
//是否显示年份
enum yearHidden
{
    YearHidden = 1,
    YearNoHidden
};
#define WIDTH  [UIScreen mainScreen].bounds.size.width

@interface XXTimerPicker()<UIPickerViewDataSource,UIPickerViewDelegate>
//
@property (nonatomic, strong) NSMutableArray *years;//第一列的数据容器
@property (nonatomic, strong) NSMutableArray *months;//第二列的数据容器
@property (nonatomic, strong) NSMutableArray *days;//第三列的数据容器
@property (nonatomic, strong) IDJCalendar *cal;//日期类

@property (nonatomic, strong) NSString * selectedYear;
@property (nonatomic, strong) NSString * selectedMonth;
@property (nonatomic, strong) NSString * selectedDay;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int yearHiddenType;

@property (nonatomic, assign) int oneC;
@property (nonatomic, assign) int twoC;
@property (nonatomic, assign) int threeC;

//控件
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *calendarBtn; //农历
@property (weak, nonatomic) IBOutlet UIButton *IgnoreYearBtn; //忽略年份
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn; //取消
@property (weak, nonatomic) IBOutlet UIButton *determineBtn; //保存
@end

@implementation XXTimerPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(XXTimerPicker *)getChooseTimerView
{
    XXTimerPicker * picker = [[NSBundle mainBundle]loadNibNamed:@"XXTimerPicker" owner:nil options:nil][0];
    return picker;
}

//保存
- (IBAction)saveBtnAction:(UIButton *)sender
{
    if (self.saveBlock) {
        self.saveBlock(self.selectedYear,self.selectedMonth,self.selectedDay);
    }  
}



- (void)main
{
    self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    self.hidden = NO;
    self.calendarBtn.selected = YES;
    self.IgnoreYearBtn.selected = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self IgnoreYearBtnAction:self.IgnoreYearBtn];
    [self calendarBtnAction:self.calendarBtn];
}


- (void)show
{
    self.hidden = NO;
}

- (IBAction)canleSelf:(UIButton *)sender
{
//    [self removeFromSuperview];
    self.hidden = YES;
}

//是否选择农历
- (IBAction)calendarBtnAction:(UIButton *)sender
{
    if (self.calendarBtn.selected == YES) {
        //农历
        self.type = Gregorian1;
        self.calendarBtn.selected = NO;
    } else {
        //阳历
        self.type = Chinese1;
        self.calendarBtn.selected = YES;
    }
    
    [self time];
}

//是否忽略年份
- (IBAction)IgnoreYearBtnAction:(UIButton *)sender
{
    if (self.IgnoreYearBtn.selected == YES) {
        self.IgnoreYearBtn.selected = NO;
        self.yearHiddenType = YearHidden;
    } else {
        self.IgnoreYearBtn.selected = YES;
        self.yearHiddenType = YearNoHidden;
    }
    [self isYearHidden];
    [self.pickerView reloadAllComponents];
    [self reloadPickerIndex];
}




#pragma mark - 日历算法
- (void)time
{
    self.years = [NSMutableArray array];
    self.months = [NSMutableArray array];
    self.days = [NSMutableArray array];
    
    if (self.type==Gregorian1) {
        self.cal=[[IDJCalendar alloc]initWithYearStart:YEAR_START end:YEAR_END];
    } else {
        self.cal=[[IDJChineseCalendar alloc]initWithYearStart:YEAR_START end:YEAR_END];
    }
    self.backgroundColor=[UIColor clearColor];
    
    [self setYears];
    [self setMonthsInYear:[self.cal.year intValue]];
    [self setDaysInMonth:self.cal.month year:[self.cal.year intValue]];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
    
    [self reloadPickerIndex];
    
}

- (void)reloadPickerIndex
{
    if (self.yearHiddenType == YearHidden) {
        [self.pickerView selectRow:31 inComponent:0 animated:YES];
        [self.pickerView selectRow:6 inComponent:1 animated:YES];
        [self.pickerView selectRow:15 inComponent:2 animated:YES];
    } else {
        [self.pickerView selectRow:6 inComponent:0 animated:YES];
        [self.pickerView selectRow:15 inComponent:1 animated:YES];
    }
}
#pragma mark -Fill init Data-
//填充年份
- (void)setYears
{
    self.years = [self.cal yearsInRange];
}
//填充月份
- (void)setMonthsInYear:(NSUInteger)_year
{
    self.months=[self.cal monthsInYear:_year];
}
//填充天数
- (void)setDaysInMonth:(NSString *)_month year:(NSUInteger)_year {
    self.days = [self.cal daysInMonth:_month year:_year];
}

#pragma mark -Calendar Data Handle-
//动态改变农历月份列表，因为公历的月份只有12个月，不需要跟随年份滚轮联动
- (void)changeMonths{
    if (self.type==Chinese1) {
        [self setMonthsInYear:[self.cal.year intValue]];
        
        [self.pickerView reloadComponent:self.twoC];
        int cell = (int)[self.months indexOfObject:self.cal.month];
        if (cell == NSNotFound) {
            cell=0;
            self.cal.month=[self.months objectAtIndex:0];
        }
        //        [self.pickerView selectRow:cell inComponent:1 animated:YES];
        //月份改变之后，天数进行联动
        [self changeDays];
    }
}

//动态改变日期列表
- (void)changeDays{
    [self setDaysInMonth:self.cal.month year:[self.cal.year intValue]];
    [self.pickerView reloadComponent:self.threeC];
    
    int cell = (int)[self.days indexOfObject:self.cal.day];
    //假如用户上次选择的是1月31日，当月份变为2月的时候，第三列的滚轮不可能再选中31日，我们设置默认的值为第一个。
    if (cell==NSNotFound) {
        cell=0;
        self.cal.day=[self.days objectAtIndex:0];
    }
}


- (void)isYearHidden
{
    if (self.yearHiddenType == YearHidden) {
        self.oneC = 0;
        self.twoC = 1;
        self.threeC = 2;
    } else {
        self.oneC = 3;
        self.twoC = 0;
        self.threeC = 1;
    }
}

#pragma mark -UIPickerView
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.yearHiddenType == YearHidden) {
        return 3;
    } else {
        return 2;
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == self.oneC) {
        return self.years.count;
    } else if (component == self.twoC) {
        return self.months.count;
    } else if (component == self.threeC){
        return self.days.count;
    }
    return 0;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = (WIDTH - 60) / 3;
    
    return componentWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0;
}

// 返回选中的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == self.oneC)
    {
        NSString *str=[self.years objectAtIndex:row];
        if (self.type==Chinese1) {
            NSArray *array=[str componentsSeparatedByString:@"-"];
            str=[array objectAtIndex:2];
            NSString *pYear=[self.cal.year copy];
            self.cal.era=[array objectAtIndex:0];
            ((IDJChineseCalendar *)self.cal).jiazi=[array objectAtIndex:1];
            self.cal.year=str;
            //因为用户可能从2011年滚动，最后放手的时候，滚回了2011年，所以需要判断与上一次选中的年份是否不同，再联动月份的滚轮
            if (![pYear isEqualToString:self.cal.year]) {
                [self changeMonths];
            }
        } else {
            self.cal.year=str;
            //因为公历的每年都是12个月，所以当年份变化的时候，只需要后面的天数联动
            [self changeDays];
        }
        
    } else if (component == self.twoC)
    {
        NSString *pMonth=[self.cal.month copy];
        NSString *str=[self.months objectAtIndex:row];
        self.cal.month=str;
        if (![pMonth isEqualToString:self.cal.month]) {
            //联动天数的滚轮
            [self changeDays];
        }
    } else if (component == self.threeC)
    {
        self.cal.day=[self.days objectAtIndex:row];
    }
    
    if (self.type==Gregorian1)
    {
        self.cal.weekday=[NSString stringWithFormat:@"%d", [IDJCalendarUtil weekDayWithSolarYear:[self.cal.year intValue] month:self.cal.month day:[self.cal.day intValue]]];
    } else {
        self.cal.weekday=[NSString stringWithFormat:@"%d", [IDJCalendarUtil weekDayWithChineseYear:[self.cal.year intValue] month:self.cal.month day:[self.cal.day intValue]]];
        ((IDJChineseCalendar *)self.cal).animal=[IDJCalendarUtil animalWithJiazi:[((IDJChineseCalendar *)self.cal).jiazi intValue]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == self.oneC) {
        NSString *str=[self.years objectAtIndex:row];
        if (self.type==Chinese1) {
            NSArray *array=[str componentsSeparatedByString:@"-"];
            str = [NSString stringWithFormat:@"%@/%@", [((IDJChineseCalendar *)self.cal).chineseYears objectAtIndex:[[array objectAtIndex:1]intValue]-1], [array objectAtIndex:2]];
        }
        self.selectedYear = str;
        return str;
        
    } else if(component == self.twoC){
        NSString *str=[NSString stringWithFormat:@"%@", [self.months objectAtIndex:row]];
        
        if (self.type==Chinese1) {
            NSString * string;
            NSArray *array= [str componentsSeparatedByString:@"-"];
            
            if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
                string = [((IDJChineseCalendar *)self.cal).chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1];
            } else {
                string = [NSString stringWithFormat:@"%@%@", @"闰", [((IDJChineseCalendar *)self.cal).chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
            }
            self.selectedMonth = string;
            return string;
        } else {
            self.selectedMonth = [NSString stringWithFormat:@"%@%@", str, @"月"];
            return [NSString stringWithFormat:@"%@%@", str, @"月"];
        }
    } else {
        if (self.type==Gregorian1) {
            int day  =[[self.days objectAtIndex:row] intValue];
            int weekday=[IDJCalendarUtil weekDayWithSolarYear:[self.cal.year intValue] month:self.cal.month day:day];
            self.selectedDay = [NSString stringWithFormat:@"%d  %@", day, [self.cal.weekdays objectAtIndex:weekday]];
            return self.selectedDay;
        } else {
            NSString *jieqi=[[IDJCalendarUtil jieqiWithYear:[self.cal.year intValue]]objectForKey:[NSString stringWithFormat:@"%@-%d", self.cal.month, [[self.days objectAtIndex:row]intValue]]];
            if (!jieqi) {
                self.selectedDay = [NSString stringWithFormat:@"%@", [((IDJChineseCalendar *)self.cal).chineseDays objectAtIndex:[[self.days objectAtIndex:row]intValue]-1]];
                return self.selectedDay;
            } else {
                self.selectedDay =[NSString stringWithFormat:@"%@", jieqi];
                return self.selectedDay;
            }
        }
    }
}


@end
