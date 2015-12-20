//
//  SocketManager.m
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "SocketManager.h"
//#import "SVProgressHUD.h"
//#import "HUDView.h"
//#import "ChatServerControl.h"

@interface SocketManager()
{
    //socket是否已经连接上
    BOOL isConnected;
    NSThread *newThread;
}

@property (nonatomic, strong) AsyncSocket *socket;
@property (nonatomic, assign) int serverPort;
@property (nonatomic, strong) NSString *serverIP;

@end

@implementation SocketManager


- (id)init
{
    if (self = [super init])
    {
        newThread = [[NSThread alloc] initWithTarget:self selector:@selector(toNewThread) object:nil];
        [newThread start];
    }
    return self;
}


//新线程回调
- (void)toNewThread
{
     @autoreleasepool
    {
        while (YES)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
     }
}
#pragma mark 连接服务器
//连接服务器
-(void)connectServer:(NSString*)ip port:(int)port
{
    NSLog(@"ip=%@",ip);
    NSLog(@"port=%d",port);
    self.serverIP = ip;
    self.serverPort = port;
    [self performSelector:@selector(createSocket) onThread:newThread withObject:nil waitUntilDone:NO];
}

//创建socket
- (void)createSocket
{
    if (self.socket)
    {
        [self.socket disconnect];
        [self freeConnectSocket];
    }
    NSError *error = nil;
    _socket = [[AsyncSocket alloc] initWithDelegate:self];
    BOOL isSucess = [_socket connectToHost:_serverIP onPort:_serverPort error:&error];
    NSLog(@"====%d",isSucess);
}

//检查是否socket连接着
- (BOOL)isConnected
{
    [self performSelector:@selector(checkIsConnected) onThread:newThread withObject:nil waitUntilDone:YES];
    return isConnected;
}
//检查是否socket连接着
- (void)checkIsConnected
{
    isConnected = [_socket isConnected];
}

#pragma mark 写数据
//写数据
-(void)writeData:(NSData*)data
{
    if (data==nil)
    {
        return;
    }
    [self performSelector:@selector(toWrite:) onThread:newThread withObject:data waitUntilDone:YES];
}
//写数据
- (void)toWrite:(NSData*)data
{
    [_socket writeData:data withTimeout:-1 tag:0];
}

#pragma mark 断开连接
//断开连接
-(void)disableConnectNow:(BOOL)isNow
{
    if (newThread)
    {
        [self performSelector:@selector(toDisconnect:) onThread:newThread withObject:[NSNumber numberWithBool:isNow] waitUntilDone:YES];
    }
    
}
//断开连接
- (void)toDisconnect:(NSNumber *)number
{
    BOOL is = [number boolValue];
    if (is)
    {
        if (_socket)
        {
            [_socket disconnect];
        }
    }
    else
    {
        if (_socket)
        {
            [_socket disconnectAfterWriting];
        }
    }
}

- (void)freeConnectSocket
{
    [self.socket setDelegate:nil];
    self.socket = nil;
}

#pragma mark 重新连接
//重新连接
- (void)reconnect
{
    if ([self isConnected] == YES)
    {
        return;
    }
    [self disableConnectNow:YES];
    [self connectServer:_serverIP port:_serverPort];
}


#pragma mark 读取数据
//读
- (void)toRead
{
    [_socket readDataWithTimeout:-1 tag:0];
}

#pragma mark - AsyncSocketDelagate methods
//连接服务器成功
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketDidConnected)])
    {
        [self.delegate performSelectorOnMainThread:@selector(socketDidConnected) withObject:nil waitUntilDone:NO];
    }
    [self performSelector:@selector(toRead) onThread:newThread withObject:nil waitUntilDone:NO];
}

//将要断开连接
//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(disConnected)]) {
//        [self.delegate performSelectorOnMainThread:@selector(disConnected) withObject:nil waitUntilDone:NO];
//    }
//}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    [self freeConnectSocket];

    if (self.delegate && [self.delegate respondsToSelector:@selector(socketDidDisConnected)])
    {
        [self.delegate performSelectorOnMainThread:@selector(socketDidDisConnected) withObject:nil waitUntilDone:NO];
    }
}

//读取到数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(readData:)])
    {
        [self.delegate performSelectorOnMainThread:@selector(readData:) withObject:data waitUntilDone:NO];
    }
    [self performSelector:@selector(toRead) onThread:newThread withObject:nil waitUntilDone:NO];
}

//写入数据成功
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDataSuccess)])
    {
        [self.delegate performSelectorOnMainThread:@selector(sendDataSuccess) withObject:nil waitUntilDone:NO];
    }
}

@end
