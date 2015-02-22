//
//  SiriusActivity.m
//  Sirius
//
//  Created by Silvia Galuzzi on 02/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusActivity.h"

@implementation SiriusActivity

@dynamic type;
@dynamic fromUser;
@dynamic toUser;
@dynamic message;
@dynamic photo;

+ (NSString *)parseClassName
{
    return @"Activity";
}

@end
