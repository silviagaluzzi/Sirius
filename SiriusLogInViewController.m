//
//  SiriusLogInViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusLogInViewController.h"


@interface SiriusLogInViewController ()
@end


@implementation SiriusLogInViewController

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.logInView.backgroundColor = [UIColor whiteColor];
    [self.logInView setLogo:nil];
    
}

-(void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

    self.logInView.usernameField.placeholder = @"Email";
    

}
@end



