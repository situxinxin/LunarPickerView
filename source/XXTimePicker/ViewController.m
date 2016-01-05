//
//  ViewController.m
//  XXTimePicker
//
//  Created by 新新 on 16/1/5.
//  Copyright © 2016年 司徒新新. All rights reserved.
//

#import "ViewController.h"
#import "XXTimerPicker.h"
@interface ViewController ()

/**< 时间选择器*/
@property (nonatomic, strong) XXTimerPicker * picker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"日历";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 200, 150, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"设置时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(timePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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
