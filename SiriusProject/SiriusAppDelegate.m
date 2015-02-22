//
//  ParseStarterProjectAppDelegate.m
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

//#import "SiriusTabBarControllerViewController.h"
#import "SiriusAppDelegate.h"
#import "SiriusViewController.h"
#import "LoginViewController.h"
#import "Utility.h"
#import "SiriusUser.h"
#import "SiriusActivity.h"
#import "SiriusPet.h"
#import "SiriusPhoto.h"
#import "SiriusFeedViewController.h"
#import "SiriusProfileViewController.h"
#import "SiriusActivityViewController.h"
#import "SiriusCameraViewController.h"
#import "MainController.h"

#if APPSTORE
#define GATRACKINGID @"UA-?"
#define PARSE_APPID @"???"
#define PARSE_CLIENTKEY @"???"
#define FACEBOOKAPPID @"?"

#else
#define GATRACKINGID @"UA-?"
#define PARSE_APPID @"6j4TVHMyxhn0wnaBgZBQ5zIoUJxgsNXQ36SZwnCV"
#define PARSE_CLIENTKEY @"nLoMY6qrLWQGfWEz2RvWdUijPkdSBAxc34dtL1JF"
#define FACEBOOKAPPID @"752882844807738"

#endif

@implementation SiriusAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MainController sharedController].dictFields = nil;
    [MainController sharedController].dictFields = [[NSMutableDictionary alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];

    // ****************************************************************************
    // Uncomment this line if you want to enable Crash Reporting
    [ParseCrashReporting enable];
    //
    
    // PARSE register
    [SiriusUser registerSubclass];
    [SiriusActivity registerSubclass];
    [SiriusPet registerSubclass];
    [SiriusPhoto registerSubclass];
    
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:PARSE_APPID clientKey:PARSE_CLIENTKEY];
    [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Installation saved succesfully");
        } else {
            NSLog(@"Sorry something went wrong saving installation");
        }
    }];

    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    [PFFacebookUtils initializeFacebook];
    // ****************************************************************************

    //[PFUser enableAutomaticUser];

    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];

    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced in iOS 7).
        // In that case, we skip tracking here to avoid double counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else
#endif
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    [self userInterfaceSetup];
//    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

#pragma mark Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];

    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];

    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

