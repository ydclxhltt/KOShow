//
//  AnchorDetailView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X             5.0
#define ICON_WH             70.0
#define SPACE_Y             15.0
#define ADD_X               15.0
#define LABEL_HEIGHT        30.0
#define ANCHOR_LINE_COLOR   RGB(233.0,233.0,233.0)

#import "AnchorDetailView.h"

@interface AnchorDetailView()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *anchorNameLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UITextView *textView;


@end

@implementation AnchorDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    float x = SPACE_X;
    float y = SPACE_Y;
    _iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"2.jpg"]];
    [self addSubview:_iconImageView];
    
    x += ICON_WH + ADD_X;
    _anchorNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, self.frame.size.width - x, LABEL_HEIGHT) textString:@"美女主播" textColor:MAIN_TEXT_COLOR textFont:FONT(16.0)];
    [self addSubview:_anchorNameLabel];
    
    y += _anchorNameLabel.frame.size.height;
    _roomNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, self.frame.size.width - x, LABEL_HEIGHT) textString:@"正在直播: 坦克世界" textColor:DETAIL_TEXT_COLOR textFont:FONT(16.0)];
    [self addSubview:_roomNameLabel];
    
    y = _iconImageView.frame.origin.y + _iconImageView.frame.size.height + SPACE_Y;
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, self.frame.size.width, 1.0) placeholderImage:nil];
    lineImageView.backgroundColor = ANCHOR_LINE_COLOR;
    [self addSubview:lineImageView];
    
   
    UIImage *image = [UIImage imageNamed:@"anchor_detail_line"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    x = SPACE_X;
    y += SPACE_Y + (LABEL_HEIGHT - height)/2;
    UIImageView *detailImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, width, height) placeholderImage:image];
    [self addSubview:detailImageView];
    
    x += SPACE_X;
    y -= (LABEL_HEIGHT - height)/2;
    UILabel *titleLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, self.frame.size.width - x, LABEL_HEIGHT) textString:@" 主播简介" textColor:MAIN_TEXT_COLOR textFont:FONT(16.0)];
    [self addSubview:titleLable];
    
    x = SPACE_X;
    y = titleLable.frame.size.height + titleLable.frame.origin.y;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width - 2 * x, self.frame.size.height - y - SPACE_Y)];
    _textView.textColor = DETAIL_TEXT_COLOR;
    _textView.editable = NO;
    _textView.font = FONT(15.0);
    _textView.text = @"美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军.美女主播是中国游戏新生代玩家,曾获得亚太地区大赛冠军...";
    [self addSubview:_textView];
    
    
}

@end
