//
//  FDMAirportManagerTests.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDMAirportManager.h"
#import "FDDAirport.h"

@interface FDMAirportManagerTests : XCTestCase

@end

@implementation FDMAirportManagerTests {
    FDDAirport *testAirportA;
    FDDAirport *testAirportBMod;
    FDDAirport *testAirportB;
}

- (void)setUp {
    [super setUp];
    [[FDMAirportManager sharedInstance] resetAirportCache];

    testAirportA = [self getMockAirportLabeled:@"mockAirportA"];
    testAirportB = [self getMockAirportLabeled:@"mockAirportB"];
    testAirportBMod = [self getMockAirportLabeled:@"mockAirportBMod"];
}

- (void)tearDown {
    testAirportA = nil;
    testAirportB = nil;
    [[FDMAirportManager sharedInstance] resetAirportCache];
    [super tearDown];
}
- (void)testSingleUpdateAndReset {
    [[FDMAirportManager sharedInstance] updateAirport:testAirportA];
    [[FDMAirportManager sharedInstance] updateAirport:testAirportB];

    FDDAirport *foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportA.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportA]);

    foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportB.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportB]);

    foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:@"XXX"];
    XCTAssertNil(foundAirport);

    [[FDMAirportManager sharedInstance] resetAirportCache];
    foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportA.iataCode];
    XCTAssertNil(foundAirport);
}

- (void)testMultipleUpdate {
    [[FDMAirportManager sharedInstance] updateAirports:@[testAirportA, testAirportB]];

    FDDAirport *foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportA.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportA]);
    foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportB.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportB]);
}

- (void)testOverwrite {
    [[FDMAirportManager sharedInstance] updateAirport:testAirportB];
    FDDAirport *foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportB.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportB]);

    [[FDMAirportManager sharedInstance] updateAirport:testAirportBMod];
    foundAirport = [[FDMAirportManager sharedInstance] getAirportByIATACode:testAirportB.iataCode];
    XCTAssertTrue([foundAirport isEqualToAirport:testAirportBMod]);
}

- (void)testImageInformation {
    XCTAssertNotNil([[FDMAirportManager sharedInstance] previewImageByIATACode:@"YVR"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] largeImageByIATACode:@"YVR"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] attributionURLByIATACode:@"YVR"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] attributionLabelByIATACode:@"YVR"]);

    XCTAssertNotNil([[FDMAirportManager sharedInstance] previewImageByIATACode:@"XXX"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] largeImageByIATACode:@"XXX"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] attributionURLByIATACode:@"XXX"]);
    XCTAssertNotNil([[FDMAirportManager sharedInstance] attributionLabelByIATACode:@"XXX"]);
}

- (FDDAirport *)getMockAirportLabeled:(NSString *)label
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:label ofType:@"xml"];
    FDDAirport *mockAirport = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return mockAirport;
}

@end
