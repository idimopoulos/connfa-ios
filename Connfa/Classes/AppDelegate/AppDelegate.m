
#import "AppDelegate.h"
#import "DCMainProxy.h"
#import "UIConstants.h"
#import "DCAlertsManager.h"
#import "GAI.h"
#import "DCLevel+DC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import "NSUserDefaults+DC.h"
#import "DCConstants.h"

@interface AppDelegate ()

@property(strong, nonatomic) id <GAITracker> tracker;

@end

@implementation AppDelegate
- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialise crashlytics
    [[Twitter sharedInstance] startWithConsumerKey:TWITTER_API_KEY consumerSecret:TWITTER_API_SECRET];
    [Fabric with:@[[Crashlytics class], [Twitter class]]];

    [self initializeGoogleAnalytics];
    [self handleUpdateData];

    [[DCMainProxy sharedProxy] update];

#ifdef DEBUG_MODE
    NSLog(@"====================");
    NSLog(@"====DEBUG MODE======");
    NSLog(@"====================");
#endif

    [[UIBarButtonItem appearance]
            setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:kFontOpenSansRegular size:16.0]}
                          forState:UIControlStateNormal];

    return YES;
}

- (void)handleUpdateData {

    // Handle it only when application start
    [[DCMainProxy sharedProxy] setDataUpdatedCallback:^(DCMainProxyState mainProxyState) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeZone *eventTimeZone = [[DCMainProxy sharedProxy]
                    isSystemTimeCoincidencWithEventTimezone];
            if (eventTimeZone && [NSUserDefaults isEnabledTimeZoneAlert]) {
                [DCAlertsManager
                        showTimeZoneAlertForTimeZone:eventTimeZone
                                         withSuccess:^(BOOL isSuccess) {
                                             if (isSuccess) {
                                                 [NSUserDefaults disableTimeZoneNotification];
                                             }
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [[DCMainProxy sharedProxy] setDataUpdatedCallback:nil];
                                             });
                                         }];
            }
        });
    }];
}

- (void)handleUpdateTimeZone {
    // Handle it only when application start
    [[DCMainProxy sharedProxy] setDataUpdatedCallback:^(DCMainProxyState mainProxyState) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeZone *eventTimeZone = [[DCMainProxy sharedProxy]
                    isSystemTimeCoincidencWithEventTimezone];
            if (eventTimeZone && [NSUserDefaults isEnabledTimeZoneAlert] && [DCMainProxy sharedProxy].isTimeZoneChanged == YES) {
                [DCAlertsManager
                        showTimeZoneAlertForTimeZone:eventTimeZone
                                         withSuccess:^(BOOL isSuccess) {
                                             if (isSuccess) {
                                                 [NSUserDefaults disableTimeZoneNotification];
                                             }
                                             [[DCMainProxy sharedProxy] setDataUpdatedCallback:nil];
                                         }];
            }
        });
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    [[DCMainProxy sharedProxy] resetEventTimeZone];
    [[DCMainProxy sharedProxy] setDataUpdatedCallback:nil];
    [DCMainProxy sharedProxy].isTimeZoneChanged = NO;


}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    if (userActivity.webpageURL.description) {
        NSString *codeQuery = userActivity.webpageURL.query;
        NSUInteger firstIndex = [codeQuery rangeOfString:@"="].location + 1;
        NSString *code = [codeQuery substringFromIndex:firstIndex];
        //TODO: - add in NSUserDefaults + DC
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"codeFromLink"];
        //TODO: - add in Constants
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openMyScheduleFromUrl" object:nil];
    }
    return true;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([self.window.rootViewController
            isKindOfClass:[UINavigationController class]]) {
        [self handleUpdateTimeZone];
        [[DCMainProxy sharedProxy] update];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)initializeGoogleAnalytics {
    [[GAI sharedInstance]
            setDispatchInterval:[DCAppConfiguration dispatchInvervalGA]];
    [[GAI sharedInstance] setDryRun:[DCAppConfiguration dryRunGA]];
    self.tracker = [[GAI sharedInstance]
            trackerWithTrackingId:[DCAppConfiguration googleAnalyticsID]];
}

@end
