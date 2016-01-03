//
//  RequestUrlHeader.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/3.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#ifndef GeniusWatch_RequestUrlHeader_h
#define GeniusWatch_RequestUrlHeader_h

#define SERVER_URL                  @"http://zhouqiubo.vicp.cc:9998/koi"
//#define SERVER_URL                  @"http://1.199.40.187:8086/koi"

#define MAKE_REQUEST_URL(inf)       [NSString stringWithFormat:@"%@%@",SERVER_URL,inf]

//登录服务器
#define LOGIN_SERVER_URL            MAKE_REQUEST_URL(@"/user/loginServer.shtml")

//登录
#define USER_LOGIN_URL              MAKE_REQUEST_URL(@"/user/login.shtml")

//注册
#define USER_REGISTER_URL           MAKE_REQUEST_URL(@"/user/register.shtml")

//获取验证码
#define GET_CODE_URL                MAKE_REQUEST_URL(@"/home/sendMsg.shtml")

//忘记密码
#define REG_CHANGEPWD_URL           MAKE_REQUEST_URL(@"login/postAccountPassword")

//修改密码
#define CHG_PWD_URL                 MAKE_REQUEST_URL(@"user/changepwd")

//退出登录
#define EXIT_URL                    MAKE_REQUEST_URL(@"user/logout")

//获取礼物接口
#define GET_GIFT_LIST_URL           MAKE_REQUEST_URL(@"/zb/giftlist.shtml")

//首页列表
#define INDEX_PAGE_URL              MAKE_REQUEST_URL(@"/home/zbRoomList.shtml")

//获取直播列表
#define LIVE_ROOM_LIST_URL          MAKE_REQUEST_URL(@"/zb/zblist.shtml")

//主播详情
#define ANCHOR_DETAIL_URL           MAKE_REQUEST_URL(@"/zb/introduce.shtml")

//排行
#define RANK_LIST_URL               MAKE_REQUEST_URL(@"/zb/giftRank.shtml")

//意见反馈
#define FEEDBACK_URL                MAKE_REQUEST_URL(@"static/feedback")


//用户协议
#define USER_NOTICE_URL             MAKE_REQUEST_URL(@"static/license")

#endif
