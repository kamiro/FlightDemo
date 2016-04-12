//
//  FDCFlightListViewController.m
//  FlightDemo
//
//  Created by Gary Morrison on 4/6/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import "FDCFlightListViewController.h"
#import "FDMFlightManager.h"
#import "FDDFlight.h"
#import "FDVFlightListViewCell.h"
#import "FDCFlightInfoViewController.h"

NSString * const FDVFlightListViewCellNibName = @"FDVFlightListViewCell";
NSString * const FDVFlightListViewCellReuseIdentifier = @"FDVFlightListViewCell";

@implementation FDCFlightListViewController {
    NSArray *_allFlights;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Flights", @"Shown as the title of the list of flights");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView registerNib:[UINib nibWithNibName:FDVFlightListViewCellNibName bundle:nil] forCellReuseIdentifier:FDVFlightListViewCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flightsUpdated:) name:FDMFlightManagerNotificationFlightsUpdated object:nil];
    [self _retreiveNewFlightList];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FDMFlightManagerNotificationFlightsUpdated object:nil];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allFlights ? _allFlights.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDVFlightListViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier:FDVFlightListViewCellReuseIdentifier];

    FDDFlight *flightForRow = [_allFlights objectAtIndex:indexPath.row];
    viewCell.flight = flightForRow;

    return viewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FDDFlight *flightForRow = [_allFlights objectAtIndex:indexPath.row];
    FDCFlightInfoViewController *flightInfoController = [[FDCFlightInfoViewController alloc] initWithNibName:nil bundle:nil];
    flightInfoController.flight = flightForRow;
    [self.navigationController pushViewController:flightInfoController animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)flightsUpdated:(NSNotification *)notification {
    // Ensure when responding to notifications we're on the main thread
    // when doing UI work.

    __weak FDCFlightListViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // Use strong/weak pattern in case the view controller will be destroyed
        // before this block executes... No point in keeping it alive just to
        // honor a refresh (that now makes no difference because the controller
        // has been destroyed)
        FDCFlightListViewController *strongSelf = weakSelf;
        [strongSelf _retreiveNewFlightList];
    });
}

- (void)_retreiveNewFlightList {
    _allFlights = [[FDMFlightManager sharedInstance] allFlights];
    [_tableView reloadData];
}
@end
