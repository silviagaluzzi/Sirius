//
//  MainController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "MainController.h"
#import "PAPUtility.h"
#import "PAPCache.h"
#import "PAPConstants.h"
#import "SiriusSignUpViewController.h"
#import "Notifications.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>


@implementation MainController

+ (MainController *)sharedController {
    static MainController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[MainController alloc] init];
    });
    
    return sharedController;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] postNotification:aNotification];
}

- (void)postNotificationWithName:(NSString*)notificationName {
    
    [self performSelectorOnMainThread:@selector(postNotification:)
                           withObject: [NSNotification notificationWithName:notificationName
                                                                     object:nil
                                                                   userInfo:nil]
                        waitUntilDone:NO];
    
}

- (void)logOut {
    
    
    // clear cache
    [[PAPCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    
    // Clear Push Notifications channel
    PFInstallation	*installation	= [PFInstallation currentInstallation];
    NSString		*channelName	= [NSString stringWithFormat: @"user%@", [[SiriusUser currentUser] objectId]];
    
    [PFPush unsubscribeFromChannelInBackground: @""];
    if (installation.channels.count) {
        [PFPush unsubscribeFromChannelInBackground: channelName
                                             block: ^(BOOL succeeded, NSError *error) {
                                                 // We don't care about errors here, log out anyway
                                                 [SiriusUser logOut];
                                                 
                                                 //TODO: qui mosta login
                                                 //[self postNotificationWithName:NOTIFICATIONS_AUTH_SHOWLOGIN];
                                             }];
    } else {
        
        [SiriusUser logOut];
        [self postNotificationWithName:NOTIFICATIONS_AUTH_SHOWLOGIN];
        
    }
    
    
}

- (void)refreshCurrentUserData {
    [[SiriusUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {

    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [self logOut];
        return;
    }
    
    // Check if user is missing a Facebook ID
    if ([PAPUtility userHasValidFacebookData:[SiriusUser currentUser]]) {
        // User has Facebook ID.
        // refresh profile image
        NSString *facebookId = [SiriusUser currentUser].facebookId;
        //[self downLoadUserPicture:facebookId];
        
        // refresh Facebook friends on each launch
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    } else if ([PFFacebookUtils isLinkedWithUser: [SiriusUser currentUser]]) {
        NSLog(@"Current user is missing their Facebook ID");
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
 
}

- (BOOL)isValidUser:(SiriusUser *)user {
    if ([PAPUtility userHasValidFacebookData:[SiriusUser currentUser]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)facebookRequestDidLoad:(id)result {
    
    SiriusUser *user = [SiriusUser currentUser];
    NSMutableDictionary  *fbUserData = [[NSMutableDictionary alloc] init];

    if (user) {
        NSString* firstName = @"";
        if ([result objectForKey:@"first_name"] != nil){
            firstName = [result objectForKey:@"first_name"];
            [user setObject:firstName forKey:@"firstName"];
            [fbUserData setObject:firstName forKey:@"firstName"];
        }
        NSString* lastName = @"";
        if ([result objectForKey:@"last_name"] != nil){
            lastName = [result objectForKey:@"last_name"];
            [user setObject:lastName forKey:@"lastName"];
            [fbUserData setObject:lastName forKey:@"lastName"];
        }
        NSString* gender = @"";
        if ([result objectForKey:@"gender"] != nil){
            gender = [result objectForKey:@"gender"];
            [user setObject:gender forKey:@"gender"];
            [fbUserData setObject:gender forKey:@"gender"];
        }
        
        NSString* userBirthday = @"";
        if ([result objectForKey:@"birthday"] != nil){
            userBirthday = [result objectForKey:@"birthday"];
            [user setObject:userBirthday forKey:@"userBirthday"];
            [fbUserData setObject:userBirthday forKey:@"userBirthday"];
        }
    
        NSString* email = @"";
        if ([result objectForKey:@"email"] != nil){
            email = [result objectForKey:@"email"];
            [user setObject:email forKey:@"email"];
            [fbUserData setObject:email forKey:@"email"];
        }
        
        NSString* facebookID = @"";
        if ([result objectForKey:@"id"] != nil){
            facebookID = [result objectForKey:@"id"];
            [user setObject:facebookID forKey:@"facebookId"];
            [fbUserData setObject:facebookID forKey:@"facebookId"];
        }
        
        self.userDataFromFB = fbUserData;

        [user save];
        
        //in accordo con Luca facciamo che l'utente che fa login con FB non è obbligato ad inserire dati aggiuntivi
        //[self postNotificationWithName:NOTIFICATIONS_AUTH_SHOWSIGUP];
        
    }
    
}

#pragma mark Login
-(BOOL)isFieldEmpty:(UITextField *)field
{
    if (field.text == nil || [[field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}



@end
