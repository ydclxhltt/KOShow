//
//  SocketManager.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

#define SM_TIMEOUT 15

@protocol SocketManagerDelegate <NSObject>

@optional

- (void)socketDidConnected;
- (void)socketDidDisConnected;
- (void)readData:(NSData*)data;
- (void)sendDataSuccess;

@end

@interface SocketManager : NSObject<AsyncSocketDelegate>

@property (nonatomic, assign) id delegate;

//连接
-(void)connectServer:(NSString*)ip port:(int)port;
//断开连接
-(void)disableConnectNow:(BOOL)isNow;
//写数据
-(void)writeData:(NSData*)data;
//判断sokcet是否连接
- (BOOL)isConnected;
//重新连接
- (void)reconnect;

@end
