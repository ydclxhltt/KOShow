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

@interface PlayerLiveFullBottomControlView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *playRefreshButton;
@property (nonatomic, strong) UIButton *playGiftButton;
@property (nonatomic, strong) UIButton *playDanmuButton;
@property (nonatomic, strong) UITextField *danmuTextField;
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation PlayerLiveFullBottomControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = PLAYER_CONTROL_VIEW_COLOR;
        self.originFrame = frame;
        [self initUI];
        [self addNotifications];
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
    _danmuTextField.delegate = self;
    _danmuTextField.returnKeyType = UIReturnKeySend;
    [self addSubview:_danmuTextField];
    
    float x = self.frame.size.width - SPACE_X - width;
    _playGiftButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, width, height) buttonImage:@"land_gift" selectorName:@"playGiftButtonPressed:" tagDelegate:self];
    [self addSubview:_playGiftButton];
    
    x -= (ADD_X + _playGiftButton.frame.size.width);
    _playDanmuButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, width, height) buttonImage:@"close_danmu" selectorName:@"playDanmuButtonPressed:" tagDelegate:self];
    [_playDanmuButton setBackgroundImage:[UIImage imageNamed:@"show_danmu_up"] forState:UIControlStateSelected];
    [self addSubview:_playDanmuButton];
}


#pragma mark 设置图标
-(void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if(_isPlaying)
    {
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_up"] forState:UIControlStateNormal];
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_down"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"play_up"] forState:UIControlStateNormal];
        [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"play_down"] forState:UIControlStateHighlighted];
    }
}

#pragma mark 播放/暂停 
- (void)playPauseButtonPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playPauseButtonPressed:)])
    {
        [self.delegate playPauseButtonPressed:sender];
    }
}

#pragma mark 刷新
- (void)playRefreshButtonPressed:(UIButton *)sender
{
    [self reSetFrame];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerLiveRefreshButtonPressed:)])
    {
        [self.delegate playerLiveRefreshButtonPressed:sender];
    }
}

#pragma mark 弹幕
- (void)playDanmuButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark 礼物
- (void)playGiftButtonPressed:(UIButton *)sender
{
    [self reSetFrame];
}

#pragma mark 添加通知
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppearanceNotinficaiton:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyBoardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = self.frame;
    frame.origin.y -= keyBoardSize.height;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
                         weakSelf.frame = (notification.name == UIKeyboardWillShowNotification) ? frame : self.originFrame;
                     }];
}


#pragma mark 重置frame
- (void)reSetFrame
{
    [self.danmuTextField resignFirstResponder];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
