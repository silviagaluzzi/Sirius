//
//  SiriusActivity.h
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <Parse/Parse.h>
#import "SiriusUser.h"
#import "SiriusPhoto.h"

@interface SiriusActivity : PFObject<PFSubclassing>

@property (strong) NSString*    type;
@property (strong) SiriusUser*  fromUser;
@property (strong) SiriusUser*  toUser;
@property (strong) NSString*    message;
@property (strong) SiriusPhoto* photo;


@end
