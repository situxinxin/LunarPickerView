//
//  XXTheLabel.m
//  GiftFaction
//
//  Created by 新新 on 15/12/24.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import "XXTheLabel.h"

@implementation XXTheLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self = [[NSBundle mainBundle]loadNibNamed:@"XXTheLabel" owner:nil options:nil][0];
//    }
//    return self;
//}

-(void)main
{
    self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    self.hidden = NO;
    self.tagView.scrollEnabled = YES;
    self.tagView.userInteractionEnabled = YES;
    self.tagView.tagDelegate = self;
    self.tagView.ksItems = self.dataArray;
    self.whiteBackView.layer.cornerRadius = 5;
    self.whiteBackView.layer.masksToBounds = YES;
    self.tagView.heightBlock = ^(float height) {
        self.whiteBackViewHeight.constant = height + 51;
    };
    [self.tagView reloadData];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)]];
    

    if (self.VCType) {
        //标签
        self.blockArray = [NSMutableArray array];
    } else {
        //关系
    }
}

- (void)hidden
{
    if (self.VCType) {
        if (self.blockTag) {
            self.blockTag(self.blockArray);
        }
        [self.blockArray removeAllObjects];
    } else {
        
    }
    
    
    [self removeFromSuperview];
}


+(XXTheLabel *)getChooseTheLabelView:(CGFloat)height
{
    XXTheLabel * theLabel = [[NSBundle mainBundle]loadNibNamed:@"XXTheLabel" owner:nil options:nil][0];
    theLabel.whiteBackViewHeight.constant = height;
    return theLabel;
}

#pragma mark - TagView的代理方法 / 选择
- (void)tagView:(TagView *)tagView didClickedLabelButton:(UIButton *)button
{
    if (self.VCType) {
        if (button.selected == NO) {
            [self.blockArray addObject:button.titleLabel.text];
            if (self.blockArray.count == 3) {
#warning  我这只需要3个  如果需要更多 或者不隐藏，可以修改
                [self hidden];
            }
        } else {
            [self.blockArray removeObject:button];
        }
        self.tagNumber.text = [NSString stringWithFormat:@"标签 (%lu/3)",(unsigned long)self.blockArray.count];
    } else {
        if (self.blockREL) {
            self.blockREL(button.titleLabel.text);
            [self hidden];
        }
    }
    
    if (button.selected == YES) {
        button.selected = NO;
        button.backgroundColor = [UIColor blueColor];//HEXCOLOR(0xA1A1A1);
    } else {
        button.selected = YES;
        button.backgroundColor = [UIColor redColor];//HEXCOLOR(0xFB6C7C);
    }
    
}


@end
