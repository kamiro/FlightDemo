//
//  FDMFlightManager.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDDFlight;

/**
 *  A notification that will be dispatched to the default notification center
 *  after the allFlights property of the manager has changed.  This could be
 *  for multiple reasons, including a background refresh or user interaction.
 *
 *  One common use is to update a list of flights or a single flight status
 *  when this notification is dispatched so the user can see an immediate update
 *  of their data
 */
extern NSString * const FDMFlightManagerNotificationFlightsUpdated;

@interface FDMFlightManager : NSObject

/**
 *  Retrieve an instance of the Flight Manager.  This is the standard
 *  way of accessing the instance methods on this object.
 *
 *  Example:
 *  @code
 *  NSArray *allFlightsForUser = [[FDMFlightManager sharedInstance] allFlights];
 *  @endcode
 */
+ (instancetype)sharedInstance;

/**
 *  Retreive a list of all flights objects for the user.
 *
 *  @returns An immutable array of all flight objects(FDDFlight) for the user
 */
@property (readonly) NSArray *allFlights;
@end
