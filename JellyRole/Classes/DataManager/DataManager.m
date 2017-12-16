//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.


#import "DataManager.h"

static DataManager* gDataMgr = nil;

@interface DataManager(){
}

@end

@implementation DataManager
#pragma mark
#pragma mark Release Memory
- (void)dealloc{
}

+ (DataManager*)sharedObject
{
	if (!gDataMgr)
	{
		gDataMgr = [[DataManager alloc] init];
	}
	return gDataMgr;
}

- (id)init
{
    self = [super init];
    {
    }
    return self;
}

#pragma mark --
#pragma mark Database request

#pragma mark --
#pragma mark WebServices request


- (void)sendGetRequest:(NSString *)url completion:(void(^)(id result))completionBlock {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (![Utils isConnectedToNetwork])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_gAppDelegate showAlertDilog:kAppName message:@"Please check your internet connection."];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_gAppDelegate showLoadingView:true];
            });

            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
            
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                    NSError* error2 = nil;
                    id array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_gAppDelegate showLoadingView:false];
                        completionBlock(array);
                    });
                } else {
                 
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_gAppDelegate showLoadingView:false];
                        [_gAppDelegate showAlertDilog:kAppName message:@"There are some error. Please try after some time."];
                    });
                }
            }] resume];
        }
    });
}

- (void)sendGetRequestB:(NSString *)url completion:(void(^)(id result))completionBlock {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (![Utils isConnectedToNetwork]) {
            
            
        }
        else
        {
            
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
            
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                    NSError* error2 = nil;
                    id array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(array);
                    });
                } else {
                    
                }
            }] resume];
        }
    });
}

- (void)sendGETRequest:(NSString *)url completion:(void(^)(id result))completionBlock failure:(void(^)(id result))failure {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (![Utils isConnectedToNetwork]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_gAppDelegate showAlertDilog:kAppName message:@"Please check your internet connection."];
                completionBlock(nil);
            });
        } else {
            
            
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
            
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            //[request setHTTPBody:[(NSString *)params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(data);
                    });
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }] resume];
        }
    });
}

- (void)sendPostRequest:(NSString *)url params:(id)params completion:(void(^)(id result))completionBlock failure:(void(^)(id result))failure {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (![Utils isConnectedToNetwork]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_gAppDelegate showAlertDilog:kAppName message:@"Please check your internet connection."];
                completionBlock(nil);
            });
        } else {
            

            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
            
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[(NSString *)params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(data);
                    });
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }] resume];
        }
    });
}

- (void)uploadPost:(NSString *)fileName data:(NSData *)data userID:(NSString *)userID url:(NSString *)urlString completion:(void(^)(NSDictionary* result))completionBlock failure:(void(^)(id result))failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (![Utils isConnectedToNetwork])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_gAppDelegate showAlertDilog:kAppName message:@"Please check your internet connection."];
                completionBlock(nil);
            });
        }
        else
        {
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"; \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n%@",userID] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; fileName=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error == nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(data);
                    });
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }] resume];
        }
    });
}


@end
