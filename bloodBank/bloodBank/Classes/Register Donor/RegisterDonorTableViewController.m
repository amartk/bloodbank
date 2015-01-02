//
//  RegisterDonorTableViewController.m
//  bloodBank
//
//  Created by amar tk on 06/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "RegisterDonorTableViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BBUtilityManager.h"

#define START_TEXT_FIELD_TAG        100

@interface RegisterDonorTableViewController ()
{
    NSInteger focussedTextFieldTag;
    BOOL isPickerViewShowing;
    NSArray *groupsList;
    NSInteger startTextFieldTag;
}

@end

@implementation RegisterDonorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:gesture];
    groupsList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GroupList" ofType:@"plist"]];
    startTextFieldTag = 100;
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

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 5) {
        if (!isPickerViewShowing) {
            return 0.0f;
        } else {
            return 162.0f;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[cell.subviews objectAtIndex:0] subviews] count] == 2) {
        if ([[[[cell.subviews objectAtIndex:0] subviews] objectAtIndex:1] isKindOfClass:[UITextField class]]) {
            UITextField *textField = [[[cell.subviews objectAtIndex:0] subviews] objectAtIndex:1];
            textField.tag = START_TEXT_FIELD_TAG + indexPath.row;
        }
    }
}

#pragma mark - TextField Delegates -

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 104) {
        isPickerViewShowing = !isPickerViewShowing;
        _bloodGroupPickerView.hidden = !_bloodGroupPickerView.hidden;
        [UIView animateWithDuration:0.1f animations:^{
            focussedTextFieldTag = textField.tag;
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    focussedTextFieldTag = textField.tag;
    
    if (isPickerViewShowing) {
        isPickerViewShowing = !isPickerViewShowing;
        _bloodGroupPickerView.hidden = !_bloodGroupPickerView.hidden;
        [UIView animateWithDuration:0.1f animations:^{
            [self.tableView reloadData];
        } completion:^(BOOL finished) {
            [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] becomeFirstResponder];
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.view viewWithTag:textField.tag + 1]) {
        [[(UITextField *)self.view viewWithTag:textField.tag + 1] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)dismissKeyboard
{
    [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] resignFirstResponder];
    if (isPickerViewShowing) {
        isPickerViewShowing = !isPickerViewShowing;
        _bloodGroupPickerView.hidden = !_bloodGroupPickerView.hidden;
        [self.tableView reloadData];
    }
}

#pragma mark - PickerView Delegates -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [groupsList count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.text = [groupsList objectAtIndex:row];
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField *bloogGroupTextField = (UITextField *)[self.view viewWithTag:focussedTextFieldTag];
    [bloogGroupTextField setText:[groupsList objectAtIndex:row]];
}

#pragma mark - Save Actions -

- (IBAction)saveDonorDetails:(id)sender {
    
    [self dismissKeyboard];
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.navigationController.view makeToast:@"Thanks for registering. We hope the details are correct." duration:3.0f position:CSToastPositionBottom];
        });
        
    }
}

-(BOOL) isValidDetails
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:startTextFieldTag++];
    
    //check for empty name phone or blood group
    if ([[textField text] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Please enter your name" tag:999];
        return FALSE;
    }
    
    textField = (UITextField *)[self.view viewWithTag:startTextFieldTag++];
    
    if ([[textField text] isEqualToString:@""] || [textField.text length] == 0) {
        [self showAlertWithMessage:@"Please enter your phone number" tag:999];
        return FALSE;
    } else {
        NSRange inputRange = NSMakeRange(0, [textField text].length);
        NSError *error;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
        NSArray *matches = [detector matchesInString:[textField text] options:0 range:inputRange];
        if ([matches count] == 0) {
            [self showAlertWithMessage:@"Please enter a valid phone number" tag:999];
            return FALSE;
        }
        
        NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
        if (!([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length)) {
            [self showAlertWithMessage:@"Please enter a valid phone number" tag:999];
            return FALSE;
        }
    }
    
    textField = (UITextField *)[self.view viewWithTag:startTextFieldTag + 2];
    if ([[textField text] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Please select your blood group" tag:999];
        return FALSE;
    }
    
    textField = (UITextField *)[self.view viewWithTag:startTextFieldTag + 5];
    if (![self isValidEmail:textField.text]) {
        [self showAlertWithMessage:@"Please enter a valid email address" tag:999];
        return FALSE;
    }
    return TRUE;
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", laxString];
    return [emailTest evaluateWithObject:checkString];
}

-(void)showAlertWithMessage:(NSString *)message tag:(NSInteger)alertTag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}
@end
