//
//  AvPlayerViewController.m
//  AvPlayer
//
//  Created by clei on 15/9/14.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//-----------------播放器vc-----------------------



#import "AvPlayerViewController.h"
#import "AvVideoView.h"
#import "PlayerBottomControlView.h"
#import <AVFoundation/AVFoundation.h>

@interface AvPlayerViewController ()

@property (nonatomic, strong) AVPlayer *videoPlayer;                         //播放器
@property (nonatomic, strong) AvVideoView *videoView;                        //播放器显示层
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) id timeObserver;

@end

@implementation AvPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.originFrame = CGRectMake(0, 0, self.view.frame.size.width, SMALL_HEIGHT);
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.videoBottomControlView setIsPlaying:NO];
    [_videoPlayer pause];
}


#pragma mark 设置地址
-(void)setVideoUrl:(NSString *)videoUrl
{
    if(_videoUrl != videoUrl)
    {
        _videoUrl = videoUrl;
        if(_videoUrl == nil)
        {
            return;
        }
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_videoUrl] options:nil];
        NSArray *requestedKeys = @[@"playable"];
        
        __weak typeof(self) weakSelf = self;
        
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
             dispatch_async(dispatch_get_main_queue(),^{
                [weakSelf prepareToPlayAsset:asset withKeys:requestedKeys];
            });
        }];
    }
}

#pragma mark 准备播放
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    if (!asset.playable)
    {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    if (self.item)
    {
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.item addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:nil];
    
    if (!self.videoPlayer)
    {
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }
    
    if (self.videoPlayer.currentItem != self.item)
    {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.videoBottomControlView)
    {
        self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time)
                             {
                                 CGFloat currentTime = CMTimeGetSeconds(time);
                                 [weakSelf.videoBottomControlView setSlideValue:currentTime / weakSelf.videoBottomControlView.videoDuration];
                             }];
        
    }

    if(!_videoView)
    {
        self.videoView = [[AvVideoView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SMALL_HEIGHT)];
        _videoView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoView.player = _videoPlayer;
        [_videoView setFillMode:AVLayerVideoGravityResizeAspectFill];
        [self.upSideView insertSubview:_videoView atIndex:0];
    }
    
    [_videoPlayer play];
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}


-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}



#pragma mark 播放状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status)
        {
            case AVPlayerStatusReadyToPlay:
            {
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                if (self.videoBottomControlView)
                {
                    [self.videoBottomControlView setIsPlaying:YES];
                    [self.videoBottomControlView setIsControlEnable:YES];
                    self.videoBottomControlView.videoDuration = duration;
                }
                if (self.liveFullBottomView)
                {
                    [self.liveFullBottomView setIsPlaying:YES];
                }
            }
                break;
            case AVPlayerStatusFailed:
            {
                if (self.videoBottomControlView)
                {
                    [self.videoBottomControlView setIsPlaying:NO];
                }
                if (self.liveFullBottomView)
                {
                    [self.liveFullBottomView setIsPlaying:NO];
                }
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                if (self.videoBottomControlView)
                {
                    [self.videoBottomControlView setIsPlaying:NO];
                }
                if (self.liveFullBottomView)
                {
                    [self.liveFullBottomView setIsPlaying:NO];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 播放/暂停
- (void)playPauseButtonPressed:(UIButton *)sender
{
    if(self.videoPlayer.rate > 0)
    {
        if (self.videoBottomControlView)
        {
             self.videoBottomControlView.isPlaying = NO;
        }
        if (self.liveFullBottomView)
        {
            self.liveFullBottomView.isPlaying = NO;
        }
        [self.videoPlayer pause];
    }
    else
    {
        if (self.videoBottomControlView)
        {
            self.videoBottomControlView.isPlaying = YES;
        }
        if (self.liveFullBottomView)
        {
            self.liveFullBottomView.isPlaying = YES;
        }
        [self.videoPlayer play];
    }
}

#pragma mark 切换小/全屏
- (void)playerBottomControlViewSwitchScreenButtonPressed:(UIButton *)sender
{
    //全屏
    if(self.playerViewSize == PlayerViewSizeSmallScreen)
    {
        [self turnToLeft];
    }
    else
    {
        [self turnToPortraint];
    }
    self.playerViewSize = (self.playerViewSize == PlayerViewSizeSmallScreen) ? PlayerViewSizeFullScreen : PlayerViewSizeSmallScreen;
   [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if (self.playDataDic)
    {
        [self.fullTopControlView addRoomNameLabelWithName:self.playDataDic[@"title"]];
    }
    
}

#pragma mark 设置方位
-(void)turnToPortraint
{
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication]setStatusBarOrientation:UIDeviceOrientationPortrait animated:YES];
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.view.transform = CGAffineTransformMakeRotation(0);
        weakSelf.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        weakSelf.upSideView.frame = CGRectMake(0, 0, _originFrame.size.width,  _originFrame.size.height);
        weakSelf.videoView.frame = CGRectMake(0, 0, _originFrame.size.width,  _originFrame.size.height);
        if (weakSelf.videoBottomControlView)
        {
            weakSelf.videoBottomControlView.frame = CGRectMake(0, _originFrame.size.height - BOTTOM_HEIGHT, _originFrame.size.width, BOTTOM_HEIGHT);
            [weakSelf.videoBottomControlView resetFrame];
        }
        if (weakSelf.liveSmallBottomView)
        {
            weakSelf.liveSmallBottomView.hidden = NO;
        }
        if (weakSelf.liveFullBottomView)
        {
            [weakSelf.liveFullBottomView reSetFrame];
            weakSelf.liveFullBottomView.hidden = YES;
        }
        weakSelf.topSmallView.hidden = NO;
        weakSelf.fullTopControlView.hidden = YES;
    }
    completion:^(BOOL finished)
    {
         [weakSelf setBarrageRendererView];
    }];
    
}

