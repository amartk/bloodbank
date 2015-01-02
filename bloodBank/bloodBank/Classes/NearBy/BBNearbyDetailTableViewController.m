//
//  BBNearbyDetailTableViewController.m
//  bloodBank
//
//  Created by amar tk on 14/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "BBNearbyDetailTableViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

#define ERROR_FETCHING_LOCATION 100

@interface BBNearbyDetailTableViewController ()
{
    NSArray *itemsList;
    CLLocationManager *locationManager;
    NSString *postalCode;
    CLLocation *currentLocation;
    
}
@end

@implementation BBNearbyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:50];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //self.navigationItem.title = _pageTitle;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [locationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    NSLog(@"%@", currentLocation);
    if (currentLocation != nil) {
        
        [[[CLGeocoder alloc] init] reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count]) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSLog(@"%@", placemark.postalCode);
                postalCode = placemark.postalCode;
                [self handleSelectedItem];

            } else {
                [self handleSelectedItem];
            }
        }];
        
        
    } else {
        [self showLocationFailureAlert];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Fetching location failed %@", error);
    [self showLocationFailureAlert];
}

-(void)handleSelectedItem
{
    if ([_itemName isEqualToString:@"hospital"]) {
        //Fetch the data using google places
        NSString *url =  [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1500&types=%@&key=AIzaSyCnfGlQmhMefserzXx_7Vv4iruP8_cQ0Ok", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, _itemName];
        NSURL *googleRequestURL=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData* data = [NSData dataWithContentsOfURL:googleRequestURL];
        [self performSelectorOnMainThread:@selector(googleResponseCallBack:) withObject:data waitUntilDone:YES];
    } else if ([_itemName isEqualToString:@"Donors"]) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSString *message = [NSString stringWithFormat:@"your pincode will be used to fetch the nesar by donors list %@", postalCode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}

-(void)googleResponseCallBack:(NSData *)responseData
{
    if (!responseData) {
        return;
    }
    
    NSError* error;
    NSDictionary* JSON = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    if (error) {
        NSLog(@"Error fetching data from google %@", error);
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self.navigationController.view makeToast:@"Not able to retrieve data" duration:2.0f position:CSToastPositionBottom];
        return;
    }
    
    itemsList = [JSON objectForKey:@"results"];
    
    if ([itemsList count] == 0) {
        //AMKRIS: handle no result
    }
    
    itemsList = [itemsList sortedArrayUsingComparator:^(NSMutableDictionary *firstItem,NSMutableDictionary *secondItem) {
        NSString *name1 =[firstItem objectForKey:@"name"];
        NSString *name2 =[secondItem objectForKey:@"name"];
        return (NSComparisonResult)[name1 compare:name2 options:NSCaseInsensitiveSearch | NSNumericSearch];
    }];

    [UIView animateWithDuration:1.0f animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return itemsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearByDetailCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nearByDetailCell"];
    }
    // Configure the cell...
    cell.textLabel.text = [[itemsList objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[[itemsList objectAtIndex:indexPath.row] objectForKey:@"rating"] stringValue];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showLocationFailureAlert
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Error in fetching location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setTag:ERROR_FETCHING_LOCATION];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ERROR_FETCHING_LOCATION) {
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
}
@end
