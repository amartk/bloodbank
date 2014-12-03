//
//  RegisterDonorTableViewController.h
//  bloodBank
//
//  Created by amar tk on 06/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterDonorTableViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *bloodGroupPickerView;

- (IBAction)saveDonorDetails:(id)sender;

@end
