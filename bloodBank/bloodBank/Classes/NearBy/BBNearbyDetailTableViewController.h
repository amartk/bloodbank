//
//  BBNearbyDetailTableViewController.h
//  bloodBank
//
//  Created by amar tk on 14/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUITableViewZoomController.h"
#import <CoreLocation/CoreLocation.h>

@interface BBNearbyDetailTableViewController : TTUITableViewZoomController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) NSString *itemName;
@property(nonatomic, strong) NSString *pageTitle;

@end
