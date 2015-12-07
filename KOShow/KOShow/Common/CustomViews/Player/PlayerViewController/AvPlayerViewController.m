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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
        
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
             dispatch_async(dispatch_get_main_queue(),^{
                [self prepareToPlayAsset:asset withKeys:requestedKeys];
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
    self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time)
    {
        CGFloat currentTime = CMTimeGetSeconds(time);
        [weakSelf.videoBottomControlView setSlideValue:currentTime / weakSelf.videoBottomControlView.videoDuration];
    }];
    
    if(!_videoView)
    {
        self.videoView = [[AvVideoView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SMALL_HEIGHT)];
        _videoView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoView.player = _videoPlayer;
        [_videoView setFillMode:AVLayerVideoGravityResizeAspectFill];
        [self.view insertSubview:_videoView belowSubview:self.videoBottomControlView];
    }
    [self.view sendSubviewToBack:_videoView];
    
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


#pragma mark 设置方位
-(void)turnToPortraint
{
    [[UIApplication sharedApplication]setStatusBarOrientation:UIDeviceOrientationPortrait animated:YES];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformMakeRotation(0);
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.videoView.frame = CGRectMake(0, 0, _originFrame.size.width,  _originFrame.size.height);
        if (self.videoBottomControlView)
        {
            self.videoBottomControlView.frame = CGRectMake(0, _originFrame.size.height - BOTTOM_HEIGHT, _originFrame.size.width, BOTTOM_HEIGHT);
            [ self.videoBottomControlView resetFrame];
        }
        self.topSmallView.hidden = NO;
        self.fullTopControlView.hidden = YES;
    }
    completion:^(BOOL finished)
     {

    }];
}

-(void)turnToLeft
{
    
    [UIView animateWithDuration:0.5f animations:^{
         CGRect frect = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.view.frame = frect;
        self.view.center = CGPointMake(frect.size.height/2, frect.size.width/2);
        self.videoView.frame = CGRectMake(0, 0, frect.size.width,  frect.size.height);
        if (self.videoBottomControlView)
        {
            self.videoBottomControlView.frame = CGRectMake(0, frect.size.height - BOTTOM_HEIGHT, frect.size.width, BOTTOM_HEIGHT);
            [ self.videoBottomControlView resetFrame];
        }
        self.topSmallView.hidden = YES;
        self.fullTopControlView.hidden = NO;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    completion:^(BOOL finished)
    {
        
    }];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
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
                [self.videoBottomControlView setIsPlaying:YES];
                [self.videoBottomControlView setIsControlEnable:YES];
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                self.videoBottomControlView.videoDuration = duration;
            }
                break;
            case AVPlayerStatusFailed:
            {
                [self.videoBottomControlView setIsPlaying:NO];
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                [self.videoBottomControlView setIsPlaying:NO];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 播放/暂停
- (void)playerBottomControlViewPlayButtonPressed:(UIButton *)sender
{
    if(self.videoPlayer.rate > 0)
    {
        self.videoBottomControlView.isPlaying = NO;
        [self.videoPlayer pause];
    }
    else
    {
        self.videoBottomControlView.isPlaying = YES;
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
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
