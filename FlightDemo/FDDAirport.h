//
//  FDDAirport.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class UIImage;

@interface FDDAirport : NSObject <NSSecureCoding>

/** The IATA assigned airport code.  It's commonly 3 letters.
 *  Example: YYZ
 */
@property (nonatomic) NSString *iataCode;

/** The commonly known name of the airport
 *
 *  @warning This often differs from the official city of the airport
 *           as many cities can't build airports in their downtown core.
 *  Example: Toronto
 */
@property (nonatomic) NSString *commonCity;

/** The official name of the airport
 *  Example: Toronto Pearson International Airport
 */
@property (nonatomic) NSString *name;
/** The official address of the airport (preferably searchable through
 *  a geolocation API of some sort)
 *
 *  Example: 6301 Silver Dart Dr
 */
@property (nonatomic) NSString *address;
/** The official city of the airport
 *  Example: Mississauga
 */
@property (nonatomic) NSString *city;
/** The official province or state of the airport, abbreviated.
 *  Example: ON
 */
@property (nonatomic) NSString *province;
/** The official country of the airport
 *  Example: Canada
 */
@property (nonatomic) NSString *country;

/** The GPS Location of this airport */
@property (nonatomic) CLLocation *location;

/** The local timezone of the airport
 *
 *  This is used when displaying the departure or arrival time in the local
 *  timezone so that a users time matches those displayed on in airport
 *  information screens
 */
@property (nonatomic) NSTimeZone *timezone;

#pragma mark - Helper Methods
/** A convenience method for retreiving the previewImage from the
 *  FDMAirportManager
 *
 *  @see FDMAirportManager previewImageByIATACode:
 */
@property (nonatomic, readonly) UIImage *previewImage;

/** A convenience method for retreiving the largeImage from the
 *  FDMAirportManager
 *
 *  @see FDMAirportManager largeImageByIATACode:
 */
@property (nonatomic, readonly) UIImage *largeImage;

/** A convenience method for retreiving the attribution label from the
 *  FDMAirportManager
 * 
 *  @see FDMAirportManager attributionLabelByIATACode:
 */
@property (nonatomic, readonly) NSString *attributionLabel;
/** A convenience method for retreiving the attributionURL from the
 *  FDMAirportManager
 *
 *  @see FDMAirportManager attributionURLByIATACode:
 */
@property (nonatomic, readonly) NSURL *attributionURL;

#pragma mark - NSObject helpers
/** Use to determine the equality between two airports.
 *  This takes in to consideration all public properties.
 *
 *  Useful in unit tests
 *
 *  @param airport The other airport to compare
 *  @returns A result of whether the two airports are equal
 */
- (BOOL)isEqualToAirport:(FDDAirport *)airport;
@end
