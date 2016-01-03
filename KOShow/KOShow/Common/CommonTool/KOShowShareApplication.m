//
//  KOShowShareApplication.m
//  KOShow
//
//  Created by 陈磊 on 15/12/4.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "KOShowShareApplication.h"

@implementation KOShowShareApplication

static KOShowShareApplication *shareApplication = nil;

+ (instancetype)shareApplication
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareApplication = [[self alloc] init];
    });
    return shareApplication;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSString *emojiListPath = [[NSBundle mainBundle] pathForResource:@"EmojiList" ofType:@"plist"];
        _emojiDictionary = [NSDictionary dictionaryWithContentsOfFile:emojiListPath];
        //NSString *giftListPath = [[NSBundle mainBundle] pathForResource:@"GiftPropertyList" ofType:@"plist"];
        //_giftArray = [NSArray arrayWithContentsOfFile:giftListPath];
        _imageServer = @"";
        _uploadIconUrl = @"";
        _socketPort = @"";
        _socketServerIP = @"";
    }
    return self;
}

+ (void)saveUserInfoWithUserName:(NSString *)userName password:(NSString *)password
{
    [USER_DEFAULT setObject:userName forKey:@"userName"];
    [USER_DEFAULT setObject:password forKey:@"password"];
}

- (NSString *)makeImageUrlWithRightHalfString:(NSString *)rightHalfString
{
    NSString *imageUrl = @"";
    if (!rightHalfString)
    {
        return imageUrl;
    }
    imageUrl = [self.imageServer stringByAppendingString:rightHalfString];
    return imageUrl;
}

@end
