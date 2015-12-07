//
//  PlayerUIViewController.h
//  KOShow
//
//  Created by 陈磊 on 15/12/6.
//  Copyright © 2015年 chenlei. All rights reserved.
//

typedef enum : NSUInteger {
    PlayerViewTypeVideo,
    PlayerViewTypeLive,
} PlayerViewType;

typedef enum : NSUInteger {
    PlayerViewSizeSmallScreen,
    PlayerViewSizeFullScreen,
} PlayerViewSize;


#define BOTTOM_HEIGHT   44.0
#define SPACE_X         PLAYER_SPACE_X

#import "BasicViewController.h"
#import "PlayerBottomControlView.h"
#import "PlayerFullTopControlView.h"

@interface PlayerUIViewController : BasicViewController<PlayerFullTopControlViewDelegate,PlayerBottomControlViewDelegate>

@property (nonatomic, assign) PlayerViewType playerViewType;
@property (nonatomic, assign) PlayerViewSize playerViewSize;
@property (nonatomic, strong) PlayerBottomControlView *videoBottomControlView;  //点播大小下
@property (nonatomic, strong) PlayerFullTopControlView *fullTopControlView;     //点播直播大上
@property (nonatomic, strong) UIView *topSmallView;                             //点播直播小上
@property (nonatomic, strong) UIView *liveBottomSmallView;                      //直播小下

@end

