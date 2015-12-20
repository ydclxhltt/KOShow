//
//  BasicMessage.m
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "BasicMessage.h"
#import "MessageUtil.h"

@implementation BasicMessage

+(unsigned int)countNum
{
    static unsigned int count=0;
    count++;
    return count;
}

#pragma mark 心跳包
+ (NSMutableData *)buildHeartBeatRequest
{
    NSMutableData *requestData = [[NSMutableData alloc] initWithCapacity:0];
    [BasicMessage buildRequestWithData:requestData
                               andBody:nil
                            andCommand:CMD_USER_HEARTBEAT];
    return requestData;
}

#pragma mark 登录房间
+ (NSMutableData *)buildRoomLoginRequestWithAccount:(NSString *)account
                             andNickName:(NSString *)nickName
                               andRoomID:(NSString *)roomID

{
    
    NSLog(@"account = %@", account);
    NSLog(@"nickName = %@", nickName);
    NSLog(@"roomId = %@", roomID);
    
    long userIDLength = 32;
    NSMutableData *requestData = [[NSMutableData alloc] initWithCapacity:0];
    NSMutableData *bufBody = [[NSMutableData alloc] initWithCapacity:0];
    NSData *bufAccount = [account dataUsingEncoding:NSUTF8StringEncoding];
    [bufBody appendBytes:[bufAccount bytes] length:userIDLength];

    NSData *nickNameData = [nickName dataUsingEncoding:NSUTF8StringEncoding];
    
    int length = (int)[nickNameData length];
    [bufBody appendBytes:&length length:1];
    [bufBody appendBytes:[nickNameData bytes] length:length];

    //long rid = OSSwapInt32(roomId);
    NSData *roomIDDate = [roomID dataUsingEncoding:NSUTF8StringEncoding];
    [bufBody appendBytes:[roomIDDate bytes] length:ROOMID_LENGTH];
    NSLog(@"bufBody=%@====bufBody===%lu",bufBody.description,(unsigned long)bufBody.length);
    [BasicMessage buildRequestWithData:requestData andBody:bufBody andCommand:(int)CMD_ROOM_LOGIN];
    return requestData;
}

#pragma mark 登出房间
+ (NSMutableData *)buildRoomLogoutRequestWithRoomID:(NSString *)roomID
{
    NSMutableData *requestData = [[NSMutableData alloc] initWithCapacity:0];
    NSMutableData *bufBody = [[NSMutableData alloc] initWithCapacity:0];
    NSData *roomIDDate = [roomID dataUsingEncoding:NSUTF8StringEncoding];
    [bufBody appendBytes:[roomIDDate bytes] length:ROOMID_LENGTH];
    [BasicMessage buildRequestWithData:requestData andBody:bufBody andCommand:CMD_ROOM_LOGOUT];
    return requestData;
}

#pragma mark 发送消息
+ (void)buildRoomMsgRequestWithType:(int)msgType
                    andMessage:(NSString *)msg
                   andFromName:(NSString *)fromName
                     andToName:(NSString *)toName
                  andSecretMsg:(int)sceret
                     andRoomId:(int)roomId
                     andSrcUid:(int)srcuid
                     andDesUid:(int)desuid
{
    NSLog(@"msg = %@ from:%@ to:%@",msg,fromName,toName);
    NSMutableData *bufBody = [[NSMutableData alloc] initWithCapacity:0];
    [bufBody appendBytes:&msgType length:1];
    
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    long msgLen = [msgData length];
    [bufBody appendBytes:&msgLen length:1];
    [bufBody appendData:msgData];
    
    NSData *fromNameData = [fromName dataUsingEncoding:NSUTF8StringEncoding];
    long fromNameLen = [fromNameData length];
    [bufBody appendBytes:&fromNameLen length:1];
    [bufBody appendData:fromNameData];
    
    NSData *toNameData = [toName dataUsingEncoding:NSUTF8StringEncoding];
    long toNameLen = [toNameData length];
    [bufBody appendBytes:&toNameLen length:1];
    [bufBody appendData:toNameData];
    [bufBody appendBytes:&sceret length:1];

    //[BasicMessage buildRequestWithBody:bufBody andCommand:CMD_ROOM_MSG andRoomId:roomId];
    
}


#pragma mark 创建数据包
+ (void)buildRequestWithData:(NSMutableData *)requestData andBody:(NSData *)body andCommand:(int)command
{
    short ver = SYS_VER;
    ver = OSSwapInt16(ver);
    int cmd  = OSSwapInt32(command);
    [requestData appendBytes:&ver length:2];
    [requestData appendBytes:&cmd length:4];
    long lenBody = body==nil ? 0 : [body length];
    long len = lenBody + MESSAGE_HEADER_LENGTH;
    //len = OSSwapInt32(len);
    [requestData appendBytes:&len length:4];
    if (body)
    {
        [requestData appendData:body];
    }    
}

