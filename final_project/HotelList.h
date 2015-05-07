//
//  HotelList.h
//  final_project
//
//  Created by Varun Mehta on 5/7/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelModel.h"

@interface HotelList : NSObject

@property (assign, nonatomic) BOOL moreResultsAvailable; //If true, more results can be obtained via the paging process.
@property (assign, nonatomic) int customerSessionID;
@property (strong, nonatomic) NSString *cacheKey; //The key to the cache of the current response returned. Use this value in your next paging request.
@property (strong, nonatomic) NSString *cacheLocation; //Defines the EAN server location of the cache for the current response returned. Use this value in your next paging request.
@property (strong, nonatomic) NSMutableArray *hotelList;

@end
