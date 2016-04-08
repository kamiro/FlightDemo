//
//  FDMFlightAPIManagerTest.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDMFlightAPIManager.h"

@interface FDMFlightAPIManagerTest : XCTestCase

@end

@implementation FDMFlightAPIManagerTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetFlights
{
    static NSString * const flightPathJSON = @"flight.api";
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceURL = [testBundle URLForResource:flightPathJSON withExtension:@"json"];

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Get Flight Expectation"];
    [[FDMFlightAPIManager sharedInstance] getFlightList:^(NSArray *allFlights, NSArray *allAirports) {
        XCTAssertNotNil(allFlights);
        XCTAssertNotNil(allAirports);
        XCTAssertEqual(allFlights.count, 1);
        XCTAssertEqual(allAirports.count, 2);
        [expectation fulfill];
    } atURL:resourceURL];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

}


@end
