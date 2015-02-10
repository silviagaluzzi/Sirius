//
//  SiriusUser.h
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <Parse/Parse.h>

@interface SiriusUser : PFUser
//TODO:chiedere a Luca per user name\image
@property (strong) NSString	*displayName;
@property (strong) PFFile	*profilePictureMedium;
@property (strong) PFFile	*profilePictureSmall;
@property (strong) NSString	*emailVerified;
@property (strong) NSString	*birthCity;
@property (strong) NSString	*birthCountry;
@property (strong) NSDate 	*birthDate;
@property (strong) NSString	*facebookId;
@property (strong) NSString	*firstName;
@property (strong) NSString	*lastName;
@property (strong) NSString	*gender;
@property (strong) NSString	*fullAddress;
@property (strong) NSString	*mobileNumber;
@property (strong) NSString	*residenceCity;
@property (strong) NSString	*residenceCountry;
@property (strong) NSDate 	*createAt;
@property (strong) NSDate 	*updateAt;



@end
