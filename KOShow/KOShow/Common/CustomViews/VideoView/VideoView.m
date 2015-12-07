//
//  VideoView.m
//  KOShow
//
//  Created by 陈磊 on 15/11/27.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADD_Y                   5.0 * CURRENT_SCALE
#define ROOM_PIC_HEIGHT         100.0 * CURRENT_SCALE

#import "VideoView.h"

@interface VideoView()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *anchorNameLabel;
@property (nonatomic, strong) UILabel *userCountLabel;

@end

@implementation VideoView

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
- (void)initUI
{
    [self addPicImageView];
    [self addRoomInfoView];
    [self addRoomLabel];
    [self addClickButton];
}

//添加缩略图
- (void)addPicImageView
{
    _picImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, ROOM_PIC_HEIGHT) placeholderImage:[UIImage imageNamed:@"6.jpg"]];
    [self addSubview:_picImageView];
}

- (void)addRoomInfoView
{
//    _moreLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0,  (_moreImageView.frame.origin.x - SPACE) - x , self.frame.size.height) textString:@"更多" textColor:MORE_TEXT_COLOR textFont:MORE_TEXT_FONT];
//    _moreLabel.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_moreLabel];
}

- (void)addRoomLabel
{
    float y = self.picImageView.frame.size.height + ADD_Y;
    _roomNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, y,  self.picImageView.frame.size.width , self.frame.size.height - y) textString:@"直播间名称" textColor:MAIN_TEXT_COLOR textFont:MAIN_TEXT_FONT];
    _roomNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_roomNameLabel];
}

- (void)addClickButton
{
    _clickButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) buttonTitle:@"" titleColor:nil normalBackgroundColor:nil highlightedBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] selectorName:@"" tagDelegate:nil];
    [self addSubview:_clickButton];
}

@end
