//
//  BasicMessage.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYS_VER 0001


/***************************************************************
 * 消息类型定义，详见文档空中网客户端与视频聊天服务端协议.doc
 ***************************************************************/

/**
 * 消息类型: 未定义的消息，方便以后在不改协议栈的情况下客户端可扩充消息类型
 */
#define CMD_TYPE_others -1

/**
 * 消息类型: 心跳包
 * 对应GMesage:<br/>
 * {@link #GRequestHeart}
 */
#define CMD_USER_HEARTBEAT 0x10000005
/**
 * 消息类型：心跳应答
 * 对应GMesage:<br/>
 * {@link #GRespondHeart}
 */
#define CMD_USER_HEARTBEAT_ACK 0x10000006

/**
 * 消息类型：进入房间
 * 对应GMesage:<br/>
 * {@link #GRequest_0x10000011_RoomLogin}
 */
#define CMD_ROOM_LOGIN 0x10000011
/**
 * 消息类型：进入房间应答
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000012_RoomLogin}
 */
#define CMD_ROOM_LOGIN_ACK 0x10000012
/**
 * 消息类型：退出房间
 * 对应GMesage:<br/>
 * {@link #GRequest_0x10000013_RoomLogout}
 */
#define CMD_ROOM_LOGOUT 0x10000013
/**
 * 消息类型：退出房间应答
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000014_RoomLogout}
 */
#define CMD_ROOM_LOGOUT_ACK 0x10000014
/**
 * 消息类型：房间聊天消息
 * 对应GMesage:<br/>
 * {@link #GRequest_0x10000017_RoomMsg}
 */
#define CMD_ROOM_MSG 0x10000017
/**
 * 消息类型：房间聊天消息应答
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000018_RoomMsg}
 */
#define  CMD_ROOM_MSG_ACK 0x10000018

/**
 * 消息类型：发送礼物消息
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000028_RoomGift}
 */
#define  CMD_ROOM_GIFT 0x10000028

/**
 * 消息类型：发送礼物应答
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000028_RoomGift}
 */
#define  CMD_ROOM_GIFT_ACK 0x10000029

/**
 * 消息类型：房间用户送礼通知
 * 对应GMesage:<br/>
 * {@link #GRespond_0x10000028_RoomGift}
 */
#define  CMD_ROOM_NTF_USER_GIFT 0x1000002A

/**
 * 接收到的数据长度不正确
 */
#define ERROR_RESPONSE_LENGTH 1

/**
 * 接收到的命令不正确
 */
#define ERROR_RESPONSE_COMMAND 2

/**
 * 消息头长度
 */
#define MESSAGE_HEADER_LENGTH 10

/**
 * 协议版本号长度
 */
#define MESSAGE_VERSION_LENGTH 2

/**
 * 命令码长度
 */
#define MESSAGE_COMMEND_LENGTH 4

/**
 * 消息总长度
 */
#define MESSAGE_ALL_LENGTH 4

/**
 * 房间ID长度
 */
#define ROOMID_LENGTH  4

@interface BasicMessage : NSObject

//创建 CMD_USER_HEARTBEAT 数据包
+ (NSMutableData *)buildHeartBeatRequest;

//创建 CMD_ROOM_LOGIN 数据包
+ (NSMutableData *)buildRoomLoginRequestWithAccount:(NSString *)account
                                        andNickName:(NSString *)nickName
                                          andRoomID:(NSString *)roomID;

//创建 CMD_ROOM_LOGOUT 数据包
+ (NSMutableData *)buildRoomLogoutRequest;

//创建 CMD_ROOM_MSG 数据包
//+ (void)buildRoomMsgRequest:(NSMutableData *)requestData andType:(int)msgType 
//                     andMsg:(NSString *)msg andRoomId:(int)roomId;
+ (NSMutableData *)buildRoomMsgRequestWithType:(int)msgType
                                    andMessage:(NSString *)message;

//创建 CMD_ROOM_GIFT 数据包
+ (NSMutableData *)buildRoomGiftRequestWithGiftID:(NSString *)giftID andAnchorID:(NSString *)anchorID andGiftCount:(int)giftCount;

//创建数据包
+ (void)buildRequestWithData:(NSMutableData *)requestData andBody:(NSData *)body andCommand:(int)command;


//以下全部是解析不同协议数据包

+ (void)parseRoomMsgAckResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict;
+ (void)parseRoomMsgResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict;
+ (NSMutableDictionary *)parseResponse:(NSData *)buffer;
+ (void)parseRoomLoginAckResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict;
+ (void)parseRoomGiftAckResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict;
+ (void)parseRoomGiftResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict;
+ (void)cleanBufferData;
@end
