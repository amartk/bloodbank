//
//  NearByTableViewController.m
//  bloodBank
//
//  Created by amar tk on 02/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "NearByTableViewController.h"
#import "NearByTableViewCell.h"
#import "BBNearbyDetailTableViewController.h"
#import "BBUtilityManager.h"
#import <CoreLocation/CoreLocation.h>

@interface NearByTableViewController ()
{
    NSDictionary *nearByItemsList;
    NSArray *nearByItemsKeys;
    CLLocationManager *locationManager;
    
}
@end

@implementation NearByTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nearByItemsList = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NearByItems" ofType:@"plist"]];
    
    locationManager = [[CLLocationManager alloc] init];

    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    nearByItemsKeys = [[nearByItemsList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [nearByItemsKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearByTableViewCell *cell = (NearByTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"nearByCell" forIndexPath:indexPath];
    
    if (cell == nil) {        
        cell = [[NearByTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nearByCell"];
    }
    
    cell.cellTitle.text = [nearByItemsKeys objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", [NSDate date]);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BBNearbyDetailTableViewController *nearByDetailVC = (BBNearbyDetailTableViewController *)segue.destinationViewController;
    NearByTableViewCell *cell = (NearByTableViewCell *)sender;
        
    nearByDetailVC.title = cell.cellTitle.text;
    nearByDetailVC.itemName = [nearByItemsList objectForKey:cell.cellTitle.text];
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([[[BBUtilityManager sharedInstance] reachability] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Internet connectivty needed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enable location services on your device. Go to Settings -> Privacy -> Location services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enable bloodbank to use your current location. Go to Settings -> Privacy -> Location services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:123];
        [alert show];
        return NO;
        
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

@end
