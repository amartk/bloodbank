//
//  EmergencyNumTableViewCell.h
//  bloodBank
//
//  Created by amar tk on 03/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyNumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emergencyItem;
@property (weak, nonatomic) IBOutlet UILabel *emergencyPhone;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@end
