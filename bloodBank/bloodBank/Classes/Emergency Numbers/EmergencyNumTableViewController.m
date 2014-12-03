//
//  EmergencyNumTableViewController.m
//  bloodBank
//
//  Created by amar tk on 03/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "EmergencyNumTableViewController.h"
#import "EmergencyNumTableViewCell.h"
#import "UIView+Toast.h"

@interface EmergencyNumTableViewController ()
{
    NSDictionary *emergencyNumberDict;
    NSArray *emergencyItemsList;
}

@end

@implementation EmergencyNumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    emergencyNumberDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmergencyNumbers" ofType:@"plist"]];
    emergencyItemsList = [emergencyNumberDict allKeys];
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
    return [emergencyItemsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmergencyNumTableViewCell *cell = (EmergencyNumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EmergencyTableCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[EmergencyNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmergencyTableCell"];
    }
    
    cell.emergencyItem.text = [emergencyItemsList objectAtIndex:indexPath.row];
    cell.emergencyPhone.text = [emergencyNumberDict objectForKey:cell.emergencyItem.text];
    [cell.callButton addTarget:self action:@selector(callNumber:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    
    return cell;
}


- (IBAction)callNumber:(id)sender forEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath != nil) {     
        EmergencyNumTableViewCell *cell = (EmergencyNumTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"going to call %@ %@", cell.emergencyItem.text, cell.emergencyPhone.text);
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://919566106989"]];
        } else {
            [self.navigationController.view makeToast:@"oops! Your device doesnt support call" duration:2.5f position:CSToastPositionBottom];
        }
    }
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

@end
