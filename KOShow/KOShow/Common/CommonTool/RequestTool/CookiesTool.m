//
//  CookiesTool.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CookiesTool.h"

@implementation CookiesTool

//获取cookie
+ (NSString *)cookieValueWithKey:(NSString *)key cookiesForURL:(NSString *)url
{
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if ([sharedHTTPCookieStorage cookieAcceptPolicy] != NSHTTPCookieAcceptPolicyAlways)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    }
    url = (url) ? url : @"";
    NSArray  *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:url]];
    NSEnumerator  *enumerator = [cookies objectEnumerator];
    NSHTTPCookie  *cookie;
    while (cookie = [enumerator nextObject])
    {
        if ([[cookie name] isEqualToString:key])
        {
            return [NSString stringWithString:[[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return @"";
}

//删除cookies (key所对应的cookies)因为cookies保存在NSHTTPCookieStorage.cookies中.这里删除它里边的元素即可.
+ (void)deleteCookieWithKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie name] isEqualToString:key])
        {
            [cookieJar deleteCookie:cookie];
        }
    }
}


+ (void)setCookiesWithUrl:(NSString *)url
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    NSLog(@"cookies====%@",cookies);
    NSHTTPCookie *cookie;
    for (cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

@end
