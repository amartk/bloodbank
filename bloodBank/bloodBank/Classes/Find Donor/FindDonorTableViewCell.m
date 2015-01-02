//
//  FindDonorTableViewCell.m
//  scrollViewTest
//
//  Created by amar tk on 22/12/14.
//  Copyright (c) 2014 whizrx. All rights reserved.
//

#import "FindDonorTableViewCell.h"
#define kCatchWidth 180

@interface FindDonorTableViewCell () <UIScrollViewDelegate>

@end

@implementation FindDonorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_myScrollView setContentSize:CGSizeMake(660, 60)];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.delegate cellDidScroll:self];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if (scrollView.contentOffset.x > kCatchWidth - 50) {
        targetContentOffset->x = kCatchWidth;
    } else {
        *targetContentOffset = CGPointZero;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myScrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}


- (IBAction)mailButtonTapped:(id)sender {
    [self.delegate cellDidSelectMail:self];
}

- (IBAction)messageButtonTapped:(id)sender {
        [self.delegate cellDidSelectMessage:self];
}

- (IBAction)callButtonTapped:(id)sender {
        [self.delegate cellDidSelectCall:self];
}
@end
