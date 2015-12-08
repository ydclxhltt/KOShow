//
//  PlayerLiveFullBottomControlView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X     PLAYER_SPACE_X
#define ADD_X       15.0

#import "PlayerLiveFullBottomControlView.h"

@interface PlayerLiveFullBottomControlView()

@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *playRefreshButton;
@property (nonatomic, strong) UIButton *playGiftButton;
@property (nonatomic, strong) UIButton *playDanmuButton;
@property (nonatomic, strong) UITextField *danmuTextField;

@end

@implementation PlayerLiveFullBottomControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = PLAYER_CONTROL_VIEW_COLOR;
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    float start_space_x = SPACE_X;
    float start_x = start_space_x;
    UIImage *image = [UIImage imageNamed:@"play_up"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    float y = (self.frame.size.height - height)/2;
    
    _playPauseButton = [CreateViewTool createButtonWithFrame:CGRectMake(start_x, y, width, height) buttonImage:@"play" selectorName:@"playPauseButtonPressed:" tagDelegate:self];
    [self addSubview:_playPauseButton];
    
    start_x += ADD_X + _playPauseButton.frame.size.width;
    
    _playRefreshButton = [CreateViewTool createButtonWithFrame:CGRectMake(start_x, _playPauseButton.frame.origin.y, width, height) buttonImage:@"refresh" selectorName:@"playRefreshButtonPressed:" tagDelegate:self];
    [self addSubview:_playRefreshButton];
    
    start_x += ADD_X + _playRefreshButton.frame.size.width;
    
    _danmuTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(start_x, _playRefreshButton.frame.origin.y, self.frame.size.width - 2 * start_x, _playRefreshButton.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入弹幕...."];
    _danmuTextField.borderStyle = UITextBorderStyleRoundedRect ;
    _danmuTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:_danmuTextField];
    
    float x = self.frame.size.width - SPACE_X - width;
    _playGiftButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, width, height) buttonImage:@"land_gift" selectorName:@"playGiftButtonPressed:" tagDelegate:self];
    [self addSubview:_playGiftButton];
    
    x -= (ADD_X + _playGiftButton.frame.size.width);
    _playDanmuButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, width, height) buttonImage:@"close_danmu" selectorName:@"playGiftButtonPressed:" tagDelegate:self];
    [self addSubview:_playDanmuButton];
}



@end
