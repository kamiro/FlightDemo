//
//  FDDAirport.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDDAirport.h"
#import "FDMAirportManager.h"
#import "FDUtils.h"

// Keys used for NSSecureCoding
NSString * const FDDAirportCodingIATAKey = @"iataCode";
NSString * const FDDAirportCodingCommonCityKey = @"commonCity";
NSString * const FDDAirportCodingNameKey = @"name";
NSString * const FDDAirportCodingAddressKey = @"address";
NSString * const FDDAirportCodingCityKey = @"city";
NSString * const FDDAirportCodingProvinceKey = @"province";
NSString * const FDDAirportCodingCountryKey = @"country";
NSString * const FDDAirportCodingLocationKey = @"location";
NSString * const FDDAirportCodingTimezoneKey = @"timezone";

@implementation FDDAirport

- (UIImage *)previewImage {
    return [[FDMAirportManager sharedInstance] previewImageByIATACode:self.iataCode];
}

- (UIImage *)largeImage {
    return [[FDMAirportManager sharedInstance] largeImageByIATACode:self.iataCode];
}

- (NSString *)attributionLabel {
    return [[FDMAirportManager sharedInstance] attributionLabelByIATACode:self.iataCode];
}

- (NSURL *)attributionURL {
    return [[FDMAirportManager sharedInstance] attributionURLByIATACode:self.iataCode];
}

#pragma mark - Equality and Hashing
- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToAirport:object];
}

- (BOOL)isEqualToAirport:(FDDAirport *)airport
{
    if (self == airport) {
        return YES;
    } else if (!nilEqual(_iataCode, airport.iataCode)) {
        return NO;
    } else if (!nilEqual(_commonCity, airport.commonCity)) {
        return NO;
    } else if (!nilEqual(_name, airport.name)) {
        return NO;
    } else if (!nilEqual(_address, airport.address)) {
        return NO;
    } else if (!nilEqual(_city, airport.city)) {
        return NO;
    } else if (!nilEqual(_province, airport.province)) {
        return NO;
    } else if (!nilEqual(_country, airport.country)) {
        return NO;
    } else if (!((_location == nil && airport.location == nil) || ([_location distanceFromLocation:airport.location] == 0.0))) {
        return NO;
    } else if (!nilEqual(_timezone, airport.timezone)) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + [_iataCode hash];
    result = prime * result + [_commonCity hash];
    result = prime * result + [_name hash];
    result = prime * result + [_address hash];
    result = prime * result + [_city hash];
    result = prime * result + [_province hash];
    result = prime * result + [_country hash];
    result = prime * result + [_location hash];
    result = prime * result + [_timezone hash];

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
        _iataCode = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingIATAKey];
        _commonCity = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingCommonCityKey];
        _name = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingNameKey];
        _address = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingAddressKey];
        _city = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingCityKey];
        _province = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingProvinceKey];
        _country = [coder decodeObjectOfClass:[NSString class] forKey:FDDAirportCodingCountryKey];
        _location = [coder decodeObjectOfClass:[CLLocation class] forKey:FDDAirportCodingLocationKey];
        _timezone = [coder decodeObjectOfClass:[NSTimeZone class] forKey:FDDAirportCodingTimezoneKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_iataCode forKey:FDDAirportCodingIATAKey];
    [coder encodeObject:_commonCity forKey:FDDAirportCodingCommonCityKey];
    [coder encodeObject:_name forKey:FDDAirportCodingNameKey];
    [coder encodeObject:_address forKey:FDDAirportCodingAddressKey];
    [coder encodeObject:_city forKey:FDDAirportCodingCityKey];
    [coder encodeObject:_province forKey:FDDAirportCodingProvinceKey];
    [coder encodeObject:_country forKey:FDDAirportCodingCountryKey];
    [coder encodeObject:_location forKey:FDDAirportCodingLocationKey];
    [coder encodeObject:_timezone forKey:FDDAirportCodingTimezoneKey];
}

@end
