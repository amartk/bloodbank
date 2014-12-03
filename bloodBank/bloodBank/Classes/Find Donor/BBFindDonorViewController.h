//
//  BBFindDonorViewController.h
//  bloodBank
//
//  Created by amar tk on 10/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBFindDonorViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bloodGroup;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *pincode;
@property (weak, nonatomic) IBOutlet UIView *cityPincodeView;
@property (weak, nonatomic) IBOutlet UIPickerView *bloodGroupPickerView;
@property (weak, nonatomic) IBOutlet UIButton *searchDonorButton;

@property (weak, nonatomic) IBOutlet UITableView *donorsListTableView;
- (IBAction)searchDonors:(id)sender;
@end
