//
//  BBFindDonorViewController.m
//  bloodBank
//
//  Created by amar tk on 10/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "BBFindDonorViewController.h"
#import "MBProgressHUD.h"
#import "FindDonorTableViewCell.h"
#import "UIView+Toast.h"

@interface BBFindDonorViewController () <FindDonorTableViewCellDelegate, UIScrollViewDelegate>
{
    NSInteger focussedTextFieldTag;
    BOOL isPickerViewShowing;
    NSArray *groupsList;
    NSInteger currentMaxDisplayedCell;
    NSInteger currentScrolledCell;
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
-(void)resetViewedCells{
    currentScrolledCell = -999;
    currentMaxDisplayedCell = 0;
}

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
    
    if ([[_bloodGroup text] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select blood group" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [[(UITextField *)self.view viewWithTag:focussedTextFieldTag] resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self resetViewedCells];
        [_donorsListTableView setHidden:NO];
        [_donorsListTableView reloadData];
        
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
    FindDonorTableViewCell *donorTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"FindDonorTableCell"];
    if (!donorTableViewCell) {
        donorTableViewCell = [[FindDonorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FindDonorTableCell"];
    }
    donorTableViewCell.delegate = self;
    donorTableViewCell.donorName.text = @"Amarnath TK";
    donorTableViewCell.donorCity.text = @"Chennai";
    donorTableViewCell.memberSince.text = @"Donor since 12/26/2014";
    return donorTableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > currentMaxDisplayedCell){ //this check makes cells only animate the first time you view them (as you're scrolling down) and stops them re-animating as you scroll back up, or scroll past them for a second time.
        
        //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
        cell.contentView.alpha = 0.3f;
        
        CGAffineTransform transformScale = CGAffineTransformMakeScale(1.15f, 1.15f);
        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        
        cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        
        [_donorsListTableView bringSubviewToFront:cell.contentView];
        [UIView animateWithDuration:0.65f
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.contentView.alpha = 1;
                             //clear the transform
                             cell.contentView.transform = CGAffineTransformIdentity;
                         } completion:nil];
        
        
        currentMaxDisplayedCell = indexPath.row;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    FindDonorTableViewCell *donorCell = (FindDonorTableViewCell *)[_donorsListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:currentScrolledCell inSection:0]];
    [donorCell.myScrollView setContentOffset:CGPointZero animated:YES];
}


#pragma mark - FindDonorTableViewCellDelegate -

-(void)cellDidScroll:(FindDonorTableViewCell *)cell
{
    NSIndexPath *indexPath = [_donorsListTableView indexPathForCell:cell];
    FindDonorTableViewCell *donorCell = (FindDonorTableViewCell *)[_donorsListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:currentScrolledCell inSection:0]];
    if (donorCell) {
        [donorCell.myScrollView setContentOffset:CGPointZero animated:YES];
    }
    
    currentScrolledCell = indexPath.row;
}

-(void)cellDidSelectCall:(FindDonorTableViewCell *)cell
{
    [self.navigationController.view makeToast:@"The call feature is still pending"];
}

-(void)cellDidSelectMessage:(FindDonorTableViewCell *)cell
{
    [self.navigationController.view makeToast:@"The message feature is still pending"];
}

-(void)cellDidSelectMail:(FindDonorTableViewCell *)cell
{
    [self.navigationController.view makeToast:@"The mail feature is still pending"];
}


@end
