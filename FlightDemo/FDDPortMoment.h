//
//  FDDPortMoment.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDDAirport;

@interface FDDPortMoment : NSObject <NSSecureCoding>

/* The date that this moment will occur */
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *terminal;
@property (nonatomic) NSString *gate;
@property (nonatomic) NSString *iataCode;

// Helper methods calling managers
@property (nonatomic, readonly) FDDAirport *airport;

#pragma mark - NSObject helpers
/** Use to determine the equality between two port moments.
 *  This takes in to consideration all public properties.
 *
 *  Useful in unit tests
 *
 *  @param portMoment The other port moment to compare
 *  @returns A result of whether the two port moments are equal
 */
- (BOOL)isEqualToPortMoment:(FDDPortMoment *)portMoment;

@end
