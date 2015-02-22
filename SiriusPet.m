//
//  SiriusPet.m
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusPet.h"

@implementation SiriusPet

@dynamic  name;
@dynamic age;
@dynamic gender;
@dynamic breed;
@dynamic distintiveFeatures;
@dynamic type;
@dynamic owner;
@dynamic picture;

+ (NSString *)parseClassName
{
    return @"Pet";
}

@end
