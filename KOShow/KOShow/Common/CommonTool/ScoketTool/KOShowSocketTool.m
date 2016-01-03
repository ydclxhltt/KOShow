//
//  KOShowSocketTool.m
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define HEART_CIRCLE_TIME   10

#import "KOShowSocketTool.h"
#import "SocketManager.h"
#import "BasicMessage.h"

@interface KOShowSocketTool()<SocketManagerDelegate>

@property (nonatomic, strong) SocketManager *socketManager;
@property (nonatomic, strong) NSTimer *heartTimer;

@end

@implementation KOShowSocketTool

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _socketManager = [[SocketManager alloc] init];
        _socketManager.delegate = self;
    }
    return self;
}

#pragma mark 连接服务器
- (void)contentServerWithIp:(NSString *)serverIp port:(int)port
{
    [BasicMessage cleanBufferData];
    [self.socketManager connectServer:serverIp port:port];
}

#pragma mark 发送心跳包
- (void)createHeartTimer
{
    [self cancelHeartTimer];
    //[self sendHeartRequest];
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:HEART_CIRCLE_TIME target:self selector:@selector(sendHeartRequest) userInfo:nil repeats:YES];
}

- (void)cancelHeartTimer
{
    if (self.heartTimer && [self.heartTimer isValid])
    {
        [self.heartTimer invalidate];
        self.heartTimer = nil;
    }
}

- (void)sendHeartRequest
{
    NSMutableData *requestData = [BasicMessage buildHeartBeatRequest];
    NSLog(@"requestData===%@",requestData);
    [self.socketManager writeData:requestData];
}

#pragma mark 登录房间
- (void)sendLoginRoomRequestWithUserID:(NSString *)userID nickName:(NSString *)nickName roomID:(NSString *)roomID
{
    NSMutableData *requestData = [BasicMessage buildRoomLoginRequestWithAccount:userID andNickName:nickName andRoomID:roomID];
    [self.socketManager writeData:requestData];
}

#pragma mark 登出房间
- (void)sendLogoutRoomRequest
{
    NSMutableData *requestData = [BasicMessage buildRoomLogoutRequest];
    [self.socketManager writeData:requestData];
}

#pragma mark 发送消息
- (void)sendRoomMessageRequestWithType:(int)type message:(NSString *)message
{
    NSMutableData *requestData = [BasicMessage buildRoomMsgRequestWithType:type andMessage:message];
    [self.socketManager writeData:requestData];
}

#pragma mark 发送礼物
- (void)sendRoomGiftRequestWithGiftID:(NSString *)giftID anchorID:(NSString *)anchorID giftCount:(int)giftCount
{
    NSLog(@"giftID===%@",giftID);
    NSMutableData *requestData = [BasicMessage buildRoomGiftRequestWithGiftID:giftID andAnchorID:anchorID andGiftCount:giftCount];
    [self.socketManager writeData:requestData];
}


#pragma mark 断开连接
- (void)disableSocketConnect
{
    [self.socketManager disableConnectNow:YES];
}


#pragma mark sokcet是否连接
- (BOOL)isSocketConnected
{
    return [self.socketManager isConnected];
}

#pragma mark 重新连接
- (void)socketReconnect
{
    [self.socketManager reconnect];
}

#pragma mark SocketManagerDelegate
//连接成功
- (void)socketDidConnected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(koShowSocketDidConnected:)])
    {
        [self.delegate koShowSocketDidConnected:self];
    }
}
//连接成功
- (void)socketDidDisConnected
{
    [self cancelHeartTimer];

}
//发送数据成功
- (void)sendDataSuccess
{
    
}
//接收数据
- (void)readData:(NSData *)data
{
    NSMutableDictionary *dataDic = [BasicMessage parseResponse:data];
    NSLog(@"dataDic====%@",dataDic);
    int cmd = (int)[[dataDic valueForKey:@"command"] integerValue];
    int result = (int)[[dataDic valueForKey:@"result"] integerValue];
    if (dataDic[@"error"])
    {
        result = [dataDic[@"error"] intValue];
    }
    SEL sel = NULL;
    switch (cmd)
    {
        case CMD_ROOM_LOGIN_ACK:
            sel = (result == 0) ? @selector(koShowSocketLoginRoomSucess:) : @selector(koShowSocketLoginRoomFailed:);
            if (self.delegate && [self.delegate respondsToSelector:sel])
            {
                [self.delegate performSelector:sel withObject:self];
            }
            break;
        case CMD_USER_HEARTBEAT_ACK:
            break;
        case CMD_ROOM_MSG:
            NSLog(@"CMD_ROOM_MSG");
            if (self.delegate && [self.delegate respondsToSelector:@selector(koShowSocket:revicedMessageWithDictionary:)] && (result == 0))
            {
                [self.delegate koShowSocket:self revicedMessageWithDictionary:dataDic];
            }
            break;
        case CMD_ROOM_MSG_ACK:
            NSLog(@"CMD_ROOM_MSG_ACK");
            break;
        case CMD_ROOM_GIFT_ACK:
            NSLog(@"CMD_ROOM_GIFT_ACK");
            break;
        case CMD_ROOM_NTF_USER_GIFT:
            NSLog(@"CMD_ROOM_NTF_USER_GIFT");
            if (self.delegate && [self.delegate respondsToSelector:@selector(koShowSocket:revicedGiftWithDictionary:)] && (result == 0))
            {
                [self.delegate koShowSocket:self revicedGiftWithDictionary:dataDic];
            }
        default:
            break;
    }
}

- (void)clearSocket
{
    [self.socketManager disableConnectNow:YES];
    [self cancelHeartTimer];
    [self.socketManager clearSocket];
    self.socketManager.delegate = nil;
}

- (void)dealloc
{
    
}

@end
