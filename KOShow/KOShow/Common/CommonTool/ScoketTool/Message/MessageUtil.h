//
//  MessageUtil.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageUtil : NSObject

+(int)filterMsgCmd:(NSData*)data;

//short 填充2个字节
+ (void) shortToChars:(short)num buf:(char*)buf position:(int)position;
//int 填充4个字节
+ (void) intToChars:(int)num buf:(char*)buf position:(int)position;

//2个字节转short
+ (short) charsToShort:(char*)buf position:(int)position;
//4个字节转int
+ (int) charsToInt:(char*)buf position:(int)position;

//获取1个字节
+ (int)get1Byte:(NSData *)data andPosition:(NSUInteger)position;
//获取2个字节
+ (short)get2Bytes:(NSData *)data andPosition:(NSUInteger)position;
//获取4个字节
+ (int)get4Bytes:(NSData *)data andPosition:(NSUInteger)position;
//获取字符串
+ (NSString *)getString:(NSData *)data andPosition:(NSUInteger)position andLength:(NSUInteger)length;
//md5加密
+ (NSString*)md5:(void*)buffer andLength:(int)length;
//获取8个字节
+ (long long)get8Bytes:(NSData *)data andPosition:(NSUInteger)position;
 
@end