#pragma mark -
#pragma mark 解析数据包

static id bufferData = nil;

+ (void)cleanBufferData
{
    if (bufferData)
    {
        bufferData = nil;
    }
}


+ (NSMutableDictionary *)parseResponse:(NSData *)buffer
{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    short ver = 0;
    NSUInteger pos = 0;
    ver = [MessageUtil get2Bytes:buffer andPosition:pos];
    pos += MESSAGE_VERSION_LENGTH;
    NSNumber *obj = [NSNumber numberWithShort:ver];
    [dataDic setValue:obj forKey:@"version"];
    
    int cmd = 0;
    cmd = [MessageUtil get4Bytes:buffer andPosition:pos];
    [dataDic setValue:[NSNumber numberWithInt:cmd] forKey:@"command"];
    pos += MESSAGE_COMMEND_LENGTH;
    NSLog(@"cmd = %x", cmd);
    
    int bufLen = 0;
    if (pos < [buffer length] && pos + 4 <= [buffer length])
    {
        [buffer getBytes:&bufLen range:NSMakeRange(pos, 4)];
    }
    [dataDic setValue:@(bufLen) forKey:@"length"];
    //bufLen = [MessageUtil get4Bytes:buffer andPosition:pos];
    pos += MESSAGE_ALL_LENGTH;
    if ([buffer length] < MESSAGE_HEADER_LENGTH || bufLen != [buffer length])
    {
        [dataDic setValue:[NSNumber numberWithInt:ERROR_RESPONSE_LENGTH] forKey:@"error"];
        return dataDic;
    }
    
    switch (cmd)
    {
        case CMD_ROOM_LOGIN_ACK:
            [BasicMessage parseRoomLoginResponse:buffer andPosition:pos andDictionary:dataDic];
            break;
        case CMD_USER_HEARTBEAT_ACK:
            break;
        case CMD_ROOM_MSG:
            NSLog(@"CMD_ROOM_MSG");
            [BasicMessage parseRoomMsgResponse:buffer andPosition:pos andDictionary:dataDic];
            break;
        case CMD_ROOM_MSG_ACK:
            NSLog(@"CMD_ROOM_MSG_ACK");
            [BasicMessage parseRoomMsgAckResponse:buffer andPosition:pos andDictionary:dataDic];
            break;
        default:
            [dataDic setValue:[NSNumber numberWithInt:ERROR_RESPONSE_COMMAND] forKey:@"error"];
            break;
    }
    
    return dataDic;
}

#pragma mark -
#pragma mark 房间聊天信息应答解析
+ (void)parseRoomMsgResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict{
    int pos = (int)position;
    int type = [MessageUtil get1Byte:buffer andPosition:pos];
    [dict setValue:[NSNumber numberWithInt:type] forKey:@"Type"];
    pos ++;
    NSString *userID = [MessageUtil getString:buffer andPosition:pos andLength:32];
    [dict setValue:userID forKey:@"userID"];
    pos +=32;
    int nameLength = [MessageUtil get1Byte:buffer andPosition:pos];
    pos += 1;
    NSString *nickName = [MessageUtil getString:buffer andPosition:pos andLength:nameLength];
    [dict setValue:nickName forKey:@"nickName"];
    pos += nameLength;
    NSString *roomID = [MessageUtil getString:buffer andPosition:pos andLength:ROOMID_LENGTH];
    [dict setValue:roomID forKey:@"roomID"];
    pos += ROOMID_LENGTH;
    int messageLength = [MessageUtil get1Byte:buffer andPosition:pos];
    pos += 1;
    NSString *msg = [MessageUtil getString:buffer andPosition:pos andLength:messageLength];
    [dict setValue:msg forKey:@"Message"];
    pos += messageLength;
    NSLog(@"parseMsg = %@", msg);
    long  long msgTime = 0;
    [buffer getBytes:&msgTime range:NSMakeRange(pos, 8)];
    //long msgTime = [MessageUtil get8Bytes:buffer andPosition:pos];
    [dict setValue:@(msgTime) forKey:@"msgTime"];
    NSLog(@"CMD_ROOM_MSG_dict = %@",dict);
}

+ (void)parseRoomMsgAckResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict{
    int pos = position;
    int result = [MessageUtil get4Bytes:buffer andPosition:pos];
    [dict setValue:[NSNumber numberWithInt:result] forKey:@"result"];
    
}

+ (void)parseRoomLoginResponse:(NSData *)buffer andPosition:(NSUInteger)position andDictionary:(NSDictionary *)dict
{
    
    NSLog(@"position = %lu", position);
    long pos = position;
    int result = 0;
    [buffer getBytes:&result range:NSMakeRange(pos, 4)];
    result = OSSwapInt32(result);
    [dict setValue:[NSNumber numberWithInt:result] forKey:@"result"];
}



@end
