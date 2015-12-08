//
//  PlayerControlView.m
//  AvPlayer
//
//  Created by clei on 15/9/14.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//-----------------自定义工具栏（播放，进度条等）-----------------------

typedef void (^ClickHandle)(NSInteger);
typedef void (^SlideHandle)(CGFloat,BOOL);

#import "PlayerBottomControlView.h"

#define KBASETAG        1000
#define SPACE_X         PLAYER_SPACE_X
#define ADD_X           10.0
#define SPACE_Y         5.0
#define SLIDER_HEIGHT   20.0

@interface PlayerBottomControlView ()

@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, strong) UIButton *fullscreenBtn;
@property (nonatomic, strong) UISlider *progress;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, assign) CGFloat  currentTime;

@end

@implementation PlayerBottomControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
        self.backgroundColor = PLAYER_CONTROL_VIEW_COLOR;

    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    float start_space_x = SPACE_X;
    float start_x = start_space_x;
    if (!_playPauseBtn)
    {
        UIImage *image = [UIImage imageNamed:@"play"];
        float width = image.size.width/3;
        float height = image.size.height/3;
        float y = (self.frame.size.height - height)/2;
         _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseBtn.frame = CGRectMake(start_x, y, width, height);
        [_playPauseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playPauseBtn setBackgroundImage:image forState:UIControlStateNormal];
        //[_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playPauseBtn setTag:KBASETAG + 1];
        [self addSubview:_playPauseBtn];
    }
   
    UIImage *image = [UIImage imageNamed:@"play_fullscreen_up"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    float y = (self.frame.size.height - height)/2;
    if (!_fullscreenBtn)
    {

        _fullscreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullscreenBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullscreenBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_fullscreenBtn setTag:KBASETAG + 2];
        [self addSubview:_fullscreenBtn];
    }
    _fullscreenBtn.frame = CGRectMake(self.frame.size.width - start_x - width , y, width, height);
    
    
    float add_x = ADD_X;
    start_x += _playPauseBtn.frame.size.width + add_x;
    float space_y = SPACE_Y;
    float progressView_height = SLIDER_HEIGHT;
    
    if (!_progress)
    {
        _progress = [[UISlider alloc] initWithFrame:CGRectMake(start_x, space_y, _fullscreenBtn.frame.origin.x  - add_x - start_x, progressView_height)];
        [_progress setValue:0];
        [_progress setThumbImage:[UIImage imageNamed:@"player_progress_point_up"] forState:UIControlStateNormal];
        [_progress setThumbImage:[UIImage imageNamed:@"player_progress_point_down"] forState:UIControlStateHighlighted];
        [_progress setTintColor:APP_MAIN_COLOR];
        [_progress addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
        [_progress addTarget:self action:@selector(moveEndAction:) forControlEvents:UIControlEventTouchUpInside];
        [_progress setTag:KBASETAG + 3];
        [self addSubview:_progress];
    }
    
    _progress.frame = CGRectMake(start_x, space_y, _fullscreenBtn.frame.origin.x  - add_x - start_x, progressView_height);

    float lable_y = _progress.frame.origin.y + _progress.frame.size.height;
    
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progress.frame.origin.x, lable_y, _progress.frame.size.width, self.frame.size.height - 2 * space_y - _progress.frame.size.height)];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        _timeLabel.font = FONT(14.0);
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_timeLabel];
    }
   _timeLabel.frame =  CGRectMake(_progress.frame.origin.x, lable_y, _progress.frame.size.width, self.frame.size.height - 2 * space_y - _progress.frame.size.height);

}

#pragma mark 设置视频时间
-(void)setVideoDuration:(CGFloat)videoDuration
{
    _videoDuration = videoDuration;
    
    [self updateProgressText];
}

-(void)setCurrentTime:(CGFloat)currentTime
{
    if(_currentTime != currentTime)
    {
        _currentTime = currentTime;
        
        [self updateProgressText];
    }
}

-(void)setSlideValue:(CGFloat)value
{
    [_progress setValue:value animated:YES];
    
    self.currentTime = value * _videoDuration;
}

-(void)updateProgressText
{
    _timeLabel.text = [NSString stringWithFormat:@"%@ / %@",[self getTimeString:_currentTime],[self getTimeString:_videoDuration]];
}

-(NSString *)getTimeString:(CGFloat)timeInterval
{
    NSInteger hour = timeInterval / 3600.f;
    NSInteger minute = (timeInterval - hour * 3600.f) / 60.f;
    NSInteger second = timeInterval - hour * 3600.f - minute * 60.f;
    
    if(hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
    }
}


#pragma mark 设置图标
-(void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if(_isPlaying)
    {
        [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else
    {
        [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

-(void)setIsControlEnable:(BOOL)isControlEnable
{
    _isControlEnable = isControlEnable;
    
    [_playPauseBtn setEnabled:_isControlEnable];
    [_fullscreenBtn setEnabled:_isControlEnable];
    [_progress setEnabled:_isControlEnable];
}

#pragma mark 按钮事件
-(void)buttonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag - KBASETAG;

    if (tag == 1)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerBottomControlViewPlayButtonPressed:)])
        {
            [self.delegate playerBottomControlViewPlayButtonPressed:sender];
        }
    }
    if (tag == 2)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerBottomControlViewSwitchScreenButtonPressed:)])
        {
            [self.delegate playerBottomControlViewSwitchScreenButtonPressed:sender];
        }
    }
}


-(void)slideAction:(UISlider *)slider
{
    CGFloat progress = slider.value;
    
    CGFloat interval = progress * _videoDuration;
    self.currentTime = interval;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBottomControlViewSlider:ValueChanged:isFinished:)])
    {
        [self.delegate playerBottomControlViewSlider:slider ValueChanged:self.currentTime isFinished:NO];
    }
}

-(void)moveEndAction:(UISlider *)slider
{
    CGFloat progress = slider.value;

    CGFloat interval = progress * _videoDuration;
    self.currentTime = interval;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBottomControlViewSlider:ValueChanged:isFinished:)])
    {
        [self.delegate playerBottomControlViewSlider:slider ValueChanged:self.currentTime isFinished:YES];
    }
}


#pragma mark 刷新Frame
- (void)resetFrame
{
    [self initUI];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

