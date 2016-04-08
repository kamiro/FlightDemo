//
//  FDDFlight.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDDPortMoment;

@interface FDDFlight : NSObject <NSSecureCoding>

/** The flight number of this flight. 
 *  Example: AC100
 */
@property (nonatomic) NSString *flightNumber;
/** The airline registered to service this flight
 *  Example: Air Canada
 */
@property (nonatomic) NSString *airline;

/** The port moment representing this departure
 *  
 *  @see FDDPortMoment
 */
@property (nonatomic) FDDPortMoment *departure;

/** The port moment representing this arrival
 *
 *  @see FDDPortMoment
 */
@property (nonatomic) FDDPortMoment *arrival;

#pragma mark - NSObject helpers
/** Use to determine the equality between two flights.
 *  This takes in to consideration all public properties.
 *
 *  Useful in unit tests
 *
 *  @param flight The other flight to compare
 *  @returns A result of whether the two flights are equal
 */
- (BOOL)isEqualToFlight:(FDDFlight *)flight;

@end
