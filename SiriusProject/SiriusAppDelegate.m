//
//  ParseStarterProjectAppDelegate.m
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

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
#import "Colors.h"

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
    
//    [MainController sharedController].dictFields = nil;
//    [MainController sharedController].dictFields = [[NSMutableDictionary alloc] init];
    [MainController sharedController].userDataFromFB = nil;
    [MainController sharedController].userDataFromFB = [[NSMutableDictionary alloc] init];
    
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
    
    
    [FBSettings setDefaultAppID:FACEBOOKAPPID];
    [FBAppEvents activateApp];
    
    
    self.tabController = [[SiriusTabBarControllerViewController alloc] init];
    self.window.rootViewController = self.tabController;
    
    //Feed
    SiriusFeedViewController* home = [[SiriusFeedViewController alloc] initWithNibName:@"SiriusFeedViewController" bundle:nil];
    UINavigationController* navFeed = [[UINavigationController alloc] initWithRootViewController:home];

    //Activity
    SiriusActivityViewController* act = [[SiriusActivityViewController alloc] initWithNibName:@"SiriusActivityViewController" bundle:nil];
    UINavigationController* navAct = [[UINavigationController alloc] initWithRootViewController:act];

    //From World
    SiriusActivityViewController* fromWorld = [[SiriusActivityViewController alloc] initWithNibName:@"SiriusActivityViewController" bundle:nil];
    UINavigationController* navFromWorld = [[UINavigationController alloc] initWithRootViewController:fromWorld];
    
    //Profile
    SiriusProfileViewController* profile = [[SiriusProfileViewController alloc] initWithNibName:@"SiriusProfileViewController" bundle:nil]; //qui metti user
    UINavigationController* navProfile = [[UINavigationController alloc] initWithRootViewController:profile];
    
    //Search
    SiriusActivityViewController* search = [[SiriusActivityViewController alloc] initWithNibName:@"SiriusActivityViewController" bundle:nil];
    UINavigationController* navSearch = [[UINavigationController alloc] initWithRootViewController:search];

    
    //camera
/*    SiriusCameraViewController* cam = [[SiriusCameraViewController alloc] initWithNibName:@"SiriusCameraViewController" bundle:nil];
    UINavigationController* navCam = [[UINavigationController alloc] initWithRootViewController:cam];
  */
    
    [self.tabController setViewControllers:@[navFeed, navAct, navFromWorld, navProfile, navSearch]];
    //[self.tabController addCenterButtonWithImage:[UIImage imageNamed:@"tab_icon_camera_off"] highlightImage:nil];
    
    
    //Tabs
    UIEdgeInsets tabInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    CGSize newSize = CGSizeMake(20, 20);
    
    //1.tab Feed
    UIImage* imageFeedOn = [UIImage imageNamed:@"ic_tab_feed_on"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageFeedOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageFeedOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageFeedOff = [UIImage imageNamed:@"ic_tab_feed_off"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageFeedOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageFeedOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiFeed = [navFeed.tabBarItem initWithTitle:@"FEED" image:newImageFeedOn selectedImage:newImageFeedOff];
    [navFeed setTabBarItem:tbiFeed];
    navFeed.tabBarItem.imageInsets = tabInsets;
    
    //2.tab Activity
    UIImage* imageActivityOn = [UIImage imageNamed:@"ic_tab_activity_on"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageActivityOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageActivityOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageActivityOff = [UIImage imageNamed:@"ic_tab_activity_off"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageActivityOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageActivityOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiActivity = [navAct.tabBarItem initWithTitle:@"ACTIVITY" image:newImageActivityOn selectedImage:newImageActivityOff];
    [navAct setTabBarItem:tbiActivity];
    navAct.tabBarItem.imageInsets = tabInsets;
    
    //3.tab from world
    UIImage* imageFromWorldOn = [UIImage imageNamed:@"ic_tab_home_on"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageFromWorldOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageFromWorldOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageFromWorldOff = [UIImage imageNamed:@"ic_tab_home_off"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageFromWorldOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageFromWorldOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiFromWorld = [navFromWorld.tabBarItem initWithTitle:@"WORLD" image:newImageFromWorldOn selectedImage:newImageFromWorldOff];
    [navFromWorld setTabBarItem:tbiFromWorld];
    navFromWorld.tabBarItem.imageInsets = tabInsets;
    
    
    
    //tab Camera (da spostare in navigation bar)
    /*UIImage* imageCameraOn = [UIImage imageNamed:@"ic_btn_photo"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageCameraOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageCameraOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageCameraOff = [UIImage imageNamed:@"ic_btn_photo"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageCameraOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImagecameraOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiCamera = [navCam.tabBarItem initWithTitle:@"CAMERA" image:newImageCameraOn selectedImage:newImagecameraOff];
    [navCam setTabBarItem:tbiCamera];
    navCam.tabBarItem.imageInsets = tabInsets;
    */
     
    
    
    //4.tab Profile
    UIImage* imageProfileOn = [UIImage imageNamed:@"ic_tab_profile_on"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageProfileOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageProfileOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageProfileOff = [UIImage imageNamed:@"ic_tab_profile_off"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageProfileOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageProfileOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiProfile = [navProfile.tabBarItem initWithTitle:@"PROFILE" image:newImageProfileOn selectedImage:newImageProfileOff];
    [navProfile setTabBarItem:tbiProfile];
    navProfile.tabBarItem.imageInsets = tabInsets;

    //5.tab search
    UIImage* imageSearchOn = [UIImage imageNamed:@"ic_tab_settings_on"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageSearchOn drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageSearchOn = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* imageSearchOff = [UIImage imageNamed:@"ic_tab_settings_off"];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageSearchOff drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImageSearchOff = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *tbiSearch = [navSearch.tabBarItem initWithTitle:@"SEARCH" image:newImageSearchOn selectedImage:newImageSearchOff];
    [navSearch setTabBarItem:tbiSearch];
    navSearch.tabBarItem.imageInsets = tabInsets;

    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 10)
                                               forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBarTintColor:COLORS_TABBAR_BACK];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    self.tabController.navigationController.navigationItem.rightBarButtonItem = rightButton;
    
    //UI Appearance
    NSShadow *clearShadow = [[NSShadow alloc] init];
    clearShadow.shadowColor = [UIColor clearColor];
    clearShadow.shadowOffset = CGSizeMake(0, 0);
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSShadowAttributeName : clearShadow,
       NSForegroundColorAttributeName : [UIColor blackColor]
       }
     ];
    [[UINavigationBar appearance] setBarTintColor:COLORS_NAV_BAR];
    
    
    [self.window makeKeyAndVisible];
    
    
}

@end
