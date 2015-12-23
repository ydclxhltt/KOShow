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
@property (nonatomic, strong) NSDictionary *giftDictionary;

+ (instancetype)shareApplication;

@end
