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
#define BUTTON_WIDTH    66.0
#define BUTTON_HEIGHT   44.0
#define SPACE_Y         10.0
#define ICON_WH         15.0

#import "BasicViewController.h"
#import "PlayerBottomControlView.h"
#import "PlayerFullTopControlView.h"
#import "PlayerLiveFullBottomControlView.h"
#import "RoomToolBarView.h"

@interface PlayerUIViewController : BasicViewController<PlayerFullTopControlViewDelegate,PlayerBottomControlViewDelegate,PlayerLiveFullBottomControlViewDelegate>

@property (nonatomic, assign) PlayerViewType playerViewType;
@property (nonatomic, assign) PlayerViewSize playerViewSize;
@property (nonatomic, strong) UIView *downSideView;
@property (nonatomic, strong) UIView *upSideView;
@property (nonatomic, strong) PlayerBottomControlView *videoBottomControlView;      //点播大小下
@property (nonatomic, strong) PlayerFullTopControlView *fullTopControlView;         //点播直播大上
@property (nonatomic, strong) UIView *topSmallView;                                 //点播直播小上
@property (nonatomic, strong) UIView *liveSmallBottomView;                          //直播小下
@property (nonatomic, strong) PlayerLiveFullBottomControlView *liveFullBottomView;  //直播大下
@property (nonatomic, strong) RoomToolBarView *roomToolBarView;                     //直播大下
@property (nonatomic, strong) UILabel *countLabel;                                  //点击人数

@end


