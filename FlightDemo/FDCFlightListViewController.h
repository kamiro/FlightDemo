//
//  FDCFlightListViewController.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/6/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDCFlightListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
