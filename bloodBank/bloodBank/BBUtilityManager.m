//
//  BBUtilityManager.m
//  ZoomRx
//
//  Created by amar tk on 06/02/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "BBUtilityManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define GA_TRACKING_ID @"UA-49046167-5"

@implementation BBUtilityManager

+(id)sharedInstance
{
    static BBUtilityManager *utilityManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utilityManager = [[BBUtilityManager alloc] init];
    });
    
    return utilityManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initializeGoogleAnalytics];
        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        _hudActInd = [[MBProgressHUD alloc] init];
    }
    return self;
}

#pragma mark - App set up -

-(void)initApp
{
    _appStartTime = [NSDate date];
}


-(NSDictionary *)getNetworkStatusMsg
{
    NetworkStatus networkStatus = [_reachability currentReachabilityStatus];
    NSMutableDictionary *messageToJS = [[NSMutableDictionary alloc] init];
    switch (networkStatus) {
        case NotReachable:
            [messageToJS setObject:[NSNumber numberWithBool:TRUE] forKey:@"IS_OFFLINE"];
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            [messageToJS setObject:[NSNumber numberWithBool:FALSE] forKey:@"IS_OFFLINE"];
            break;
        default:
            break;
    }
    
    return messageToJS;
    
}
-(void)showAlert:(NSDictionary *)alertData
{
    _globalAlertView = [[UIAlertView alloc] initWithTitle:[alertData objectForKey:@"TITLE"]
                                                                message:[alertData objectForKey:@"MESSAGE"]
                                                               delegate:[alertData objectForKey:@"DELEGATE"]
                                                      cancelButtonTitle:[alertData objectForKey:@"BUTTON0"]
                                                      otherButtonTitles:[[alertData objectForKey:@"BUTTON1"] isEqualToString:@""]?nil:[alertData objectForKey:@"BUTTON1"], nil];
    
    [_globalAlertView setTag:[[alertData objectForKey:@"ALERT_TAG"] intValue]];
    [_globalAlertView show];
}

-(void)clearCache
{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

-(void)initializeGoogleAnalytics
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    [[GAI sharedInstance] setDryRun:NO];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
}

-(void)handleJSGAData:(NSDictionary *)gaData
{
    NSString *screenName = @"";
    if ([gaData objectForKey:@"SCREEN"] != nil) {
        screenName = [gaData objectForKey:@"SCREEN"];
    }
    
    if ([gaData objectForKey:@"EVENT"] != nil) {
        NSDictionary *eventData = [gaData objectForKey:@"EVENT"];
        [self sendGAButtonPressWithCategory:[eventData objectForKey:@"CATEGORY"] action:[eventData objectForKey:@"ACTION"] label:[eventData objectForKey:@"LABEL"] value:[eventData objectForKey:@"VALUE"] forScreen:screenName];
    } else {
        [self sendGAScreenData:screenName];
    }
}

-(void)sendGAButtonPressWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value forScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
    
    [tracker set:kGAIScreenName value:nil];
}

-(void)sendGAScreenData:(NSString *)screenName
{
    if (!screenName || [screenName isEqualToString:@""]) {
        return;
    }
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)sendGACampaignData:(NSString *)campaignURL
{
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
    [tracker set:kGAIScreenName value:@"Home Screen"];
    
    GAIDictionaryBuilder *hitParams = [[GAIDictionaryBuilder alloc] init];
    [[hitParams setCampaignParametersFromUrl:campaignURL] build];
    [tracker send:[[[GAIDictionaryBuilder createAppView] setAll:[hitParams build]] build]];
    
    [tracker set:kGAIScreenName value:nil];

}

-(void) sendExceptionDataToGA:(NSString *)exceptionData
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder
                        createExceptionWithDescription:exceptionData
                        withFatal:@NO] build]];
}

-(void)setAppBadgeToZero
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        if (([[UIApplication sharedApplication] currentUserNotificationSettings].types & UIUserNotificationTypeBadge) != 0) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        
    } else if ([[UIApplication sharedApplication] respondsToSelector:@selector(enabledRemoteNotificationTypes)]) {
        if (([[UIApplication sharedApplication] enabledRemoteNotificationTypes] & UIRemoteNotificationTypeBadge) != 0) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
}

//-(BOOL)isSplashShown
//{
//    if ([[[[[[UIApplication sharedApplication] delegate].window.rootViewController presentedViewController] class] description] isEqualToString:@"ZrxSplashViewController"]) {
//        return TRUE;
//    }
//
//    return FALSE;
//}
//
//-(void)showOrHideActivityIndicator:(NSDictionary *)indicatorData
//{
//    NSDictionary *pleaseWaitData = [indicatorData objectForKey:@"PLEASE_WAIT"];
//    if ([[pleaseWaitData objectForKey:@"STATUS"] boolValue]) {
//        SWRevealViewController *revealViewController = (SWRevealViewController *)[[(ZrxAppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
//        UINavigationController *navController = (UINavigationController *)revealViewController.frontViewController;
//        [navController.view addSubview:_hudActInd];
//        [self showActivityInd:[pleaseWaitData objectForKey:@"MESSAGE"]];
//        
//    } else {
//        [self hideActivityInd];
//    }
//}
//
//-(void)showActivityIndicator:(NSString *)indicatorMsg
//{
//    SWRevealViewController *revealViewController = (SWRevealViewController *)[[(ZrxAppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
//    UINavigationController *navController = (UINavigationController *)revealViewController.frontViewController;
//    [navController.view addSubview:_hudActInd];
//    [self showActivityInd:indicatorMsg];
//}


-(void)showActivityInd:(NSString *)hudText
{
    if (!hudText) {
        hudText = @"Please wait...";
    }

    _hudActInd.labelText = hudText;
    _hudActInd.square = YES;
    [_hudActInd show:YES];
}

-(void)hideActivityInd
{
    [_hudActInd hide:YES];
}
@end
