//
//  FDMFlightManager.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDMFlightManager.h"
#import "FDMFlightAPIManager.h"
#import "FDMAirportManager.h"
#import "FDDAirport.h"
#import "FDDFlight.h"

// Notification Constants
NSString * const FDMFlightManagerNotificationFlightsUpdated = @"FDMFlightManagerNotificationFlightsUpdated";

@interface FDMFlightManager ()

@end

@implementation FDMFlightManager {
    NSArray *_allFlights;
    dispatch_queue_t _updateQueue;
}

+ (instancetype)sharedInstance {
    static FDMFlightManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray *)allFlights
{
    NSArray *returnValue = nil;
    BOOL triggerUpdate = NO;

    @synchronized(self) {
        triggerUpdate = !_allFlights;
        returnValue = _allFlights ?: @[];
    }

    if (triggerUpdate) {
        [self _updateFlightAndAirports];
    }

    return returnValue;
}

- (void)_setAllFlights:(NSArray *)allFlights
{
    @synchronized(self) {
        _allFlights = allFlights;
    }

    dispatch_async(dispatch_get_main_queue(),^{
        // Return to the main thread to dispatch the external notifications.
        // This is not necessary, but as view controllers may be listening
        // to our notifications, and many programmers forget to check the
        // queue for the notification callback, we'll just make this less
        // error prone.
        [[NSNotificationCenter defaultCenter] postNotificationName:FDMFlightManagerNotificationFlightsUpdated object:self];
    });
}

- (void)_updateFlightAndAirports {
    [[FDMFlightAPIManager sharedInstance] getFlightList:^(NSArray *allFlights, NSArray *allAirports) {
        if (allFlights) {
            [self _setAllFlights:allFlights];
        }

        // While we're here, lets update the airport manager since we have the data
        if (allAirports) {
            [[FDMAirportManager sharedInstance] updateAirports:allAirports];
        }
    }];
}


@end
