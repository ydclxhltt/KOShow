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
    [self initUI];
    [self addTapGesture];
}


#pragma mark 初始化UI
- (void)initUI
{
    [self addDownSideView];
    [self addUpSideView];
}

#pragma mark ****上半部分视图****
- (void)addUpSideView
{
    _upSideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SMALL_HEIGHT)];
    _upSideView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_upSideView aboveSubview:_downSideView];
    
    [self addSmallTopView];
    [self addFullTopView];
    if (self.playerViewType == PlayerViewTypeVideo)
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
    [self.upSideView addSubview:_topSmallView];
    
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
    [self.upSideView addSubview:_fullTopControlView];
}

/***点播***/

//点播大小bottom
- (void)addVideoBottomView
{
    _videoBottomControlView = [[PlayerBottomControlView alloc] initWithFrame:CGRectMake(0, SMALL_HEIGHT - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    _videoBottomControlView.delegate = self;
    _videoBottomControlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.upSideView addSubview:_videoBottomControlView];
}

/***直播***/

//直播小底部
- (void)addLiveSmallBottomView
{
    UIImage *image = [UIImage imageNamed:@"play_fullscreen_up"];
    float width = image.size.width/3;
    float height = image.size.height/3;
    
    _liveSmallBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SMALL_HEIGHT - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    [self.upSideView addSubview:_liveSmallBottomView];
    
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
    _liveFullBottomView.delegate = self;
    _liveFullBottomView.hidden = YES;
    [self.upSideView addSubview:_liveFullBottomView];
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
- (void)playPauseButtonPressed:(UIButton *)sender
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

#pragma mark 刷新
- (void)playerLiveRefreshButtonPressed:(UIButton *)sender
{
    
}


#pragma mark ****下半部分视图****
- (void)addDownSideView
{
    _downSideView = [[UIView alloc] initWithFrame:CGRectMake(0, SMALL_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SMALL_HEIGHT)];
    _downSideView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_downSideView];
    
    [self addButtonBarView];
    [self addToolBarView];
}

- (void)addButtonBarView
{
    UIImageView *buttonBarView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BUTTON_BAR_HEIGHT) placeholderImage:nil];
    buttonBarView.backgroundColor = BUTTON_BAR_COLOR;
    [self.downSideView addSubview:buttonBarView];
    
    [self addButtons];
}

- (void)addButtons
{
    NSArray *imageArray = (self.playerViewType == PlayerViewTypeVideo) ? @[@"video_comment",@"video_introduce",@""] : @[@"live_chat",@"live_anchor",@"live_rank"];
    float itemWidth = self.view.frame.size.width/3;
    float itemHeight = BUTTON_BAR_HEIGHT;
    float buttonWidth = BUTTON_WIDTH;
    float buttonHeight = BUTTON_HEIGHT;
    float x = (itemWidth - buttonWidth)/2;
    float y = (itemHeight - buttonHeight)/2;
    
    for (int i = 0; i < [imageArray count]; i++)
    {
        NSString *imageName = imageArray[i];
        if (imageName.length > 0)
        {
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight) buttonImage:imageName selectorName:@"buttonBarButtonPressed:" tagDelegate:self];
            button.tag = 100 + i;
            [self.downSideView addSubview:button];
            if (i == 0)
            {
                [self buttonBarButtonPressed:button];
            }
            x += itemWidth;
        }
        else
        {
            UIImageView *iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, (itemHeight - ICON_WH)/2, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"icon_online_gray"]];
            [self.downSideView addSubview:iconImageView];
            
            x = iconImageView.frame.origin.x + iconImageView.frame.size.width;
            
            _countLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0, itemWidth - (itemWidth - buttonWidth) - iconImageView.frame.size.width, BUTTON_BAR_HEIGHT) textString:@" 1234" textColor:DETAIL_TEXT_COLOR textFont:FONT(14.0)];
            [self.downSideView addSubview:_countLabel];
        }
        if (i != [imageArray count] - 1)
        {
            UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(itemWidth * (i + 1), y + SPACE_Y, LINT_WIDTH, buttonHeight - 2 * (y + SPACE_Y)) placeholderImage:nil];
            imageView.backgroundColor = LINE_COLOR;
            [self.downSideView addSubview:imageView];
        }
        
    }
}

- (void)addToolBarView
{
    _roomToolBarView = [[RoomToolBarView alloc] initWithFrame:CGRectMake(0, self.downSideView.frame.size.height - TOOL_BAR_HEIGHT, self.view.frame.size.width, TOOL_BAR_HEIGHT) toolBarType:(self.playerViewType == PlayerViewTypeLive) ? RoomToolBarViewTypeChat : RoomToolBarViewTypeComment];
    [self.downSideView addSubview:_roomToolBarView];
}


#pragma mark  功能按钮响应事件
- (void)buttonBarButtonPressed:(UIButton *)sender
{
    
}



#pragma mark ****添加手势****
- (void)addTapGesture
{
    //添加屏幕单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandler:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.upSideView addGestureRecognizer:tapGesture];
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
                [[UIApplication sharedApplication] setStatusBarHidden:!([UIApplication sharedApplication].statusBarHidden) withAnimation:UIStatusBarAnimationFade];
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
                [[UIApplication sharedApplication] setStatusBarHidden:!([UIApplication sharedApplication].statusBarHidden) withAnimation:UIStatusBarAnimationFade];
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
                [[UIApplication sharedApplication] setStatusBarHidden:!([UIApplication sharedApplication].statusBarHidden) withAnimation:UIStatusBarAnimationFade];
            }
        }
        else
        {
            if(!CGRectContainsPoint(self.liveFullBottomView.frame, point) && !CGRectContainsPoint(self.fullTopControlView.frame, point))
            {
                if (self.liveFullBottomView)
                {
                    [self.liveFullBottomView reSetFrame];
                    [self.liveFullBottomView setHidden:!self.liveFullBottomView.isHidden];
                }
                [self.fullTopControlView setHidden:!self.fullTopControlView.isHidden];
                [[UIApplication sharedApplication] setStatusBarHidden:!([UIApplication sharedApplication].statusBarHidden) withAnimation:UIStatusBarAnimationFade];
            }
        }
    }

}


#pragma mark ****状态栏显示****
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    
}



@end
