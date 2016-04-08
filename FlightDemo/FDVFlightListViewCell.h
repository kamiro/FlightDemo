//
//  FDVFlightListViewCell.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDDFlight;
@interface FDVFlightListViewCell : UITableViewCell

@property (nonatomic) FDDFlight *flight;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *arrivalCommonNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrivalAirportImage;
@end
