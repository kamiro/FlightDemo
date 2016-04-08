//
//  FDCFlightInfoViewController.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "FDCFlightInfoViewController.h"
#import "FDDFlight.h"
#import "FDDPortMoment.h"
#import "FDDAirport.h"

CGFloat const FDCFlightInfoViewControllerArrivalImageAnimationSpeed = 20.0;
NSString * const FDCFlightInfoViewControllerNibName = @"FDCFlightInfoViewController";

@interface FDCFlightInfoViewController ()

@end

@implementation FDCFlightInfoViewController {
    BOOL _arrivalImageScrolling;
    BOOL _arrivalImageSetup;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:FDCFlightInfoViewControllerNibName bundle:nil];
    if (self) {

    }
    return self;
}

- (void)setFlight:(FDDFlight *)flight
{
    _flight = flight;
    [self _updateFlightLabels];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Update flight labels if the flight was set before the view was loaded.
    [self _updateFlightLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performArrivalImageAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopArrivalImageAnimation];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Setup initial scroll view content offset (which needs to come before
    // view did appear but relys on auto layout to finish the layout phase)

    if (!_arrivalImageSetup) {
        [self moveScrollView];
        _arrivalImageSetup = YES;
    }
}

#pragma mark - Private Methods
- (void)_updateFlightLabels
{
    if (!_flight) {
        return;
    }

    // Airport code information
    _departureAirportCodeLabel.text = _flight.departure.airport.iataCode ?: NSLocalizedString(@"???", @"Shown when the three letter IATA airport code is unknown");
    _departureAirportNameLabel.text = _flight.departure.airport.commonCity ?: NSLocalizedString(@"Unknown", @"Shown when a property is unknown (eg. airport city, airport name, etc.)");
    _arrivalAirportCodeLabel.text = _flight.arrival.airport.iataCode ?: NSLocalizedString(@"???", @"Shown when the three letter IATA airport code is unknown");
    _arrivalAirportNameLabel.text = _flight.arrival.airport.commonCity ?: NSLocalizedString(@"Unknown", @"Shown when a property is unknown (eg. airport city, airport name, etc.)");

    // Terminal and Gate Information
    NSString *terminal = _flight.departure.terminal ?: NSLocalizedString(@"Unknown", @"Shown when a property is unknown (eg. airport city, airport name, etc.)");
    _departureTerminalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Terminal: %@", @"Listing the terminal of the flight, the %@ will be replaced by the terminal name"), terminal];

    NSString *gate = _flight.departure.gate ?: NSLocalizedString(@"Unknown", @"Shown when a property is unknown (eg. airport city, airport name, etc.)");
    _departureGateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Gate: %@", @"Listing the gate of the flight, the %@ will be replaced by the gate"), gate];


    // Time Information
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateStyle = NSDateFormatterLongStyle;
    timeFormatter.timeStyle = NSDateFormatterNoStyle;
    timeFormatter.timeZone = _flight.arrival.airport.timezone;
    NSString *arrivalDate = [timeFormatter stringFromDate:_flight.arrival.date];
    timeFormatter.timeZone = _flight.departure.airport.timezone;
    NSString *departureDate = [timeFormatter stringFromDate:_flight.departure.date];
    NSString *departureDatePlusOne = [timeFormatter stringFromDate: [_flight.departure.date dateByAddingTimeInterval:24.0 * 60.0 * 60.0]];

    timeFormatter.dateStyle = NSDateFormatterNoStyle;
    timeFormatter.timeStyle = NSDateFormatterShortStyle;

    // Departure
    _departureTimeLabel.text = [timeFormatter stringFromDate:_flight.departure.date];
    _departureTimeZoneLabel.text = _flight.departure.airport.timezone.abbreviation;
    // Arrival
    timeFormatter.timeZone = _flight.arrival.airport.timezone;
    _arrivalTimeLabel.text = [timeFormatter stringFromDate:_flight.arrival.date];

    // This is a crude way of calculating the date difference, but it NSDate takes
    // care of all the nitty gritty.  In short dates and timezones are hard, and
    // someone else has already taken care of it.
    if ([arrivalDate isEqualToString:departureDate]) {
        _arrivalTimeZoneLabel.text = _flight.arrival.airport.timezone.abbreviation;
    } else if([arrivalDate isEqualToString:departureDatePlusOne]) {
        _arrivalTimeZoneLabel.text = [NSString stringWithFormat:@"%@+1", _flight.arrival.airport.timezone.abbreviation];
    } else { // Crossed the date line
        _arrivalTimeZoneLabel.text = [NSString stringWithFormat:@"%@-1", _flight.arrival.airport.timezone.abbreviation];
    }

    // Arrival Image Information
    _arrivalAirportImageView.image = _flight.arrival.airport.largeImage;
    [_imageAttributionButton setTitle:_flight.arrival.airport.attributionLabel forState:UIControlStateNormal];
}

#pragma mark - Button Handlers

- (IBAction)imageAttributionTapped:(UIButton *)sender
{
    NSURL *attributionURL = _flight.arrival.airport.attributionURL;
    [[UIApplication sharedApplication] openURL:attributionURL];
}

#pragma mark - Arrival Image Animation

- (void)stopArrivalImageAnimation
{
    [self.arrivalAirportImageScrollView.layer removeAllAnimations];
    _arrivalImageScrolling = NO;
}

- (void)performArrivalImageAnimation
{
    if (_arrivalImageScrolling) {
        return;
    }
    _arrivalImageScrolling = YES;

    [UIView animateWithDuration:FDCFlightInfoViewControllerArrivalImageAnimationSpeed animations:^{
        [self moveScrollView];
    } completion:^(BOOL finished) {
        [self performArrivalImageAnimation];
    }];
}

- (void)moveScrollView
{
    CGFloat xSpace = self.arrivalAirportImageView.frame.size.width - self.view.bounds.size.width;
    CGFloat ySpace = self.arrivalAirportImageView.frame.size.height - self.view.bounds.size.height;

    CGFloat xContentOffset = arc4random_uniform(floorf(xSpace));
    CGFloat yContentOffset = arc4random_uniform(floorf(ySpace));
    self.arrivalAirportImageScrollView.contentOffset = CGPointMake(xContentOffset, yContentOffset);
}

@end
