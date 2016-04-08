//
//  FDMFlightAPIManager.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDMFlightAPIManager : NSObject

/**
 *  Retrieve an instance of the API manager.  This is the standard
 *  way of accessing the instance methods on this object.
 *
 *  Example:
 *  @code
 *  [[FDMFlightAPIManager sharedInstance] getFlightList:completionBlock];
 *  @endcode
 */
+ (instancetype)sharedInstance;


/**
 *  This is a convenience method that allows one to retreive the flight list
 *  from a predetermined local json file
 *
 *  @see getFlightList:atURL:
 */
- (void)getFlightList:(void (^)(NSArray *allFlights, NSArray *allAirports))completion;

/**
 *  Retreive an up to date flight list for the current user.  This proces may
 *  take some time as it may involve a network call on a poor connection.  Your
 *  completion block is guarenteed to be called back with valid data or nil if
 *  a portion of the request was unsuccessful (eg. network failure,
 *  parsing error)
 *
 *  @param completion The block to call when the flight list has been retreived
 *                    and parsed.  Either allFlights or allAirports or both may
 *                    be provided with nil if theres an error related to that
 *                    data source.  allFlights will be a collection of FDDFlight
 *                    objects while allAirports will be a collection of
 *                    FDDAirport objects
 *  @param resourceURL The URL to look for the flight list
 *  @warning This currently only supports local URLs (aka not internet URLs)
 */
- (void)getFlightList:(void (^)(NSArray *allFlights, NSArray *allAirports))completion atURL:(NSURL *)resourceURL;

@end
