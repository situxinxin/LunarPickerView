//
//  XXTheLabel.h
//  GiftFaction
//
//  Created by 新新 on 15/12/24.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"
@interface XXTheLabel : UIView<TagViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteBackViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *tagNumber;
@property (weak, nonatomic) IBOutlet TagView *tagView;
@property (nonatomic, strong) NSArray * dataArray;

@property (weak, nonatomic) IBOutlet UIView *whiteBackView;


+(XXTheLabel *)getChooseTheLabelView:(CGFloat)height;
-(void)main;

@property (nonatomic, assign) BOOL  VCType;

@property (nonatomic, strong) NSMutableArray * blockArray;


//标签
@property (nonatomic, strong) void (^blockTag)(NSArray * array);
//关系
@property (nonatomic, strong) void (^blockREL)(NSString * string);
@end
