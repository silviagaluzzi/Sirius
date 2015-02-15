//
//  SiriusSignUpViewController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface SiriusSignUpViewController : PFSignUpViewController<PFSignUpViewControllerDelegate>

@property (nonatomic,strong) PFTextField *firstName;
@property (nonatomic,strong) PFTextField *lastName;
@property (nonatomic,strong) PFTextField *gender;
@property (nonatomic,strong) PFTextField *birthDate;
@property (nonatomic,strong) PFTextField *pswConfirm;



@end
