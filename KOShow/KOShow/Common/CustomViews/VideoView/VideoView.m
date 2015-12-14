//
//  VideoView.m
//  KOShow
//
//  Created by 陈磊 on 15/11/27.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADD_Y                   5.0 * CURRENT_SCALE
#define ROOM_PIC_HEIGHT         100.0 * CURRENT_SCALE
#define INFOVIEW_HEIGHT         20.0
#define INFOVIEW_BG_COLOR       RGBA(0.0,0.0,0.0,0.6)
#define ICON_WH                 10.0
#define COUNT_LABEL_WIDTH       30.0 * CURRENT_SCALE

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
    NSArray *array = @[@"http://img.blog.163.com/photo/oIEPVeb_WudfnaSAHaTX7A==/3443283390101808506.jpg",@"http://upload.chinaz.com/2015/1124/1448355948292.jpg",@"http://www.hinews.cn/pic/0/15/25/46/15254699_007721.jpg",@"http://img1.91.com/uploads/allimg/150403/750-150403164639-55.jpg",@"http://g.hiphotos.baidu.com/zhidao/pic/item/f703738da97739128dbe78e3fa198618377ae29c.jpg",@"http://spiderdaily.wayi.com.tw/upload/images/20120711h7.jpg",@"http://i1.mopimg.cn/img/dzh/2014-11/1400/20141117160158401.jpg"];
    _picImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, ROOM_PIC_HEIGHT) placeholderImage:nil];
    [_picImageView setImageWithURL:[NSURL URLWithString:array[arc4random() % [array count]]] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",arc4random()%6 + 1]]];
    [self addSubview:_picImageView];
}

- (void)addRoomInfoView
{
    UIImageView *infoView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, ROOM_PIC_HEIGHT - INFOVIEW_HEIGHT, self.frame.size.width, INFOVIEW_HEIGHT) placeholderImage:nil];
    infoView.backgroundColor = INFOVIEW_BG_COLOR;
    [self addSubview:infoView];
    
    float x = SPACE;
    UIImageView *anchorIconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(SPACE, (INFOVIEW_HEIGHT - ICON_WH)/2, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"icon_anchor"]];
    [infoView addSubview:anchorIconImageView];
    
    x += anchorIconImageView.frame.size.width + SPACE;
    _anchorNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0, infoView.frame.size.width/2 - x , infoView.frame.size.height) textString:@"主播" textColor:[UIColor whiteColor] textFont:FONT(12.0)];
    [infoView addSubview:_anchorNameLabel];
    
    x = infoView.frame.size.width - SPACE - COUNT_LABEL_WIDTH;
    _userCountLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0, COUNT_LABEL_WIDTH, infoView.frame.size.height) textString:@"1234" textColor:[UIColor whiteColor] textFont:FONT(12.0)];
    [infoView addSubview:_userCountLabel];
    
    x -= (ICON_WH + SPACE);
    UIImageView *countIconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, (INFOVIEW_HEIGHT - ICON_WH)/2, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"icon_count"]];
    [infoView addSubview:countIconImageView];
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
