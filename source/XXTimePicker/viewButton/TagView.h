//
//  XXTagView.h
//  collection测试
//
//  Created by 新新 on 15/12/24.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagView;

@protocol TagViewDelegate <NSObject>

/** 点击了标签按钮 */
- (void)tagView:(TagView *)tagView didClickedLabelButton:(UIButton *)button;

@end

@interface TagView : UIScrollView

/** 数据源 */
@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,assign) CGSize sizeFit;
@property(nonatomic,weak) id<TagViewDelegate> tagDelegate;

/** 科室模型 */
@property(nonatomic,assign) NSArray *ksItems;

/** 刷新数据 */
- (void)reloadData;

//高度
@property (nonatomic, strong) void (^heightBlock)(float hegit);

@property (nonatomic, strong) void (^widthBlock)(float width);

//颜色赋值判断
@property (nonatomic, assign) BOOL colorBool;

@end
