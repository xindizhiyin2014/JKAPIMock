//
//  JKMockManager.m
//  NSURLProtocolExample
//
//  Created by jack on 2017/2/10.
//  Copyright © 2017年. All rights reserved.
//

#import "JKMockManager.h"
#import "JKMockRequestModel.h"
#import <objc/runtime.h>

#import <GYHttpMock/GYMockRequestDSL.h>
#import <GYHttpMock/GYMockResponseDSL.h>

@interface JKMockManager()

@property (nonatomic, strong) NSSet <JKMockRequestModel *> *requestsSet;


@end

@implementation JKMockManager


static JKMockManager *manager =nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [JKMockManager new];
    });
    return manager;
}

+ (void)registerWithJsonFile:(NSString *)fileName{
    //获得文件的后缀名 （不带'.'）
    NSString *suffix = [fileName pathExtension];
    if ([suffix isEqualToString:@"plist"]||[suffix isEqualToString:@""]) {
        NSString *correctFileName = [fileName stringByDeletingPathExtension];
        suffix =suffix ?@"plist":nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:correctFileName ofType:suffix];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSArray *array = [dic allValues];
        [self configRequestsSet:array];
        [[JKMockManager shareInstance] gotoMockRquests];

    }else{
        NSAssert(suffix, @"the register file type should be plist");
    }

}

+ (void)configRequestsSet:(NSArray *)array{
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        NSMutableArray * tempMutableArray = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            JKMockRequestModel *model = [JKMockRequestModel new];
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList([JKMockRequestModel class], &outCount);
            for (i = 0; i < outCount; i++){
                objc_property_t property = properties[i];
                const char *char_f = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_f];
                id propertyValue = [dic valueForKey:(NSString *)propertyName];
                if ([self judgeObjValue:propertyValue]){
                    [model setValue:propertyValue forKey:propertyName];
                    [tempMutableArray addObject:model];
                }
            }
            free(properties);
        }
        
        [JKMockManager shareInstance].requestsSet = [NSSet setWithArray:[tempMutableArray copy]];

        
    }
    
}



#pragma mark - 创建Mock模型

- (void)gotoMockRquests {
    for (JKMockRequestModel *model in self.requestsSet) {
        if (!model.isMock) { //如果不需要mock
            continue;
        }
        NSString *bodyStr =nil;
        if (model.body &&[model.body isKindOfClass:[NSDictionary class]]) {
            bodyStr =[self DataTOjsonString:model.body];
        }
        NSString *response = nil;
        if (model.response &&[model.response isKindOfClass:[NSDictionary class]]) {
            response =[self DataTOjsonString:model.response];
        }

        
        if ([model.method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
            
            mockRequest(@"GET", model.url).andReturn(200).withBody(response);
        } else if ([model.method caseInsensitiveCompare:@"POST"] == NSOrderedSame){
            
            mockRequest(@"POST", model.url).withBody(bodyStr).withHeaders(model.headers).andReturn(200).withBody(response);
        }
    }
}


/**
 将字典参数转化为URL格式参数
 */
- (NSString *)paramsStringWithDictionary:(NSDictionary *)params {
    if (![params isKindOfClass:[NSDictionary class]] || params.count == 0) {
        return nil;
    }
    
    NSMutableString *par = [NSMutableString string];
    for (NSString *key in params) {
        [par appendFormat:@"%@=%@&", key, params[key]];
    }
    
    [par deleteCharactersInRange:NSMakeRange(par.length - 1, 1)];
    return [par copy];
}



/**
 判断obj是否是对象

 @param obj 传入的需要判断的obj
 @return YES or NO
 */
+(BOOL)judgeObjValue:(id)obj {
    if ([obj isEqual:[NSNull null]]) {
        return NO;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([(NSString *)obj isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
    
    if (!obj) {
        return NO;
    }
    return YES;
}

- (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


@end
