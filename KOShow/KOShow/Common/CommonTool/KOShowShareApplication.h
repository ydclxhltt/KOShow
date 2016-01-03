//
//  KOShowShareApplication.h
//  KOShow
//
//  Created by 陈磊 on 15/12/4.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KOShowShareApplication : NSObject

@property (nonatomic, strong) NSDictionary *emojiDictionary;
@property (nonatomic, strong) NSArray *giftArray;
@property (nonatomic, strong) NSDictionary *userInfoDictionary;
@property (nonatomic, strong) NSString *imageServer;
@property (nonatomic, strong) NSString *uploadIconUrl;
@property (nonatomic, strong) NSString *socketServerIP;
@property (nonatomic, strong) NSString *socketPort;
@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)shareApplication;

+ (void)saveUserInfoWithUserName:(NSString *)userName password:(NSString *)password;

- (NSString *)makeImageUrlWithRightHalfString:(NSString *)rightHalfString;

@end
