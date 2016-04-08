//
//  FDDFlight.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDDFlight.h"
#import "FDDPortMoment.h"
#import "FDUtils.h"

NSString * const FDDFlightCodingFlightNumberKey = @"flightNumber";
NSString * const FDDFlightCodingAirlineKey = @"airline";
NSString * const FDDFlightCodingDepartureKey = @"departure";
NSString * const FDDFlightCodingArrivalKey = @"arrival";

@implementation FDDFlight

#pragma mark - Equality and Hashing
- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToFlight:object];
}

- (BOOL)isEqualToFlight:(FDDFlight *)flight
{
    if (self == flight) {
        return YES;
    } else if (!nilEqual(_flightNumber, flight.flightNumber)) {
        return NO;
    } else if (!nilEqual(_airline, flight.airline)) {
        return NO;
    } else if (!nilEqual(_departure, flight.departure)) {
        return NO;
    } else if (!nilEqual(_arrival, flight.arrival)) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + [_flightNumber hash];
    result = prime * result + [_airline hash];
    result = prime * result + [_departure hash];
    result = prime * result + [_arrival hash];

    return result;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _flightNumber = [coder decodeObjectOfClass:[NSString class] forKey:FDDFlightCodingFlightNumberKey];
        _airline = [coder decodeObjectOfClass:[NSString class] forKey:FDDFlightCodingAirlineKey];
        _departure = [coder decodeObjectOfClass:[FDDPortMoment class] forKey:FDDFlightCodingDepartureKey];
        _arrival = [coder decodeObjectOfClass:[FDDPortMoment class] forKey:FDDFlightCodingArrivalKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_flightNumber forKey:FDDFlightCodingFlightNumberKey];
    [coder encodeObject:_airline forKey:FDDFlightCodingAirlineKey];
    [coder encodeObject:_departure forKey:FDDFlightCodingDepartureKey];
    [coder encodeObject:_arrival forKey:FDDFlightCodingArrivalKey];
}

@end
