//
//  SiriusPet.h
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <Parse/Parse.h>
#import "SiriusUser.h"

@interface SiriusPet : PFObject <PFSubclassing>

@property (strong) NSString     *name;
@property (strong) NSNumber     *age;
@property (strong) NSString     *gender;
@property (strong) NSString     *breed;
@property (strong) NSString     *distintiveFeatures;
@property (strong) NSString     *type;
@property (strong) SiriusUser   *owner;
@property (strong) PFFile       *picture;

@end