-(void)turnToLeft
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frect = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        weakSelf.view.frame = frect;
        weakSelf.view.center = CGPointMake(frect.size.height/2, frect.size.width/2);
        weakSelf.upSideView.frame = CGRectMake(0, 0, frect.size.width,  frect.size.height);
        weakSelf.videoView.frame = CGRectMake(0, 0, frect.size.width,  frect.size.height);
        if (weakSelf.videoBottomControlView)
        {
            weakSelf.videoBottomControlView.frame = CGRectMake(0, frect.size.height - BOTTOM_HEIGHT, frect.size.width, BOTTOM_HEIGHT);
            [ weakSelf.videoBottomControlView resetFrame];
        }
        if (weakSelf.liveSmallBottomView)
        {
            weakSelf.liveSmallBottomView.hidden = YES;
        }
        if (weakSelf.liveFullBottomView)
        {
            weakSelf.liveFullBottomView.hidden = NO;
        }
        weakSelf.topSmallView.hidden = YES;
        weakSelf.fullTopControlView.hidden = NO;
        weakSelf.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    completion:^(BOOL finished)
     {
         [weakSelf setBarrageRendererView];
     }];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
}



#pragma mark 设置弹幕
- (void)setBarrageRendererView
{
    
}

#pragma mark 进度
- (void)playerBottomControlViewSlider:(UISlider *)sender ValueChanged:(NSTimeInterval)interval isFinished:(BOOL)isFinish
{
    if(isFinish)
    {
        //滑块拖动停止
        CMTime time = CMTimeMakeWithSeconds(interval, self.videoPlayer.currentItem.duration.timescale);
        [self.videoPlayer seekToTime:time completionHandler:^(BOOL finished)
        {
            [self.videoPlayer play];
             self.videoBottomControlView.isPlaying = YES;
        }];
    }
    else
    {
        if(self.videoPlayer.rate > 0)
        {
            self.videoBottomControlView.isPlaying = NO;
            [self.videoPlayer pause];
        }
    }

}


#pragma mark 刷新
- (void)playerLiveRefreshButtonPressed:(UIButton *)sender
{
    //[self setVideoUrl:self.videoUrl];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self removeTimeObserver];
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.videoPlayer cancelPendingPrerolls];
    self.fullTopControlView.delegate = nil;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
