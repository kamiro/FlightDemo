//
//  FDCFlightInfoViewController.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/5/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDDFlight;

@interface FDCFlightInfoViewController : UIViewController <UIScrollViewDelegate>

@property(nonatomic) FDDFlight *flight;

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *departureAirportCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureAirportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTerminalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureGateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrivalAirportImageView;
@property (weak, nonatomic) IBOutlet UILabel *arrivalAirportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalAirportCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeZoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageAttributionButton;

@property (weak, nonatomic) IBOutlet UIScrollView *arrivalAirportImageScrollView;


@end
