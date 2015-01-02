//
//  FindDonorTableViewCell.h
//  scrollViewTest
//
//  Created by amar tk on 22/12/14.
//  Copyright (c) 2014 whizrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindDonorTableViewCell;

@protocol FindDonorTableViewCellDelegate <NSObject>

-(void)cellDidSelectCall:(FindDonorTableViewCell *)cell;
-(void)cellDidSelectMessage:(FindDonorTableViewCell *)cell;
-(void)cellDidSelectMail:(FindDonorTableViewCell *)cell;
-(void)cellDidScroll:(FindDonorTableViewCell *)cell;

@end

@interface FindDonorTableViewCell : UITableViewCell

@property (nonatomic, weak) id<FindDonorTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UILabel *donorName;
@property (weak, nonatomic) IBOutlet UILabel *donorCity;
@property (weak, nonatomic) IBOutlet UILabel *memberSince;
- (IBAction)mailButtonTapped:(id)sender;
- (IBAction)messageButtonTapped:(id)sender;
- (IBAction)callButtonTapped:(id)sender;
@end
