//
//  MessageUtil.m
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "MessageUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MessageUtil

+(int)filterMsgCmd:(NSData*)data
{
    if ([data length]<22) {
        return 0;
    }
    char buf[4];
    memset(buf, 0, 4);
    
    NSRange range=NSMakeRange(2, 4);
    [data getBytes:buf range:range];
    
    int cmd=[self charsToInt:buf position:0];
    return  cmd;
}

#pragma 写数据
//short 填充2个字节
+(void) shortToChars:(short)num buf:(char*)buf position:(int)position
{
    buf[position]=(num>>8&0xff);
    buf[position+1]=(num&0xff);
}
//int 填充4个字节
+(void) intToChars:(int)num buf:(char*)buf position:(int)position
{
    buf[position]=(num>>24&0xff);
    buf[position+1]=(num>>16&0xff);
    buf[position+2]=(num>>8&0xff);
    buf[position+3]=(num&0xff);
}

#pragma 读数据
//2个字节转short
+(short) charsToShort:(char*)buf position:(int)position
{
    return ((buf[position]&0xff)<<8)|(buf[position+1]&0xff);
}
//4个字节转int
+(int) charsToInt:(char*)buf position:(int)position
{
    return ((buf[position]&0xff)<<24)|((buf[position+1]&0xff)<<16)
    |((buf[position+2]&0xff)<<8)|(buf[position+3]&0xff);
}

+ (int)get1Byte:(NSData *)data andPosition:(NSUInteger)position{
    int val = 0;
    if (position < [data length] && position + 1 <= [data length]) {
        [data getBytes:&val range:NSMakeRange(position, 1)];
    }
    return val;
}

+ (short)get2Bytes:(NSData *)data andPosition:(NSUInteger)position{
    short val = 0;
    if (position < [data length] && position + 2 <= [data length]) {
        [data getBytes:&val range:NSMakeRange(position, 2)];
        val = OSSwapInt16(val);
    }
    return val;
}

+ (int)get4Bytes:(NSData *)data andPosition:(NSUInteger)position{
    int val = 0;
    if (position < [data length] && position + 4 <= [data length]) {
        [data getBytes:&val range:NSMakeRange(position, 4)];
        val = OSSwapInt32(val);
    }
    return val;
}

+ (long long)get8Bytes:(NSData *)data andPosition:(NSUInteger)position{
    long long val = 0;
    if (position < [data length] && position + 8 <= [data length]) {
        [data getBytes:&val range:NSMakeRange(position, 8)];
        val = OSSwapInt64(val);
    }
    return val;
}

+ (NSString *)getString:(NSData *)data andPosition:(NSUInteger)position andLength:(NSUInteger)length{
    if (position < [data length] && position + length <= [data length]) {
        NSData *sub = [data subdataWithRange:NSMakeRange(position, length)];
        NSString *str = [[NSString alloc] initWithData:sub encoding:NSUTF8StringEncoding];
        return str;
    } else {
        return nil;
    }
}


+ (NSString*)md5:(void*)buffer andLength:(int)length{
	unsigned char result[16];
	CC_MD5(buffer, length, result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],result[1],result[2],result[3],result[4],
			result[5],result[6],result[7],result[8],result[9],
			result[10],result[11],result[12],result[13],result[14],result[15]];
}


@end
