//
//  FDVFlightListViewCell.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDVFlightListViewCell.h"
#import "FDDFlight.h"
#import "FDDPortMoment.h"
#import "FDDAirport.h"

@implementation FDVFlightListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self _updateLabels];
}

- (void)setFlight:(FDDFlight *)flight
{
    _flight = flight;
    [self _updateLabels];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_updateLabels
{
    _arrivalCommonNameLabel.text = _flight.arrival.airport.commonCity ?: NSLocalizedString(@"Unknown", @"Shown when a property is unknown (eg. airport city, airport name, etc.)");

    // Time Information
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateStyle = NSDateFormatterLongStyle;
    timeFormatter.timeStyle = NSDateFormatterNoStyle;
    timeFormatter.timeZone = _flight.arrival.airport.timezone;
    timeFormatter.timeZone = _flight.departure.airport.timezone;
    NSString *departureDate = [timeFormatter stringFromDate:_flight.departure.date];
    _departureDateLabel.text = departureDate;

    timeFormatter.dateStyle = NSDateFormatterNoStyle;
    timeFormatter.timeStyle = NSDateFormatterShortStyle;

    // Departure
    _departureTimeLabel.text = [timeFormatter stringFromDate:_flight.departure.date];
    _departureTimeZoneLabel.text = _flight.departure.airport.timezone.abbreviation;

    _arrivalAirportImage.image = _flight.arrival.airport.previewImage;
}
@end
