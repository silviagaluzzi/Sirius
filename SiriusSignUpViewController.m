//
//  SiriusSignUpViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusSignUpViewController.h"
#import "SiriusUser.h"
#import "MainController.h"

@interface SiriusSignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@property (nonatomic, strong) UIImageView *imgViewLogo;


@end


@implementation SiriusSignUpViewController

BOOL *firstviewDidLayoutSubviews;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.signUpView.backgroundColor = [UIColor whiteColor];
    [self.signUpView setLogo:nil];
    self.emailAsUsername = YES;
    firstviewDidLayoutSubviews = YES;
    
}

-(void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    
    CGRect	bFrame;
    bFrame	= self.signUpView.usernameField.frame;
    bFrame.origin.y = 10 + bFrame.size.height + 10;
    
    
    if (!self.firstName) {
        
        self.firstName = [[PFTextField alloc] initWithFrame:bFrame
                                             separatorStyle:PFTextFieldSeparatorStyleBottom];
    }else{
        [self.firstName setFrame:bFrame];
    }
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.firstName.placeholder = NSLocalizedString(@"First Name", @"First Name");
    self.firstName.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:self.firstName];
    [[MainController sharedController].dictFields setObject:self.firstName.text forKey:@"firstName"];
    
    bFrame	= self.firstName.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    
    if (!self.lastName) {
        self.lastName = [[PFTextField alloc] initWithFrame:bFrame
                                            separatorStyle:PFTextFieldSeparatorStyleBottom];
    }else{
        [self.lastName setFrame:bFrame];
    }
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.lastName.placeholder = NSLocalizedString(@"Last Name", @"Last Name");
    self.lastName.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:self.lastName];
    
    bFrame	= self.lastName.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    
    if (!self.birthDate) {
        self.birthDate = [[PFTextField alloc] initWithFrame:bFrame
                                             separatorStyle:PFTextFieldSeparatorStyleBottom];
    }else{
        [self.birthDate setFrame:bFrame];
    }
    self.birthDate.autocorrectionType = UITextAutocorrectionTypeNo;
    self.birthDate.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.birthDate.placeholder = NSLocalizedString(@"Birth Date", @"Birth Date");
    self.birthDate.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:self.birthDate];
    
    bFrame	= self.birthDate.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    
    if (!self.gender) {
        self.gender = [[PFTextField alloc] initWithFrame:bFrame
                                          separatorStyle:PFTextFieldSeparatorStyleBottom];
    }else{
        [self.gender setFrame:bFrame];
    }
    self.gender.autocorrectionType = UITextAutocorrectionTypeNo;
    self.gender.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.gender.placeholder = NSLocalizedString(@"Gender", @"Gender");
    self.gender.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:self.gender];
    
    bFrame	= self.gender.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 1;
    [self.signUpView.usernameField setFrame:bFrame];
    
    bFrame	= self.signUpView.usernameField.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    [self.signUpView.passwordField setFrame:bFrame];
    
    bFrame	= self.signUpView.passwordField.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    
    if (!self.pswConfirm) {
        self.pswConfirm = [[PFTextField alloc] initWithFrame:bFrame
                                              separatorStyle:PFTextFieldSeparatorStyleBottom];
    }else{
        [self.pswConfirm setFrame:bFrame];
        
    }
    
    self.pswConfirm.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pswConfirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pswConfirm.placeholder = NSLocalizedString(@"Confirm Password", @"Confirm Password");
    self.pswConfirm.returnKeyType = UIReturnKeyDone;
    [self.signUpView addSubview:self.pswConfirm];
    
    bFrame	= self.pswConfirm.frame;
    bFrame.origin.y = bFrame.origin.y + bFrame.size.height + 10;
    [self.signUpView.signUpButton setFrame:bFrame];
    
    SiriusUser *user = [SiriusUser currentUser];
    
    if (user) {
        self.firstName.text = user.firstName;
        self.lastName.text = user.lastName;
        //birthDate.text = user.birthDate;
        self.gender.text = user.gender;
        self.signUpView.usernameField.text = user.email;
        self.signUpView.passwordField.text = user.password;
        self.pswConfirm.text = user.pswConfirm;
    }
    
    
    
    
}

@end