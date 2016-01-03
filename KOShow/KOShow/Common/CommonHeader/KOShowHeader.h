//
//  KOShowHeader.h
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#ifndef KOShowHeader_h
#define KOShowHeader_h


/******产品*****/
//产品名
#define PRODUCT_NAME               @"kzzb"
//版本号
#define PRODUCT_VERSION            @"01.00"
//渠道号
#define CHANNEL_ID                 @"0001"
//平台
#define PLATFORM                   @"IOS"
//系统版本号
#define SYSTEM_VERSION             [[UIDevice currentDevice] systemVersion]


/******首页*****/

//HeaderViewHeight
#define HEADERVIEW_HEIGHT          36.0 * CURRENT_SCALE
//RoomListHeight
#define ROOM_LIST_HEIGHT           144.0 * CURRENT_SCALE
//AnchorHeight
#define ANCHORVIEW_HEIGHT          135.0 * CURRENT_SCALE
//HeaderViewFont
#define HEADERVIEW_FONT            FONT(15.0)
//HeaderViewTEXTFont
#define HEADERVIEW_T_COLOR         RGB(53.0,54.0,55.0)
//left_right_space
#define SPACE                      5.0 * CURRENT_SCALE
//ICON_LAYER_COLOR
#define LAYER_COLOR                RGB(230.0, 230.0, 230.0)
//主播列表 点播列表  字体
#define MAIN_TEXT_COLOR            RGB(54.0, 55.0, 56.0)
#define DETAIL_TEXT_COLOR          RGB(122.0, 123.0, 124.0)
#define MAIN_TEXT_FONT             (SCREEN_WIDTH == 320.0) ? BOLD_FONT(13.0) : BOLD_FONT(14.0)
#define DETAIL_TEXT_FONT           (SCREEN_WIDTH == 320.0) ? FONT(12.0) : FONT(13.0)

/*****我的*****/
#define MINE_ROW_HEIGHT            50.0

/*****房间和点播界面*****/
#define BUTTON_BAR_HEIGHT          44.0
#define TOOL_BAR_HEIGHT            49.0
#define BUTTON_BAR_COLOR           RGB(34.0,34.0,34.0)
#define COMMENT_ROW_HEIGHT         60.0

/*****播放器*****/
#define SMALL_HEIGHT               225.0 * CURRENT_SCALE
#define PLAYER_SPACE_X             15.0
#define PLAYER_CONTROL_VIEW_COLOR  RGBA(0.0,0.0,0.0,0.7)
#define LINE_COLOR                 RGB(107.0,107.0,107.0)
#define LINT_WIDTH                 0.5



#endif /* KOShowHeader_h */
