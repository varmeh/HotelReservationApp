//
//  NetworkManager.m
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>

@interface NetworkManager ()

//Private methods

@end

@implementation NetworkManager

//Singleton instance - Purpose is to provide single interface.
//This is in sync with AFNetworking manager instance.
+ (instancetype)sharedInstance {
    static NetworkManager *sharedInstance;
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        //Thread safe implementation
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    return sharedInstance;
}

//Alloc overriding is necessary to ensure no other instance could be created.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return self;
}

//This could not be a class method as we want to pass success/failure information using delegates and delegates are associated with instance.
-(void)getData:(NSString *)url withParameters: (id)parameters{
    // this line of code avoids invalid parameter url string
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //Using GET method to recieve JSON data from web service.
    [[AFHTTPSessionManager manager] GET:encoded parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
        //Delegate success implementation to caller.
        [self.delegate dataFetchedSuccessfull:responseObject];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        //Failure message alert is optional.
        if ([self.delegate respondsToSelector:@selector(dataFetchFailedWithError:)]) {
            [self.delegate dataFetchFailedWithError:error];
        }
    }];
}
@end
