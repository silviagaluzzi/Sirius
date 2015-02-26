//
//  MainController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiriusUser.h"

@interface MainController : NSObject

+ (MainController *)sharedController;

@property (nonatomic, readonly) int networkStatus;
@property (nonatomic, strong) NSMutableDictionary* dictFields;

//- (void)monitorReachability;
//- (BOOL)isNetworkReachable;
- (void)postNotificationWithName:(NSString*)notificationName;

//- (void)updateUserForPushNotifications: (SiriusUser *)aUser;
//- (void)subscribeUserToPushNotifications:(NSString *) channelName;
//- (void)unsubscribeUserFromPushNotifications:(NSString *) channelName;

- (void)sendPushNotificationOfType: (NSString *)aType toUser: (SiriusUser *)aUser;

//- (void)logOut;
- (BOOL)isValidUser:(SiriusUser *)user;
- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;
- (void)refreshCurrentUserData;
//- (void)loadAttributesForPhoto:(PFObject*)photo;

- (void) signUpFields:(NSMutableArray*) arrayFields;

-(BOOL)isFieldEmpty:(UITextField *)field;


@end
