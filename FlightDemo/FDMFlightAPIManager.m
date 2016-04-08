//
//  FDMFlightAPIManager.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDMFlightAPIManager.h"
#import "FDDFlight.h"
#import "FDDAirport.h"
#import "FDDPortMoment.h"

// Version 1 - JSON Resource Keys
// Used to extract data from JSON flight lists
NSString * const FDMJSONResourceKeyFlights = @"flights";
NSString * const FDMJSONResourceKeyFlightNumber = @"flightNumber";
NSString * const FDMJSONResourceKeyFlightAirline = @"airline";
NSString * const FDMJSONResourceKeyFlightDepartureMoment = @"departure";
NSString * const FDMJSONResourceKeyFlightArrivalMoment = @"arrival";
NSString * const FDMJSONResourceKeyFlightMomentDate = @"datetime";
NSString * const FDMJSONResourceKeyFlightMomentTerminal = @"terminal";
NSString * const FDMJSONResourceKeyFlightMomentGate = @"gate";
NSString * const FDMJSONResourceKeyFlightMomentIATACode = @"iataCode";

NSString * const FDMJSONResourceKeyAirports = @"airports";
NSString * const FDMJSONResourceKeyAirportIATACode = @"iataCode";
NSString * const FDMJSONResourceKeyAirportCommonCity = @"commonCity";
NSString * const FDMJSONResourceKeyAirportName = @"name";
NSString * const FDMJSONResourceKeyAirportAddress = @"address";
NSString * const FDMJSONResourceKeyAirportCity = @"city";
NSString * const FDMJSONResourceKeyAirportProvince = @"province";
NSString * const FDMJSONResourceKeyAirportCountry = @"country";
NSString * const FDMJSONResourceKeyAirportGPSLatitude = @"gpsLatitude";
NSString * const FDMJSONResourceKeyAirportGPSLongitude = @"gpsLongitude";
NSString * const FDMJSONResourceKeyAirportTimezone = @"timezone";

NSString * const FDMAPIDispatchProcessingQueueName = @"com.morrison.flightdemo.apiprocessingqueue";

@implementation FDMFlightAPIManager {
    dispatch_queue_t _processingQueue;
}

+ (instancetype)sharedInstance {
    static FDMFlightAPIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _processingQueue = dispatch_queue_create([FDMAPIDispatchProcessingQueueName UTF8String], NULL);
    }
    return self;
}

- (void)getFlightList:(void (^)(NSArray *allFlights, NSArray *allAirports))completion {
    static NSString * const flightPathJSON = @"flight.api";
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:flightPathJSON withExtension:@"json"];
    [self getFlightList:completion atURL:resourceURL];
}

- (void)getFlightList:(void (^)(NSArray *allFlights, NSArray *allAirports))completion atURL:(NSURL *)resourceURL {
    dispatch_async(_processingQueue,^{
        NSObject *jsonObject = [self loadFromJSONResource:resourceURL];

        NSMutableArray *allFlights = nil;
        NSMutableArray *allAirports = nil;

        if (![jsonObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{completion(allFlights, allAirports);});
            return;
        }

        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSArray *jsonFlights = checkKeyIsArrayOrNil(jsonDictionary, FDMJSONResourceKeyFlights) ?: @[];
        if (jsonFlights) {
            allFlights = [[NSMutableArray alloc] initWithCapacity:jsonFlights.count];
            for (NSObject *oneFlight in jsonFlights) {
                if (![oneFlight isKindOfClass:[NSDictionary class]] ) {
                    continue;
                }

                [allFlights addObject:[FDMFlightAPIManager _flightFromV1JSONDictionary:(NSDictionary *)oneFlight]];
            }
        }

        NSArray *jsonAirports = checkKeyIsArrayOrNil(jsonDictionary, FDMJSONResourceKeyAirports) ?: @[];
        if (jsonAirports) {
            allAirports = [[NSMutableArray alloc] initWithCapacity:jsonAirports.count];
            for (NSObject *oneAirport in jsonAirports) {
                if (![oneAirport isKindOfClass:[NSDictionary class]] ) {
                    continue;
                }

                [allAirports addObject:[FDMFlightAPIManager _airportFromV1JSONDictionary:(NSDictionary *)oneAirport]];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{completion(allFlights, allAirports);});
    });
}


#pragma mark - Importing
- (NSObject *)loadFromJSONResource:(NSURL *)resourceURL
{
    if (![resourceURL isFileURL]) {
        // Handle other retrievals later (aka URL)
        return nil;
    }

    NSData *data = [[NSFileManager defaultManager] contentsAtPath:resourceURL.path];

    NSError *jsonParseError = nil;
    NSObject *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];

    if (jsonParseError) {
        NSLog(@"Unable to parse JSON.  Is the file in the correct format?  Serializer returned: %@", [jsonParseError description]);
        return nil;
    }

    if (![jsonResult isKindOfClass:[NSArray class]] && ![jsonResult isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsed JSON file, but did not see an array.  Is the file in the correct format? Found type: %@", NSStringFromClass([jsonResult class]));
        return nil;
    }

    return jsonResult;
}

+ (FDDFlight *)_flightFromV1JSONDictionary:(NSDictionary *)jsonDictionary
{
    FDDFlight *newFlight = [[FDDFlight alloc] init];

    newFlight.flightNumber = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyFlightNumber);
    newFlight.airline = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyFlightAirline);

    NSDictionary *departureMoment = checkKeyIsDictionaryOrNil(jsonDictionary, FDMJSONResourceKeyFlightDepartureMoment);
    newFlight.departure = [self _portMomentFromV1JSONDictionary:departureMoment];

    NSDictionary *arrivalMoment = checkKeyIsDictionaryOrNil(jsonDictionary, FDMJSONResourceKeyFlightArrivalMoment);
    newFlight.arrival = [self _portMomentFromV1JSONDictionary:arrivalMoment];

    return newFlight;
}

