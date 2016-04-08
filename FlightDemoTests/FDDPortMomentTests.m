//
//  FDDPortMomentTests.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDDPortMoment.h"
#import "FDDAirport.h"
#import "FDTTestUtils.h"
#import "FDMAirportManager.h"

@interface FDDPortMomentTests : XCTestCase

@end

@implementation FDDPortMomentTests

- (void)setUp {
    [super setUp];

    FDDAirport *tempAirport = [[FDDAirport alloc] init];
    tempAirport.iataCode = @"YVR";
    [[FDMAirportManager sharedInstance] updateAirport:tempAirport];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testProperties {
    FDDPortMoment *testPortMoment = [[FDDPortMoment alloc] init];

    NSDate *testDate = [NSDate dateWithTimeIntervalSinceNow:0];
    FDTTestNilThenSet(testPortMoment.date, testDate);
    FDTTestNilThenSet(testPortMoment.terminal, @"Int");
    FDTTestNilThenSet(testPortMoment.gate, @"G4");
    FDTTestNilThenSet(testPortMoment.iataCode, @"YVR");
}

- (void)testHelpers {
    FDDPortMoment *testPortMoment = [[FDDPortMoment alloc] init];

    // Test nil airport code
    XCTAssertNil(testPortMoment.iataCode);
    XCTAssertNil(testPortMoment.airport);

    // Test known airport code
    NSString *testIATACode = @"YVR";
    testPortMoment.iataCode = testIATACode;
    XCTAssertNotNil(testPortMoment.airport);
    XCTAssertEqual(testPortMoment.airport.iataCode, testIATACode);

    // Test unknown airport code
    testIATACode = @"XXX";
    testPortMoment.iataCode = testIATACode;
    XCTAssertNil(testPortMoment.airport);
}

- (void)testEquality {
    FDDPortMoment *testPortMomentA = [self getMockPortMomentLabeled:@"mockPortMomentA"];
    FDDPortMoment *testPortMomentB = [self getMockPortMomentLabeled:@"mockPortMomentB"];

    XCTAssertTrue([testPortMomentA isEqual:testPortMomentA]);
    XCTAssertFalse([testPortMomentA isEqual:testPortMomentB]);
}

- (void)testCoding {
    FDDPortMoment *testPortMomentA = [[FDDPortMoment alloc] init];
    testPortMomentA.date = [NSDate dateWithTimeIntervalSinceNow:0];
    testPortMomentA.terminal = @"PortMomentA Terminal";
    testPortMomentA.gate = @"PortMomentA Gate";
    testPortMomentA.iataCode = @"TSA";

    // Encoding:
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.requiresSecureCoding = YES;
    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
    [archiver encodeObject:testPortMomentA forKey:@"root"];
    [archiver finishEncoding];

    // This is the perfect point to breakpoint if you want to make mock XML objects
    // po [[NSString alloc] initWithData:data encoding:1] will print out the mock

    // Decoding:
    FDDPortMoment *resultPortMoment = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertTrue([testPortMomentA isEqualToPortMoment:resultPortMoment]);
}

- (FDDPortMoment *)getMockPortMomentLabeled:(NSString *)label
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:label ofType:@"xml"];
    FDDPortMoment *mockPortMoment = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return mockPortMoment;
}


@end
