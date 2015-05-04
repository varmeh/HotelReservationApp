//
//  DecodingLocationAutoCompleteData.m
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "DecodingLocationAutoCompleteData.h"
#import "NetworkManager.h"

@interface DecodingLocationAutoCompleteData ()

@property (nonatomic) NSDictionary *jsonAutoCompleteData;
@property (nonatomic) NSString *autocompleteBaseURL;
@property (nonatomic) NSMutableArray *locationData;

@end

@implementation DecodingLocationAutoCompleteData

+ (instancetype)sharedLocationService {
    static DecodingLocationAutoCompleteData *sharedInstance;
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super allocWithZone:nil] init];
            
            //Custom Initialization
            sharedInstance.autocompleteBaseURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDBH36zCQWUjSm6ZqlEwW7lPmaOeAgIfr8&input=";
        });
    }
    return sharedInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedLocationService];
}

- (id)copy {
    return self;
}

- (void)setLocationAutoCompleteDataForText:(NSString *)url inDataSource:(NSMutableArray *)locationData {
    //Clear Previous Data
    [locationData removeAllObjects];
    self.locationData = locationData;
    
    //Ensure shared location singleton instance is active
    DecodingLocationAutoCompleteData *locationService = [DecodingLocationAutoCompleteData sharedLocationService];
    
    //append url to base address
    NSString *locationURL = [locationService.autocompleteBaseURL stringByAppendingString:url];;
    
    //Get Latest Data
    NetworkManager *session = [NetworkManager sharedInstance];
    session.delegate = self;
    
    [session getData:locationURL withParameters:nil];
}

//Delegate Method - Used for update UI after successful web service call.
- (void)dataFetchedSuccessfull:(id)response {
    self.jsonAutoCompleteData = (NSDictionary *)response;
    
    //Fill this data into location data source
    for (NSDictionary *place in self.jsonAutoCompleteData[@"predictions"]) {
        NSString *newPlace = place[@"description"];
        [self.locationData addObject:newPlace];
    }
    
    //Call delegate for UI update
    [self.delegate locationServiceSuccessful];
}

//Delegate Method - Log failure Reason for location service.
- (void)dataFetchFailedWithError:(NSError *)error {
    NSLog(@"Location Service Failed with Error:%@\n%@",[error localizedDescription], [error localizedFailureReason]);
}
@end
