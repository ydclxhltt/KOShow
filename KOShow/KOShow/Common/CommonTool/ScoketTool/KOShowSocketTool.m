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
    [self sendHeartRequest];
    //_heartTimer = [NSTimer timerWithTimeInterval:HEART_CIRCLE_TIME target:self selector:@selector(sendHeartRequest) userInfo:nil repeats:YES];
}

- (void)cancelHeartTimer
{
    if ([self.heartTimer isValid])
    {
        [self.heartTimer invalidate];
        self.heartTimer = nil;
    }
}

- (void)sendHeartRequest
{
    NSMutableData *requestData = [BasicMessage buildHeartBeatRequest];
    [self.socketManager writeData:requestData];
}

#pragma mark 登录房间
- (void)sendLoginRoomRequestWithUserID:(NSString *)userID nickName:(NSString *)nickName roomID:(NSString *)roomID
{
    NSMutableData *requestData = [BasicMessage buildRoomLoginRequestWithAccount:userID andNickName:nickName andRoomID:roomID];
    [self.socketManager writeData:requestData];
}

#pragma mark 登出房间
- (void)sendLogoutRoomRequestWithRoomID:(NSString *)roomID
{
    NSMutableData *requestData = [BasicMessage buildRoomLogoutRequestWithRoomID:roomID];
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
    [self createHeartTimer];
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


}
@end
