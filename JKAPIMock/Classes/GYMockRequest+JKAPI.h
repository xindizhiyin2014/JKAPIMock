//
//  GYMockRequest+JKAPI.h
//  NSURLProtocolExample
//
//  Created by jack on 2017/2/10.
//  Copyright © 2017年. All rights reserved.
//

#import <GYHttpMock/GYHttpMock.h>

@interface GYMockRequest (JKAPI)
- (BOOL)matchesRequest:(id<GYHTTPRequest>)request;
@end
