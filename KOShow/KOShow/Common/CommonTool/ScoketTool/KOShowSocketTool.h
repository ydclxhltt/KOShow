//
//  KOShowSocketTool.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  KOShowSocketDelegate;

@interface KOShowSocketTool : NSObject

@property (nonatomic, assign) id<KOShowSocketDelegate> delegate;

/*
 * 登录服务器
 */
- (void)contentServerWithIp:(NSString *)serverIp port:(int)port;

/*
 * 发送心跳包
 */
- (void)createHeartTimer;

/*
 * 登录房间
 */
- (void)sendLoginRoomRequestWithUserID:(NSString *)userID nickName:(NSString *)nickName roomID:(NSString *)roomID;

/*
 * 登出房间
 */
- (void)sendLogoutRoomRequest;

/*
 * 发送消息
 */
- (void)sendRoomMessageRequestWithType:(int)type message:(NSString *)message;

/*
 * 发送礼物
 */
- (void)sendRoomGiftRequestWithGiftID:(NSString *)giftID anchorID:(NSString *)anchorID giftCount:(int)giftCount;

/*
 * 断掉socket
 */
- (void)clearSocket;

@end

@protocol KOShowSocketDelegate <NSObject>

@optional

- (void)koShowSocketDidConnected:(KOShowSocketTool *)socket;
- (void)koShowSocketDidDisconnected:(KOShowSocketTool *)socket;
- (void)koShowSocketLoginRoomSucess:(KOShowSocketTool *)socket;
- (void)koShowSocketLoginRoomFailed:(KOShowSocketTool *)socket;
- (void)koShowSocketSendMessageSucess:(KOShowSocketTool *)socket;
- (void)koShowSocket:(KOShowSocketTool *)socket revicedMessageWithDictionary:(NSDictionary *)dataDic;
- (void)koShowSocket:(KOShowSocketTool *)socket revicedGiftWithDictionary:(NSDictionary *)dataDic;
@end
