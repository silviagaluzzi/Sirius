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

- (void)refreshCurrentUserData {
    [[SiriusUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
/*
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
        [self downLoadUserPicture:facebookId];
        
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
 */
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
    
    if (user) {
        if ([result objectForKey:@"first_name"] != nil){
            [user setObject:[result objectForKey:@"first_name"] forKey:@"firstName"];

        }
        if ([result objectForKey:@"last_name"] != nil){
            [user setObject:[result objectForKey:@"last_name"] forKey:@"lastName"];
        }
        if ([result objectForKey:@"gender"] != nil){

            [user setObject:[result objectForKey:@"gender"] forKey:@"gender"];
        }
        if ([result objectForKey:@"user_birthday"] != nil){
            
            [user setObject:[result objectForKey:@"user_birthday"] forKey:@"birthDate"];
        }
        if ([result objectForKey:@"email"] != nil){

            [user setObject:[result objectForKey:@"email"] forKey:@"email"];
        }

        [user save];
        
        self.
    }
    
}

@end
