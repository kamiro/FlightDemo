//
//  FDDFlightTests.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDDFlight.h"
#import "FDDPortMoment.h"
#import "FDTTestUtils.h"

@interface FDDFlightTests : XCTestCase

@end

@implementation FDDFlightTests {
    FDDPortMoment *testMoment;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testMoment = [[FDDPortMoment alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProperties {
    FDDFlight *testFlight = [[FDDFlight alloc] init];

    FDTTestNilThenSet(testFlight.flightNumber, @"AC100");
    FDTTestNilThenSet(testFlight.airline, @"Air Canada");
    FDTTestNilThenSet(testFlight.departure, testMoment);
    FDTTestNilThenSet(testFlight.arrival, testMoment);
}

- (void)testEquality {
    FDDFlight *testPortMomentA = [self getMockFlightLabeled:@"mockFlightA"];
    FDDFlight *testPortMomentB = [self getMockFlightLabeled:@"mockFlightB"];

    XCTAssertTrue([testPortMomentA isEqual:testPortMomentA]);
    XCTAssertFalse([testPortMomentA isEqual:testPortMomentB]);
}

- (void)testCoding {
    FDDPortMoment *testPortMomentA = [self getMockPortMomentLabeled:@"mockPortMomentA"];
    FDDPortMoment *testPortMomentB = [self getMockPortMomentLabeled:@"mockPortMomentB"];

    FDDFlight *testFlightA = [[FDDFlight alloc] init];
    testFlightA.flightNumber = @"AC101";
    testFlightA.airline = @"Air Canada";
    testFlightA.departure = testPortMomentA;
    testFlightA.arrival = testPortMomentB;

    // Encoding:
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.requiresSecureCoding = YES;
    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
    [archiver encodeObject:testFlightA forKey:@"root"];
    [archiver finishEncoding];

    // This is the perfect point to breakpoint if you want to make mock XML objects
    // po [[NSString alloc] initWithData:data encoding:1] will print out the mock

    // Decoding:
    FDDFlight *resultFlight = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertTrue([testFlightA isEqualToFlight:resultFlight]);
}

- (FDDFlight *)getMockFlightLabeled:(NSString *)label
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:label ofType:@"xml"];
    FDDFlight *mockFlight = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return mockFlight;
}

- (FDDPortMoment *)getMockPortMomentLabeled:(NSString *)label
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:label ofType:@"xml"];
    FDDPortMoment *mockPortMoment = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return mockPortMoment;
}


@end
