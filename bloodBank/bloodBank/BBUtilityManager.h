//
//  BBUtilityManager.h
//  ZoomRx
//
//  Created by amar tk on 06/02/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface BBUtilityManager : NSObject

@property(nonatomic, strong) UIAlertView *globalAlertView;
@property(nonatomic, strong) Reachability *reachability;
@property(nonatomic, strong) NSDate *appStartTime;
@property(nonatomic, strong) MBProgressHUD *hudActInd;

+(id) sharedInstance;

-(void)initApp;
-(void)sendGAScreenData:(NSString *)screenName;

@end
