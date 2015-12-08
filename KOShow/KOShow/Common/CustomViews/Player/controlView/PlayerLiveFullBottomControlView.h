//
//  PlayerLiveFullBottomControlView.h
//  KOShow
//
//  Created by 陈磊 on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerLiveFullBottomControlViewDelegate;

@interface PlayerLiveFullBottomControlView : UIView

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) id<PlayerLiveFullBottomControlViewDelegate> delegate;

- (void)reSetFrame;

@end

@protocol PlayerLiveFullBottomControlViewDelegate <NSObject>

@optional

- (void)playPauseButtonPressed:(UIButton *)sender;
- (void)playerLiveDanmuButtonPressed:(UIButton *)sender;
- (void)playerLiveGiftButtonPressed:(UIButton *)sender;
- (void)playerLiveRefreshButtonPressed:(UIButton *)sender;
@end