+ (FDDPortMoment *)_portMomentFromV1JSONDictionary:(NSDictionary *)jsonDictionary
{
    FDDPortMoment *newPortMoment = [[FDDPortMoment alloc] init];

    newPortMoment.terminal = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyFlightMomentTerminal);
    newPortMoment.gate = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyFlightMomentGate);
    newPortMoment.iataCode = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyFlightMomentIATACode);

    NSNumber *dateNumber = checkKeyIsNumberOrNil(jsonDictionary, FDMJSONResourceKeyFlightMomentDate);
    newPortMoment.date = dateNumber ? [NSDate dateWithTimeIntervalSince1970:[dateNumber integerValue]] : nil;

    return newPortMoment;
}

+ (FDDAirport *)_airportFromV1JSONDictionary:(NSDictionary *)jsonDictionary
{
    FDDAirport *newAirport = [[FDDAirport alloc] init];

    newAirport.iataCode = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportIATACode);
    newAirport.commonCity = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportCommonCity);
    newAirport.name = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportName);
    newAirport.address = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportAddress);
    newAirport.city = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportCity);
    newAirport.province = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportProvince);
    newAirport.country = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportCountry);

    NSString *timezone = checkKeyIsStringOrNil(jsonDictionary, FDMJSONResourceKeyAirportTimezone);
    newAirport.timezone = timezone ? [NSTimeZone timeZoneWithAbbreviation:timezone] : nil;


    NSNumber *latitudeNumber = checkKeyIsNumberOrNil(jsonDictionary, FDMJSONResourceKeyAirportGPSLatitude);
    NSNumber *longitudeNumber = checkKeyIsNumberOrNil(jsonDictionary, FDMJSONResourceKeyAirportGPSLongitude);

    newAirport.location = (latitudeNumber && longitudeNumber) ? [[CLLocation alloc] initWithLatitude:[latitudeNumber doubleValue] longitude:[longitudeNumber doubleValue]] : nil;

    return newAirport;
}


#pragma mark - Helper Methods
static inline NSDictionary *checkKeyIsDictionaryOrNil(NSDictionary *baseDictionary, NSString *key) {
    return [baseDictionary[key] isKindOfClass:[NSDictionary class]] ? baseDictionary[key] : nil;
}

static inline NSArray *checkKeyIsArrayOrNil(NSDictionary *baseDictionary, NSString *key) {
    return [baseDictionary[key] isKindOfClass:[NSArray class]] ? baseDictionary[key] : nil;
}

static inline NSString *checkKeyIsStringOrNil(NSDictionary *baseDictionary, NSString *key) {
    return [baseDictionary[key] isKindOfClass:[NSString class]] ? baseDictionary[key] : nil;
}

static inline NSNumber *checkKeyIsNumberOrNil(NSDictionary *baseDictionary, NSString *key) {
    return [baseDictionary[key] isKindOfClass:[NSNumber class]] ? baseDictionary[key] : nil;
}

@end
