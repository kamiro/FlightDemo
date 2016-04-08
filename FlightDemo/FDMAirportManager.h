//
//  FDMAirportManager.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class FDDAirport;

@interface FDMAirportManager : NSObject

/**
 *  Retrieve an instance of the airport manager.  This is the standard
 *  way of accessing the instance methods on this object.
 *
 *  Example:
 *  @code
 *  airport = [[FDMAirportManager sharedInstance] getAiportByIATACode:@"YVR"];
 *  @endcode
 */
+ (instancetype)sharedInstance;

/** 
 *  Get an airport object that matches the airports IATA Airport Code
 * 
 *  @param iataCode The International Air Transport Association Airport Code
 *  @returns Related Airport Model for IATA Code
 */
- (FDDAirport *)getAirportByIATACode:(NSString *)iataCode;

/** 
 *  Update a single airport in the manager cache.  If you would like to update
 *  more then one airport simultaniously you can use updateAirports:
 *
 *  @see updateAirports:
 *  @warning If an airport with the same IATA code exists, it will be overwriten
 *           with the provided airport
 *  @param newAirport The new airport to set/overwrite
 */
- (void)updateAirport:(FDDAirport *)newAirport;

/**
 *  Update multiple airports in the manager cache.  If you would like to update
 *  more then one airport simultaniously you can use updateAirports:
 *
 *  @see updateAirport:
 *  @warning If an airport with the same IATA code exists, it will be overwriten
 *           with the provided airport
 *  @param airports An array of airport models to update the cache with
 */
- (void)updateAirports:(NSArray *)airports;

/**
 *  Reset all airports known by the airport manager.
 *  This is very useful in testing to clear the manager.
 */
- (void)resetAirportCache;

#pragma mark - Airport Image Lookup

/** A small preview image representing the airport's city. Normally thumbnail size
 *
 * @see largeImageByIATACode:
 */
- (UIImage *)previewImageByIATACode:(NSString *)ianaCode;
/** A large image representing the airport's city.  Normally full screen sized
 *
 *  @see previewImageByIATACode:
 */
- (UIImage *)largeImageByIATACode:(NSString *)ianaCode;
/** The legal attribution for the label in text form.  This will be linked to
 *  the attributionURL.
 *
 *  @see attributionURLByIATACode:
 */
- (NSString *)attributionLabelByIATACode:(NSString *)ianaCode;
/** The URL to popup when someone clicks on an attribution label for the airport
 *  images
 */
- (NSURL *)attributionURLByIATACode:(NSString *)ianaCode;


@end
