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
    
    }
    return self;
}


@end
