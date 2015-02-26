//
//  SiriusTabBarControllerViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 09/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusTabBarControllerViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "PAPConstants.h"
#import "SiriusUser.h"
#import "SiriusLogInViewController.h"
#import "SiriusSignUpViewController.h"
#import "Notifications.h"
#import "MainController.h"
#import "SiriusCameraNavController.h"
#import "DLCImagePickerController.h"
#import "SVProgressHUD.h"



@interface SiriusTabBarControllerViewController ()

- (void)loggedInAsUser:(SiriusUser *)user;

@end

@implementation SiriusTabBarControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    /*    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(showLogin:)
     name:NOTIFICATIONS_AUTH_SHOWLOGIN
     object:nil];
     }
     */
    return self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![SiriusUser currentUser]) {
        [self showLogin:self];
    } else {
        [[MainController sharedController] refreshCurrentUserData];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showLogin:(id)sender
{
    SiriusSignUpViewController	*signUpViewController	= [[SiriusSignUpViewController alloc] init];
    SiriusLogInViewController	*loginViewController = [[SiriusLogInViewController alloc] init];
    
    signUpViewController.fields	= PFSignUpFieldsDefault;
    signUpViewController.delegate = self;
    
    loginViewController.delegate = self;
    
    loginViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = @[ @"user_about_me" ];
    loginViewController.signUpController	= signUpViewController;
    
    loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0,
                              0.0,
                              self.view.frame.size.width / [self.viewControllers count],
                              self.tabBar.frame.size.height
                              );
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    [button setContentMode:UIViewContentModeCenter];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:self action:@selector(newPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)newPhoto:(UIButton*)sender {
    
    DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
    SiriusCameraNavController* navController = [[SiriusCameraNavController alloc] initWithRootViewController:picker];
    picker.delegate = navController;
    
    [navController setNavigationBarHidden:YES];
    
    [self presentViewController:navController animated:YES completion:nil];
    

    
}

- (void)loggedInAsUser:(SiriusUser *)user {
    
    //if (![[MainController sharedController] isValidUser:user] && [PFFacebookUtils isLinkedWithUser: user]) {
        
        //TODO: progress hud
        //        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [[MainController sharedController] facebookRequestDidLoad:result];
                [self dismissViewControllerAnimated:YES completion:nil];

            } else {
                [[MainController sharedController] facebookRequestDidFailWithError:error];
            }
            
            //  [SVProgressHUD dismiss];
        }];
    
//    } else {
        
  //      if (!user.displayName) {
    //        user.displayName	= [user username];
      //      [user saveEventually];
        //}
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    //}
 
 
    //TODO:PUSH NOTIFICATIONS
    //    [[MainController sharedController] updateUserForPushNotifications: user];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.selectedIndex	= 0;
    
    [[MainController sharedController] postNotificationWithName:NOTIFICATIONS_HOME_RELOAD];
    //}
    
}


#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:
(SiriusUser *)user {
    
    [self loggedInAsUser:user];
    
}

#pragma mark - PFSignUpViewControllerDelegate
- (BOOL)signUpViewController:(SiriusSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    
    
    if ([[MainController sharedController] isFieldEmpty: signUpController.firstName]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SIGN_UP_ERROR", nil) message:NSLocalizedString(@"FIRST_NAME_EMPTY", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

        return NO;
    }
    if ([[MainController sharedController] isFieldEmpty: signUpController.lastName]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SIGN_UP_ERROR", nil) message:NSLocalizedString(@"LAST_NAME_EMPTY", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

        return NO;
    }
    if ([[MainController sharedController] isFieldEmpty: signUpController.birthDate]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SIGN_UP_ERROR", nil) message:NSLocalizedString(@"BIRTH_DATE_EMPTY", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

        return NO;
    }
    if ([[MainController sharedController] isFieldEmpty: signUpController.gender]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SIGN_UP_ERROR", nil) message:NSLocalizedString(@"GENDER_EMPTY", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
        return NO;
    }
    if ([[MainController sharedController] isFieldEmpty: signUpController.pswConfirm]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SIGN_UP_ERROR", nil) message:NSLocalizedString(@"PSW_CONFIRM_EMPTY", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];

        return NO;
    }

    return YES;
    
}

- (void) signUpViewController:(SiriusSignUpViewController *)signUpController didSignUpUser:(SiriusUser *)user {
    
    
    //Sirius additional sigup fields
    NSString* firstName = signUpController.firstName.text;
    NSString* lastName = signUpController.lastName.text;
    //NSString *birthDate =
    NSString* gender = signUpController.gender.text;
    //NSString* email = signUpController.signUpView.usernameField.text;
    NSString* pswConfirm = signUpController.pswConfirm.text;

    
    NSString	*strPrefs	= [NSString stringWithFormat:@"%@ %@ %@ %@ %@", kNewsPushNotification, kPAPActivityTypeFollow, kPAPActivityTypeJoined,  kPAPActivityTypeLike, kPAPActivityTypeComment];
    
    //we have to save all fields for the new user (all fields are required?)
    [user setObject:strPrefs forKey:@"channels"];
    [user setObject:firstName forKey:@"firstName"];
    [user setObject:lastName forKey:@"lastName"];
    [user setObject:gender forKey:@"gender"];
//    [user setObject:birthDate forKey:@"birthDate"];
    //[user setObject:email forKey:@"email"];
    
    [user save];
    
    [self loggedInAsUser:user];
    
    [signUpController dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}



@end
