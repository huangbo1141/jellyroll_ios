//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.



@interface DataManager : NSObject 

+ (DataManager*)sharedObject;

- (void)sendGetRequest:(NSString *)url completion:(void(^)(id result))completionBlock;
- (void)sendGetRequestB:(NSString *)url completion:(void(^)(id result))completionBlock;
- (void)sendPostRequest:(NSString *)url params:(id)params completion:(void(^)(id result))completionBlock failure:(void(^)(id result))failure;
- (void)sendGETRequest:(NSString *)url completion:(void(^)(id result))completionBlock failure:(void(^)(id result))failure;
- (void)uploadPost:(NSString *)fileName data:(NSData *)data userID:(NSString *)userID url:(NSString *)urlString completion:(void(^)(id result))completionBlock failure:(void(^)(id result))failure;
@end

#define _gAppData [DataManager sharedObject]
