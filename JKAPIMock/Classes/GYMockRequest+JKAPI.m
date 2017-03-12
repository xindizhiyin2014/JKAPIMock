//
//  GYMockRequest+JKAPI.m
//  NSURLProtocolExample
//
//  Created by jack on 2017/2/10.
//  Copyright © 2017年 lujb. All rights reserved.
//

#import "GYMockRequest+JKAPI.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <GYHttpMock/GYMatcher.h>
#import <GYHttpMock/GYHttpMock.h>

static void *paramsKey = &paramsKey;

@implementation GYMockRequest (JKAPI)

- (BOOL)matchesRequest:(id<GYHTTPRequest>)request {
    if ([self matchesMethod:request]
        && [self matchesURL:request]
        && [self matchesParams:request]
        && [self matchesBody:request]
        ) {
        return YES;
    }
    
    return NO;
}

/**
 判断方法是否相同
 */
- (BOOL)matchesMethod:(id<GYHTTPRequest>)request {
    if (!self.method || [self.method caseInsensitiveCompare:request.method] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

/**
 判断url是否相同，如果get则判断不包含参数的判断 如果post则直接判断
 如果是get在urlMatcher中会带入参数所以在比较时需要去除
 */
- (BOOL)matchesURL:(id<GYHTTPRequest>)request {
    NSString *url = [self urlWithDeleteParams:request.url.path];
    
    //记录传入的url
    NSString *noParamsURL = [[self urlWithDeleteParams:self.urlMatcher.string] copy];
    NSDictionary *params = [self paramsWithURL:self.urlMatcher.string];
    objc_setAssociatedObject(self, paramsKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    BOOL result = [url hasSuffix:noParamsURL];
    
    return result;
}

/**
 匹配参数：只匹配参数名不匹配参数值
 */
- (BOOL)matchesParams:(id<GYHTTPRequest>)request {
    NSDictionary *params = [self paramsWithURL:request.url.absoluteString];
    NSDictionary *oldParams = objc_getAssociatedObject(self, paramsKey);
    return [self dictionary:params isEqualDictionary:oldParams];
}

/**
 判断头是否相同
 */
- (BOOL)matchesHeaders:(id<GYHTTPRequest>)request {
    for (NSString *header in self.headers) {
        if (![[request.headers objectForKey:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    
    return YES;
}

/**
 判断body 只有在post的情况下才有效
 */
- (BOOL)matchesBody:(id<GYHTTPRequest>)request {
    NSData *reqBody = request.body;
    if (!reqBody) {
        return YES;
    }
    
    NSString *reqBodyString = [[NSString alloc] initWithData:reqBody encoding:NSUTF8StringEncoding];
    NSAssert(reqBodyString, @"request body is nil");
    
    NSDictionary *params = [self convertDictionaryWithURLParams:reqBodyString];
    NSDictionary *mockParams =[self dictionaryWithJsonString:self.body.string];
    return [self dictionary:params isEqualDictionary:mockParams];
}

#pragma mark - private

/**
 去除url中的参数
 */
- (NSString *)urlWithDeleteParams:(NSString *)url {
    NSArray *temp = [url componentsSeparatedByString:@"?"];
    return temp.count == 2 ? temp[0] : url;
}

/**
 url的参数 返回key:value
 */
- (NSDictionary *)paramsWithURL:(NSString *)url {
    if (![url isKindOfClass:[NSString class]] || url.length == 0) {
        return nil;
    }
    
    NSArray *urls = [url componentsSeparatedByString:@"?"];
    NSString *paramsURL = nil;
    if (urls.count == 2) {
        paramsURL = urls[1];
    }
    
    return [self convertDictionaryWithURLParams:paramsURL];
}

/**
 根据参数字符串转化为字典 name=1&id=2 ==> name:1,id:2
 */
- (NSDictionary *)convertDictionaryWithURLParams:(NSString *)paramsURL {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *item in [paramsURL componentsSeparatedByString:@"&"]) {
        NSArray *temp = [item componentsSeparatedByString:@"="];
        if (temp.count == 2) {
            [params setObject:temp[1] forKey:temp[0]];
        }
    }
    
    return params;

}

/**
 判断两个字典是否相同 只判断key
 */
- (BOOL)dictionary:(NSDictionary *)dic1 isEqualDictionary:(NSDictionary *)dic2 {
    
    NSSet *setA = [NSSet setWithArray:[dic1 allKeys]];
    NSSet *setB = [NSSet setWithArray:[dic2 allKeys]];
    return [setA isEqualToSet:setB];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (!jsonString) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

@end
