//
//  JKMockRequestModel.h
//  NSURLProtocolExample
//
//  Created by jack on 2017/2/10.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKOptional
@end

@interface JKMockRequestModel : NSObject

@property (nonatomic, copy) NSString<JKOptional> *url;
@property (nonatomic, copy) NSString<JKOptional> *method;
@property (nonatomic, copy) NSDictionary<JKOptional> *headers;
@property (nonatomic, copy) NSDictionary<JKOptional> *body; //校验的时候需要转换为NSData类型
@property (nonatomic, copy)  NSDictionary<JKOptional> *response;
@property (nonatomic, assign) BOOL isMock;

@end
