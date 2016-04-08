//
//  FDMAirportManager.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDMAirportManager.h"
#import "FDDAirport.h"

NSString * const FDMAirportImagePListResourceName = @"imageList";

NSString * const FDMAirportImagePreviewImageKey = @"previewResource";
NSString * const FDMAirportImageLargeImageKey = @"largeResource";
NSString * const FDMAirportImageAttributionLabelKey = @"attributionLabel";
NSString * const FDMAirportImageAttributionURLKey = @"attributionURL";

@implementation FDMAirportManager {
    NSMutableDictionary *_allAirports;
    NSDictionary *_airportImages;
}

+ (instancetype)sharedInstance
{
    static FDMAirportManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allAirports = [[NSMutableDictionary alloc] init];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:FDMAirportImagePListResourceName ofType:@"plist"];
        _airportImages = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return self;
}

- (void)resetAirportCache
{
    [_allAirports removeAllObjects];
}

- (FDDAirport *)getAirportByIATACode:(NSString *)iataCode
{
    return [_allAirports objectForKey:iataCode];
}

- (void)updateAirport:(FDDAirport *)newAirport
{
    [_allAirports setObject:newAirport forKey:newAirport.iataCode];
}

- (void)updateAirports:(NSArray *)airports
{
    for (FDDAirport *oneAirport in airports) {
        [self updateAirport:oneAirport];
    }
}

- (UIImage *)previewImageByIATACode:(NSString *)ianaCode
{
    NSDictionary *imageData = _airportImages[ianaCode] ?: _airportImages[@"Default"];
    return [UIImage imageNamed:imageData[FDMAirportImagePreviewImageKey]];
}

- (UIImage *)largeImageByIATACode:(NSString *)ianaCode
{
    NSDictionary *imageData = _airportImages[ianaCode] ?: _airportImages[@"Default"];
    return [UIImage imageNamed:imageData[FDMAirportImageLargeImageKey]];
}

- (NSString *)attributionLabelByIATACode:(NSString *)ianaCode
{
    NSDictionary *imageData = _airportImages[ianaCode] ?: _airportImages[@"Default"];
    return imageData[FDMAirportImageAttributionLabelKey];
}

- (NSURL *)attributionURLByIATACode:(NSString *)ianaCode
{
    NSDictionary *imageData = _airportImages[ianaCode] ?: _airportImages[@"Default"];
    return [NSURL URLWithString:imageData[FDMAirportImageAttributionURLKey]];
}

@end
