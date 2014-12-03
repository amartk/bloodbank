//
//  BBFindDonorViewController.m
//  bloodBank
//
//  Created by amar tk on 10/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "BBFindDonorViewController.h"
#import "MBProgressHUD.h"

@interface BBFindDonorViewController ()
{
    NSInteger focussedTextFieldTag;
    BOOL isPickerViewShowing;
    NSArray *groupsList;
}

@end

@implementation BBFindDonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    groupsList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GroupList" ofType:@"plist"]];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchDonorButton setEnabled:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField.tag == 100) {
        if ([[(UITextField *)self.view viewWithTag:focussedTextFieldTag] isFirstResponder]) {
            
            [UIView animateWithDuration:0.5f animations:^{
                isPickerViewShowing = TRUE;
                [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] resignFirstResponder];
                
            } completion:^(BOOL finished) {
                focussedTextFieldTag = textField.tag;
                [_bloodGroupPickerView setHidden:NO];
                [_bloodGroupPickerView setAlpha:1.0];
                
                CGRect cityPincodeViewRect = [_cityPincodeView frame];
                cityPincodeViewRect.origin.y = _bloodGroupPickerView.frame.origin.y + _bloodGroupPickerView.frame.size.height;
                [_cityPincodeView setFrame:cityPincodeViewRect];
                
                CGRect donorsTableView = [_donorsListTableView frame];
                donorsTableView.origin.y = _cityPincodeView.frame.origin.y + _cityPincodeView.frame.size.height + 25;
                [_donorsListTableView setFrame:donorsTableView];

            }];
            
        } else {
            
            focussedTextFieldTag = textField.tag;
            
            [UIView animateWithDuration:0.5f animations:^{
                isPickerViewShowing = TRUE;
                CGRect cityPincodeViewRect = [_cityPincodeView frame];
                cityPincodeViewRect.origin.y = _bloodGroupPickerView.frame.origin.y + _bloodGroupPickerView.frame.size.height;
                [_cityPincodeView setFrame:cityPincodeViewRect];
                
                CGRect donorsTableView = [_donorsListTableView frame];
                donorsTableView.origin.y = _cityPincodeView.frame.origin.y + _cityPincodeView.frame.size.height + 25;
                [_donorsListTableView setFrame:donorsTableView];
                
            } completion:^(BOOL finished) {
                [_bloodGroupPickerView setHidden:NO];
                [_bloodGroupPickerView setAlpha:1.0];
            }];
        }
        
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    focussedTextFieldTag = textField.tag;
    if (isPickerViewShowing) {
        [UIView animateWithDuration:0.5f animations:^{
            
            [_bloodGroupPickerView setHidden:YES];
            [_bloodGroupPickerView setAlpha:0.2];
            
            CGRect cityPincodeViewRect = [_cityPincodeView frame];
            cityPincodeViewRect.origin.y = _bloodGroup.frame.origin.y + _bloodGroup.frame.size.height;
            [_cityPincodeView setFrame:cityPincodeViewRect];
            
            CGRect donorsTableView = [_donorsListTableView frame];
            donorsTableView.origin.y = _cityPincodeView.frame.origin.y + _cityPincodeView.frame.size.height + 25;
            [_donorsListTableView setFrame:donorsTableView];
            
        } completion:^(BOOL finished) {
            isPickerViewShowing = FALSE;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    label.text = [groupsList objectAtIndex:row];
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:0.5f animations:^{

        [_bloodGroupPickerView setHidden:YES];
        [_bloodGroupPickerView setAlpha:0.2];
        UITextField *bloogGroupTextField = (UITextField *)[self.view viewWithTag:focussedTextFieldTag];
        [bloogGroupTextField setText:[groupsList objectAtIndex:row]];

        CGRect cityPincodeViewRect = [_cityPincodeView frame];
        cityPincodeViewRect.origin.y = _bloodGroup.frame.origin.y + _bloodGroup.frame.size.height;
        [_cityPincodeView setFrame:cityPincodeViewRect];
        
        CGRect donorsTableView = [_donorsListTableView frame];
        donorsTableView.origin.y = _cityPincodeView.frame.origin.y + _cityPincodeView.frame.size.height + 25;
        [_donorsListTableView setFrame:donorsTableView];
        
    } completion:^(BOOL finished) {
        isPickerViewShowing = FALSE;
        [_searchDonorButton setEnabled:YES];
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] resignFirstResponder];
}

#pragma mark - IBAction -

- (IBAction)searchDonors:(id)sender {
    
    [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [_donorsListTableView setHidden:NO];
        
    });
}

#pragma mark - TableView delegates -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindDonorTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FindDonorTableCell"];
    }
    
    cell.textLabel.text = @"donorName";
    cell.detailTextLabel.text = @"Donor City";
    return cell;
}

@end
