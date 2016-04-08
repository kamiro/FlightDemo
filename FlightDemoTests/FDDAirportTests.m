//
//  FDDAirportTests.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDDAirport.h"
#import "FDMAirportManager.h"
#import "FDTTestUtils.h"

@interface FDDAirportTests : XCTestCase

@end

@implementation FDDAirportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProperties {
    // Ensure the properties can be saved and retrieved without modification

    FDDAirport *testAirport = [[FDDAirport alloc] init];
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:1.0 longitude:1.0];
    NSTimeZone *testTimezone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];

    FDTTestNilThenSet(testAirport.iataCode, @"YVR");
    FDTTestNilThenSet(testAirport.commonCity, @"Vancouver");
    FDTTestNilThenSet(testAirport.name, @"Vancouver International Airport");
    FDTTestNilThenSet(testAirport.address, @"1234 My Street.");
    FDTTestNilThenSet(testAirport.city, @"Vancouver");
    FDTTestNilThenSet(testAirport.province, @"BC");
    FDTTestNilThenSet(testAirport.country, @"CA");
    FDTTestNilThenSet(testAirport.location, testLocation);
    FDTTestNilThenSet(testAirport.timezone, testTimezone);
}

- (void)testEquality {
    FDDAirport *testAirportA = [self getMockAirportLabeled:@"mockAirportA"];
    FDDAirport *testAirportB = [self getMockAirportLabeled:@"mockAirportB"];
    FDDAirport *testAirportBMod = [self getMockAirportLabeled:@"mockAirportBMod"];

    XCTAssertTrue([testAirportA isEqual:testAirportA]);
    XCTAssertFalse([testAirportB isEqual:testAirportBMod]);
    XCTAssertFalse([testAirportA isEqual:testAirportB]);
}

- (void)testCoding {
    FDDAirport *testAirportA = [[FDDAirport alloc] init];
    testAirportA.iataCode = @"TSB";
    testAirportA.commonCity = @"TestBMod CityCommon";
    testAirportA.name = @"TestBMod Name";
    testAirportA.address = @"TestBMod Address";
    testAirportA.city = @"TestBMod City";
    testAirportA.province = @"TBM";
    testAirportA.country = @"TestBModCountry";
    testAirportA.location = [[CLLocation alloc] initWithLatitude:3.0 longitude:3.0];
    testAirportA.timezone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];

    // Encoding:
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.requiresSecureCoding = YES;
    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
    [archiver encodeObject:testAirportA forKey:@"root"];
    [archiver finishEncoding];

    // This is the perfect point to breakpoint if you want to make mock XML objects
    // po [[NSString alloc] initWithData:data encoding:1] will print out the mock

    // Decoding:
    FDDAirport *resultAirport = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    XCTAssertTrue([testAirportA isEqualToAirport:resultAirport]);
}

- (FDDAirport *)getMockAirportLabeled:(NSString *)label
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:label ofType:@"xml"];
    FDDAirport *mockAirport = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return mockAirport;
}

- (void)testHelpers {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    FDDAirport *testAirport = [[FDDAirport alloc] init];
    XCTAssertNil(testAirport.iataCode);
    XCTAssertNotNil(testAirport.previewImage);
    XCTAssertNotNil(testAirport.largeImage);
    XCTAssertEqual(testAirport.attributionURL.absoluteString, [[[FDMAirportManager sharedInstance] attributionURLByIATACode:testAirport.iataCode] absoluteString]);
    XCTAssertEqual(testAirport.attributionLabel, [[FDMAirportManager sharedInstance] attributionLabelByIATACode:testAirport.iataCode]);

    testAirport.iataCode = @"YVR";
    XCTAssertNotNil(testAirport.iataCode);
    XCTAssertNotNil(testAirport.previewImage);
    XCTAssertNotNil(testAirport.largeImage);
    XCTAssertEqual(testAirport.attributionURL.absoluteString, [[[FDMAirportManager sharedInstance] attributionURLByIATACode:testAirport.iataCode] absoluteString]);
    XCTAssertEqual(testAirport.attributionLabel, [[FDMAirportManager sharedInstance] attributionLabelByIATACode:testAirport.iataCode]);
}



@end
