//
//  KOShowHeaderView.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ICON_WIDTH      15.0 * CURRENT_SCALE
#define ICON_HEIGHT     15.0 * CURRENT_SCALE
#define ADD_X           5.0
#define TIPLABEL_WIDTH  120.0 * CURRENT_SCALE
#define MORE_WIDTH      13.0 * CURRENT_SCALE
#define MORE_HEIGHT     11.0 * CURRENT_SCALE
#define MORE_TEXT_COLOR RGB(255.0, 129.0, 00.0)
//#define MORE_TEXT_COLOR APP_MAIN_COLOR
#define MORE_TEXT_FONT  FONT(13.0)

#import "KOShowHeaderView.h"

@interface KOShowHeaderView()
{
    float x;
}

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UILabel *moreLabel;

@end

@implementation KOShowHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
-(void)initUI
{
    x = SPACE;
    [self addIconView];
    [self addTipLable];
    [self addMoreView];
}

//添加icon
- (void)addIconView
{
    _iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, (self.frame.size.height - ICON_HEIGHT)/2, ICON_WIDTH, ICON_HEIGHT) placeholderImage:[UIImage imageNamed:@"headerIcon"]];
    [self addSubview:_iconImageView];
    x += _iconImageView.frame.size.width + ADD_X;
}

//添加描述信息
- (void)addTipLable
{
    _tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0, TIPLABEL_WIDTH, self.frame.size.height) textString:@"" textColor:HEADERVIEW_T_COLOR textFont:HEADERVIEW_FONT];
    [self addSubview:_tipLabel];
    x += _tipLabel.frame.size.width;
}

//添加更多视图
- (void)addMoreView
{
    _moreImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(self.frame.size.width - SPACE - MORE_WIDTH, (self.frame.size.height - MORE_HEIGHT)/2, MORE_WIDTH, MORE_HEIGHT) placeholderImage:[UIImage imageNamed:@"icon_more"]];
    [self addSubview:_moreImageView];
    
    _moreLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0,  (_moreImageView.frame.origin.x - SPACE) - x , self.frame.size.height) textString:@"更多" textColor:MORE_TEXT_COLOR textFont:MORE_TEXT_FONT];
    _moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_moreLabel];
}

#pragma mark 设置数据
- (void)setDataWithIconName:(NSString *)name tipText:(NSString *)text isShowMore:(BOOL)isShow
{
    self.iconImageView.image = [UIImage imageNamed:(name) ? name : @""];
    self.tipLabel.text = (text) ? text : @"";
    self.moreImageView.hidden = isShow;
    self.moreLabel.hidden = isShow;
}

@end