///////////////////////////////////////////////////////////
// Uncomment this method if you want to use Push Notifications with Background App Refresh
///////////////////////////////////////////////////////////
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    if (application.applicationState == UIApplicationStateInactive) {
//        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
//    }
//}

#pragma mark Facebook SDK Integration

///////////////////////////////////////////////////////////
// Uncomment this method if you are using Facebook
///////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


#pragma mark App Setup
- (void)userInterfaceSetup {
    
    //TODO: Google Analytics
    /*        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GATRACKINGID];
     #if DEBUG
     NSLog(@"Google Analytics ID: %@", GATRACKINGID);
     [[GAI sharedInstance] setDispatchInterval:1];
     #endif
     */
    
    
    //TODO: FB
    [FBSettings setDefaultAppID:FACEBOOKAPPID];
    [FBAppEvents activateApp];
    
    
    self.tabController = [[SiriusTabBarControllerViewController alloc] init];
    self.window.rootViewController = self.tabController;
    
    //Feed
    SiriusFeedViewController* home = [[SiriusFeedViewController alloc] initWithNibName:@"SiriusFeedViewController" bundle:nil];
    UINavigationController* navFeed = [[UINavigationController alloc] initWithRootViewController:home];
    
    //Profile
    SiriusProfileViewController* profile = [[SiriusProfileViewController alloc] initWithNibName:@"SiriusProfileViewController" bundle:nil]; //qui metti user
    UINavigationController* navProfile = [[UINavigationController alloc] initWithRootViewController:profile];
    
    //Activity
    SiriusActivityViewController* act = [[SiriusActivityViewController alloc] initWithNibName:@"SiriusActivityViewController" bundle:nil];
    UINavigationController* navAct = [[UINavigationController alloc] initWithRootViewController:act];
    
    //camera
    SiriusCameraViewController* cam = [[SiriusCameraViewController alloc] initWithNibName:@"SiriusCameraViewController" bundle:nil];
    UINavigationController* navCam = [[UINavigationController alloc] initWithRootViewController:cam];
    
    
    [self.tabController setViewControllers:@[navFeed, navCam, navAct, navProfile]];
    [self.tabController addCenterButtonWithImage:[UIImage imageNamed:@"tab_icon_camera_off"] highlightImage:nil];
    
    /*TODO:UI APPEARANCE*/
    
    /*[ [UITabBarItem appearance] setTitleTextAttributes:@{
     UITextAttributeTextColor: COLORS_TITLE_TEXT,
     UITextAttributeTextShadowColor: [UIColor clearColor],
     UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
     UITextAttributeFont: [UIFont fontWithName:@"TrajanPro-Regular" size:8]}
     
     forState: UIControlStateNormal];
     
     [ [UITabBarItem appearance] setTitleTextAttributes:@{
     UITextAttributeTextColor: COLORS_TEXT_TABBAR_SELECTED,
     UITextAttributeTextShadowColor: [UIColor clearColor],
     UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
     UITextAttributeFont: [UIFont fontWithName:@"TrajanPro-Regular" size:8]}
     
     forState: UIControlStateSelected];
     */
    
    //Tabs
    UIEdgeInsets tabInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //[navFeed.tabBarItem setFinishedSelectedImage:[[UIImage imageNamed:@"tab_icon_home_on"]
    //                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    //             withFinishedUnselectedImage:[[UIImage imageNamed:@"tab_icon_home_off"]
    //                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    navFeed.tabBarItem.title = @"FEED";
    navFeed.tabBarItem.imageInsets = tabInsets;
    
    //        [navFeed.tabBarItem setFinishedSelectedImage:nil
    //                      withFinishedUnselectedImage:nil];
    navCam.tabBarItem.title = @"CAMERA";
    navCam.tabBarItem.imageInsets = tabInsets;
    
    //       [navAct.tabBarItem setFinishedSelectedImage:[[UIImage imageNamed:@"tab_icon_activity_on"]
    //                                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    //             withFinishedUnselectedImage:[[UIImage imageNamed:@"tab_icon_activity_off"]
    //                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    navAct.tabBarItem.title = @"ACTIVITY";
    navAct.tabBarItem.imageInsets = tabInsets;
    
    
    //     [navProfile.tabBarItem setFinishedSelectedImage:[[UIImage imageNamed:@"tab_icon_profile_on"]
    //                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    //                   withFinishedUnselectedImage:[[UIImage imageNamed:@"tab_icon_profile_off"]
    //                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    navProfile.tabBarItem.title = @"PROFILE";
    navProfile.tabBarItem.imageInsets = tabInsets;
    
    
    //TAB BAR
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bar_back"]];
    
    
    OSCHECK_IF_IOS7_OR_GREATER(
                               [self.tabController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"background_selected_tab"]];
                               )
    OSCHECK_IF_PRE_IOS7(
                        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"background_selected_tab"]];
                        )
    
    //NAVIGATION BAR
    
    //        OSCHECK_IF_IOS7_OR_GREATER(
    //                                 [[UINavigationBar appearance] setTintColor:COLORS_NAV_TEXT];
    //[[UINavigationBar appearance] setBarTintColor:COLORS_NAV_BAR];
    //                               )
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"background_tile_actionbar"] forBarMetrics:UIBarMetricsDefault];
    
    //    [[UINavigationBar appearance] setTitleTextAttributes: @{
    //                                                          UITextAttributeTextColor:COLORS_NAV_TEXT,
    //                                                        UITextAttributeTextShadowColor:[UIColor clearColor],
    //                                                      UITextAttributeFont:[UIFont fontWithName:@"TrajanPro-Regular" size:17]
    //                                                    }];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navbar-shadow.png"] ];
    
    //[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor: COLORS_HOME_TEXTHIGH];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 10) forBarMetrics:UIBarMetricsDefault];
    
    [self.window makeKeyAndVisible];
    
    //}
    
}

@end
