//
//  PlayerControlView.h
//  AvPlayer
//
//  Created by clei on 15/9/14.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerBottomControlViewDelegate;

@interface PlayerBottomControlView : UIView

@property (nonatomic, assign) id<PlayerBottomControlViewDelegate> delegate;
@property (nonatomic, assign) CGFloat videoDuration;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isControlEnable;

-(void)setSlideValue:(CGFloat)value;
- (void)resetFrame;

@end

@protocol PlayerBottomControlViewDelegate <NSObject>

@optional

- (void)playPauseButtonPressed:(UIButton *)sender;
- (void)playerBottomControlViewSwitchScreenButtonPressed:(UIButton *)sender;
- (void)playerBottomControlViewSlider:(UISlider *)sender ValueChanged:(NSTimeInterval)interval isFinished:(BOOL)isFinish;

@end
