//
//  SiriusPhoto.m
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusPhoto.h"

@implementation SiriusPhoto

@dynamic caption;
@dynamic ofPet;
@dynamic image;
@dynamic thumbnail;
@dynamic user;

+ (NSString *)parseClassName
{
    return @"Photo";
}

@end
