//
//  NetworkManager.h
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerDelegate <NSObject>

-(void)dataFetchedSuccessfull:(id)response;

@optional
- (void)dataFetchFailedWithError: (NSError *)error;

@end

@interface NetworkManager : NSObject

@property (nonatomic ,weak) id <NetworkManagerDelegate> delegate;

+(instancetype)sharedInstance;
-(void)getData:(NSString *)url withParameters: (id)parameters;

@end
