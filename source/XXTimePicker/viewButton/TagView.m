//
//  XXTagView.m
//  collection测试
//
//  Created by 新新 on 15/12/24.
//  Copyright © 2015年 Situxinxin. All rights reserved.
//

#import "TagView.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 6.0f           // zuoyou
#define BOTTOM_MARGIN 8.0f         //
#define FONT_SIZE 16.0f             //字体大小
#define HORIZONTAL_PADDING 6.0f     //btn左右间距
#define VERTICAL_PADDING 10.0f      //btn上下间距
#define OffsetX 10

@interface TagView ()

/** 每一行的高度 */
@property(nonatomic,assign) CGFloat totalHeight;

//宽度
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation TagView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
}

#pragma mark - set科室id
- (void)setKsItems:(NSArray *)ksItems
{
    _ksItems = ksItems;
}

#pragma mark - 刷新数据
- (void)reloadData
{
    for (UIButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.totalHeight = 0;
    self.totalWidth = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    if (self.ksItems) {
        
        for (int i = 0; i < self.ksItems.count; i++) {
//            NSDictionary *item = self.ksItems[i];
            NSString *text = self.ksItems[i];
//            NSInteger ksId = item.keShiItemId;
            //动态的获取文字的高度
            NSDictionary* attrribDict = @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]};
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(WIDTH, MAXFLOAT)
                                                 options:NSStringDrawingTruncatesLastVisibleLine |
                               NSStringDrawingUsesLineFragmentOrigin |
                               NSStringDrawingUsesFontLeading
                                              attributes:attrribDict
                                                 context:nil].size;
            
            textSize.width += HORIZONTAL_PADDING*2;//水平间距
            textSize.height += VERTICAL_PADDING*2;//垂直
            
            UIButton * labelBtn = nil;
            
            if (!gotPreviousFrame) {
                labelBtn = [[UIButton alloc] initWithFrame:CGRectMake(OffsetX, 10 , textSize.width, 34)];
                self.totalHeight = textSize.height + BOTTOM_MARGIN ;
                self.totalWidth = textSize.width + LABEL_MARGIN ;
            } else {
                CGRect newRect = CGRectZero;
                if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN + OffsetX > WIDTH - 40) {
                    
                    newRect.origin = CGPointMake(OffsetX, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                    self.totalHeight += textSize.height + BOTTOM_MARGIN + 5;
                    self.totalWidth += textSize.width + LABEL_MARGIN + 5;
                } else {
                 
                    newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                    self.totalWidth += textSize.width + LABEL_MARGIN + 5;       //因为只有一行,所以只算一行
                }
                
                newRect.size = CGSizeMake(textSize.width, 34);
                labelBtn = [[UIButton alloc] initWithFrame:newRect];
            }
            previousFrame = labelBtn.frame;
            gotPreviousFrame = YES;
            
            [labelBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [labelBtn setTitle:text forState:UIControlStateNormal];
            [labelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [labelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            labelBtn.titleLabel.numberOfLines = 1;
            if (self.colorBool) {
                labelBtn.backgroundColor = [UIColor redColor];//HEXCOLOR(0xFB6C7C);
            } else {
                labelBtn.backgroundColor = [UIColor blueColor];//HEXCOLOR(0xA1A1A1);
            }
            
            
            labelBtn.selected = NO;
            labelBtn.layer.cornerRadius = 3.5;
            labelBtn.layer.masksToBounds = YES;
//            labelBtn.tag = ksId;
            //添加点击事件
            [labelBtn addTarget:self action:@selector(clickLabelBtn:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:labelBtn];
        }
    }
    
    self.sizeFit = CGSizeMake(self.frame.size.width, self.totalHeight + 1.0f);
    if (self.heightBlock) {
        self.heightBlock(self.totalHeight + 1);
    }
    if (self.widthBlock) {
        self.widthBlock(self.totalWidth + 1);
    }
    
}

- (void)layoutSubviews
{
    
}


- (void)clickLabelBtn:(UIButton *)button
{   
    if ([self.tagDelegate respondsToSelector:@selector(tagView:didClickedLabelButton:)]) {
        [self.tagDelegate tagView:self didClickedLabelButton:button];
    }
}

@end
