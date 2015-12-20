//
//  KOShowSocketTool.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KOShowSocketTool : NSObject

- (void)contentServerWithIp:(NSString *)serverIp port:(int)port;

- (void)createHeartTimer;

- (void)sendLoginRoomRequestWithUserID:(NSString *)userID nickName:(NSString *)nickName roomID:(NSString *)roomID;

@end
