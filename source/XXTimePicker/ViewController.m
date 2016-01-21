//
//  ViewController.m
//  XXTimePicker
//
//  Created by 新新 on 16/1/5.
//  Copyright © 2016年 司徒新新. All rights reserved.
//

#import "ViewController.h"
#import "XXTimerPicker.h"
#import "XXTheLabel.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

/**< 时间选择器*/
@property (nonatomic, strong) XXTimerPicker * picker;
@property (nonatomic, strong) UILabel * label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"日历  and  ViewButton";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10 , 100, 150, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"设置时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(timePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(self.view.frame.size.width / 2, 100, 150, 100);
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"viewButton" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(viewButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, button1.frame.origin.y - 40, WIDTH - 40, 30)];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor purpleColor];
    _label.text = @"未选择";
    [self.view addSubview:_label];
    
}

- (void)viewButton
{
    XXTheLabel * thelabel = [XXTheLabel getChooseTheLabelView:WIDTH];
    thelabel.dataArray = @[@"萌妹子",@"90后",@"旅行达人",@"二次元",@"长辈",@"运动健将",@"女汉子",@"80后",@"小萝莉",@"女神",@"IT族",@"小正太",@"科技宅",@"爱车族",@"男神"];
    thelabel.VCType = YES;
    __weak typeof(self) weakSelf = self;
    thelabel.blockTag = ^(NSArray * array){
        
        NSString * str = [array componentsJoinedByString:@","];
        weakSelf.label.text = [NSString stringWithFormat:@"已选中：%@",str];
        
    };
    [thelabel main];
    [self.view.window addSubview:thelabel];
}


- (void)timePicker
{
/*
    使用方法
 */
    
    [self picker];
    [_picker show];
}

//重写picker方法
-(XXTimerPicker *)picker
{
    if (_picker) {
        return _picker;
    }
    _picker = [XXTimerPicker getChooseTimerView];
    [_picker main];
    [self.view.window addSubview:_picker];
    return _picker;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
