//
//  ParseStarterProjectAppDelegate.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiriusTabBarControllerViewController.h"


@interface SiriusAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (strong, nonatomic) SiriusTabBarControllerViewController *tabController;

@end
