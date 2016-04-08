//
//  FDDPortMoment.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDDPortMoment.h"
#import "FDMAirportManager.h"
#import "FDDAirport.h"
#import "FDUtils.h"

NSString * const FDDPortMomentCodingDateKey = @"date";
NSString * const FDDPortMomentCodingTerminalKey = @"terminal";
NSString * const FDDPortMomentCodingGateKey = @"gate";
NSString * const FDDPortMomentCodingIATACodeKey = @"iataCode";

@implementation FDDPortMoment

- (FDDAirport *)airport {
    if (!_iataCode) {
        return nil;
    }

    return [[FDMAirportManager sharedInstance] getAirportByIATACode:_iataCode];
}

#pragma mark - Equality and Hashing
- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToPortMoment:object];
}

- (BOOL)isEqualToPortMoment:(FDDPortMoment *)portMoment
{
    if (self == portMoment) {
        return YES;
    } else if (!nilEqual(_date, portMoment.date)) {
        return NO;
    } else if (!nilEqual(_terminal, portMoment.terminal)) {
        return NO;
    } else if (!nilEqual(_gate, portMoment.gate)) {
        return NO;
    } else if (!nilEqual(_iataCode, portMoment.iataCode)) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + [_date hash];
    result = prime * result + [_terminal hash];
    result = prime * result + [_gate hash];
    result = prime * result + [_iataCode hash];

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
        _date = [coder decodeObjectOfClass:[NSString class] forKey:FDDPortMomentCodingDateKey];
        _terminal = [coder decodeObjectOfClass:[NSString class] forKey:FDDPortMomentCodingTerminalKey];
        _gate = [coder decodeObjectOfClass:[FDDPortMoment class] forKey:FDDPortMomentCodingGateKey];
        _iataCode = [coder decodeObjectOfClass:[FDDPortMoment class] forKey:FDDPortMomentCodingIATACodeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_date forKey:FDDPortMomentCodingDateKey];
    [coder encodeObject:_terminal forKey:FDDPortMomentCodingTerminalKey];
    [coder encodeObject:_gate forKey:FDDPortMomentCodingGateKey];
    [coder encodeObject:_iataCode forKey:FDDPortMomentCodingIATACodeKey];
}
@end
