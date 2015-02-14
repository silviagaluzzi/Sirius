//
//  SiriusSignUpViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusSignUpViewController.h"

@interface SiriusSignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@property (nonatomic, strong) UIImageView *imgViewLogo;

@end


@implementation SiriusSignUpViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.signUpView.backgroundColor = [UIColor whiteColor];
    [self.signUpView setLogo:nil];
}

-(void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

    CGRect	bFrame;
    bFrame	= self.signUpView.usernameField.frame;
    bFrame.origin.y = 10 + bFrame.size.height + 10;
    
    
    
    PFTextField *firstName = [[PFTextField alloc] initWithFrame:bFrame
                                                       separatorStyle:PFTextFieldSeparatorStyleBottom];
    firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    firstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    firstName.placeholder = NSLocalizedString(@"First Name", @"First Name");
    firstName.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:firstName];

    bFrame	= firstName.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    PFTextField *lastName = [[PFTextField alloc] initWithFrame:bFrame
                                                 separatorStyle:PFTextFieldSeparatorStyleBottom];
    lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    lastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    lastName.placeholder = NSLocalizedString(@"Last Name", @"Last Name");
    lastName.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:lastName];

    bFrame	= lastName.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    PFTextField *birthDate = [[PFTextField alloc] initWithFrame:bFrame
                                                separatorStyle:PFTextFieldSeparatorStyleBottom];
    birthDate.autocorrectionType = UITextAutocorrectionTypeNo;
    birthDate.autocapitalizationType = UITextAutocapitalizationTypeNone;
    birthDate.placeholder = NSLocalizedString(@"Birth Date", @"Birth Date");
    birthDate.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:birthDate];

    bFrame	= birthDate.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    PFTextField *gender = [[PFTextField alloc] initWithFrame:bFrame
                                                 separatorStyle:PFTextFieldSeparatorStyleBottom];
    gender.autocorrectionType = UITextAutocorrectionTypeNo;
    gender.autocapitalizationType = UITextAutocapitalizationTypeNone;
    gender.placeholder = NSLocalizedString(@"Gender", @"Gender");
    gender.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:gender];

    bFrame	= gender.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    
    //email field not visible
    [self.signUpView.emailField setFrame:CGRectNull];
    
    [self.signUpView.usernameField setFrame:bFrame];
    self.signUpView.usernameField.placeholder = NSLocalizedString(@"Email", @"Email");
    
    bFrame	= self.signUpView.usernameField.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    [self.signUpView.passwordField setFrame:bFrame];

    bFrame	= self.signUpView.passwordField.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;

    PFTextField *confirmPsw = [[PFTextField alloc] initWithFrame:bFrame
                                                 separatorStyle:PFTextFieldSeparatorStyleBottom];
    confirmPsw.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPsw.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmPsw.placeholder = NSLocalizedString(@"Confirm Password", @"Confirm Password");
    confirmPsw.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:confirmPsw];

    bFrame	= confirmPsw.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    [self.signUpView.signUpButton setFrame:bFrame];

    
}


@end