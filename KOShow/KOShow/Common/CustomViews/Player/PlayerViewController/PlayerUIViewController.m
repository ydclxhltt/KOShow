//
//  PlayerUIViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/6.
//  Copyright © 2015年 chenlei. All rights reserved.
//


#import "PlayerUIViewController.h"


@interface PlayerUIViewController()

@end

@implementation PlayerUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIWithType:self.playerViewType];
    [self addTapGesture];
}


#pragma mark 初始化UI
- (void)initUIWithType:(PlayerViewType)playerViewType
{
    [self addSmallTopView];
    [self addFullTopView];
    if (playerViewType == PlayerViewTypeVideo)
    {
        [self addVideoBottomView];
    }
    else
    {
        [self addLiveSmallBottomView];
        [self addLiveFullBottomView];
    }
}

/***点播直播共用***/
//小Top
- (void)addSmallTopView
{
    _topSmallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVBAR_HEIGHT + STATUS_BAR_HEIGHT)];
    _topSmallView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topSmallView];
    
    UIImage *backImage = [UIImage imageNamed:@"player_back_up"];
    float y = (NAVBAR_HEIGHT - backImage.size.height/3)/2 + STATUS_BAR_HEIGHT;
    UIButton *backButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, y, backImage.size.width/3, backImage.size.height/3) buttonImage:@"player_back" selectorName:@"smallViewBackButtonPressed:" tagDelegate:self];
    [_topSmallView addSubview:backButton];

}

//大Top
- (void)addFullTopView
{
    _fullTopControlView = [[PlayerFullTopControlView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, STATUS_BAR_HEIGHT + NAVBAR_HEIGHT) roomName:@"我的直播间之炉石传说" buttonArray:@[@"超清",(self.playerViewType == PlayerViewTypeLive) ? @"关注" : @"收藏"]];
    _fullTopControlView.delegate = self;
    _fullTopControlView.hidden = YES;
    [self.view addSubview:_fullTopControlView];
}

/***点播***/

//点播大小bottom
- (void)addVideoBottomView
{
    _videoBottomControlView = [[PlayerBottomControlView alloc] initWithFrame:CGRectMake(0, SMALL_HEIGHT - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    _videoBottomControlView.delegate = self;
    _videoBottomControlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_videoBottomControlView];
}

/***直播***/

//直播小底部
- (void)addLiveSmallBottomView
{
    UIImage *image = [UIImage imageNamed:@"play_fullscreen_up"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    
    _liveSmallBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SMALL_HEIGHT - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    [self.view addSubview:_liveSmallBottomView];
    
    float y = (_liveSmallBottomView.frame.size.height - height)/2;
    UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenButton.frame = CGRectMake(self.view.frame.size.width - SPACE_X - width , y, width, height);
    [fullScreenButton addTarget:self action:@selector(playerBottomControlViewSwitchScreenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [fullScreenButton setBackgroundImage:image forState:UIControlStateNormal];
    [_liveSmallBottomView addSubview:fullScreenButton];
 
}

//直播大底部
- (void)addLiveFullBottomView
{
    _liveFullBottomView = [[PlayerLiveFullBottomControlView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - BOTTOM_HEIGHT, SCREEN_HEIGHT, BOTTOM_HEIGHT)];
    _liveFullBottomView.hidden = YES;
    [self.view addSubview:_liveFullBottomView];
}

#pragma mark 返回按钮
- (void)smallViewBackButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playerFullTopControlViewBackButtonPressed:(UIButton *)sender
{
    [self playerBottomControlViewSwitchScreenButtonPressed:sender];
}

#pragma mark 播放/暂停
- (void)playerBottomControlViewPlayButtonPressed:(UIButton *)sender
{

}

#pragma mark 切换小/全屏
- (void)playerBottomControlViewSwitchScreenButtonPressed:(UIButton *)sender
{
    
}

#pragma mark 进度
- (void)playerBottomControlViewSlider:(UISlider *)sender ValueChanged:(NSTimeInterval)interval isFinished:(BOOL)isFinish
{
    
}


#pragma mark 添加手势
- (void)addTapGesture
{
    //添加屏幕单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandler:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)tapGestureHandler:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    if (self.playerViewSize == PlayerViewSizeSmallScreen)
    {
        if (self.playerViewType == PlayerViewTypeVideo)
        {
            if(!CGRectContainsPoint(self.videoBottomControlView.frame, point) && !CGRectContainsPoint(self.topSmallView.frame, point))
            {
                if (self.videoBottomControlView)
                {
                    [self.videoBottomControlView setHidden:!self.videoBottomControlView.isHidden];
                }
                [self.topSmallView setHidden:!self.topSmallView.isHidden];
            }
        }
        else
        {
            if(!CGRectContainsPoint(self.liveSmallBottomView.frame, point) && !CGRectContainsPoint(self.topSmallView.frame, point))
            {
                if (self.liveSmallBottomView)
                {
                    [self.liveSmallBottomView setHidden:!self.liveSmallBottomView.isHidden];
                }
                [self.topSmallView setHidden:!self.topSmallView.isHidden];
            }

        }

    }
    else
    {
        if (self.playerViewType == PlayerViewTypeVideo)
        {
            if(!CGRectContainsPoint(self.videoBottomControlView.frame, point) && !CGRectContainsPoint(self.fullTopControlView.frame, point))
            {
                if (self.videoBottomControlView)
                {
                    [self.videoBottomControlView setHidden:!self.videoBottomControlView.isHidden];
                }
                [self.fullTopControlView setHidden:!self.fullTopControlView.isHidden];
            }
        }
        else
        {
            if(!CGRectContainsPoint(self.liveFullBottomView.frame, point) && !CGRectContainsPoint(self.fullTopControlView.frame, point))
            {
                if (self.liveFullBottomView)
                {
                    [self.liveFullBottomView setHidden:!self.liveFullBottomView.isHidden];
                }
                [self.fullTopControlView setHidden:!self.fullTopControlView.isHidden];
            }
        }
    }

}


#pragma mark 状态栏显示
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    
}



@end
