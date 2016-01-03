//
//  SegmentView.m
//  KOShow
//
//  Created by 陈磊 on 15/11/28.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define LAYER_RADIUS    15.0
#define BUTTON_FONT     FONT(15.0)

#import "SegmentView.h"

@interface SegmentView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [CommonTool setViewLayer:self withLayerColor:APP_MAIN_COLOR bordWidth:1.0];
        [CommonTool clipView:self withCornerRadius:LAYER_RADIUS];
    }
    return self;
}

#pragma mark 设置弧度
- (void)setRadius:(float)radius
{
    _radius = radius;
    [CommonTool clipView:self withCornerRadius:radius];
}

#pragma mark 设置图层颜色
- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    [CommonTool setViewLayer:self withLayerColor:layerColor bordWidth:1.0];
}


#pragma mark 设置数据
- (void)setItemTitleWithArray:(NSArray *)titleArray
{
    if (titleArray && [titleArray count] > 0)
    {
        _titleArray = titleArray;
        [self initUI];
    }
}

#pragma mark 初始化UI
- (void)initUI
{
     float width = self.frame.size.width/2.0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(width * [self.titleArray count], _scrollView.frame.size.height);
    [self addSubview:_scrollView];
    
    
   
    for (int i = 0; i< [self.titleArray count]; i++)
    {
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height) buttonTitle:self.titleArray[i] titleColor:APP_MAIN_COLOR normalBackgroundColor:[UIColor whiteColor] highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"buttonPressed:" tagDelegate:self];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.tag = i + 1;
        button.titleLabel.font = BUTTON_FONT;
        button.selected = (i == 0) ? YES : NO;
        [_scrollView addSubview:button];
    }
}

#pragma mark 按钮响应事件
- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = YES;
    for (UIButton *button in self.scrollView.subviews)
    {
        button.selected = (button.tag == sender.tag) ? YES : NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:selectedItemAtIndex:)])
    {
        [self.delegate segmentView:self selectedItemAtIndex:(int)sender.tag - 1];
    }
}

@end
