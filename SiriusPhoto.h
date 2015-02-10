//
//  SiriusPhoto.h
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <Parse/Parse.h>
#import "SiriusUser.h"
#import "SiriusPet.h"

@interface SiriusPhoto : PFObject <PFSubclassing>

@property (strong) SiriusUser *fromUser;
@property (strong) NSString	  *caption;
@property (strong) SiriusPet   *ofPet;
@property (strong) PFFile	  *image;
@property (strong) PFFile	  *thumbnail;


@end
