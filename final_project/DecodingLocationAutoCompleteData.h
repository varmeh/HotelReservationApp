//
//  DecodingLocationAutoCompleteData.h
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@protocol DecodingLocationAutoCompleteDataDelegate <NSObject>

- (void)locationServiceSuccessful;

@end

@interface DecodingLocationAutoCompleteData : NSObject <NetworkManagerDelegate>

@property (weak) id <DecodingLocationAutoCompleteDataDelegate> delegate;

+ (instancetype)sharedLocationService;

- (void)setLocationAutoCompleteDataForText:(NSString *)url inDataSource:(NSMutableArray *)locationData;

@end
