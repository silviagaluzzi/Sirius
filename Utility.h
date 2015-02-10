//
//  Utility.h
//  Sirius
//
//  Created by Silvia Galuzzi on 03/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define OSCHECK_IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) { __VA_ARGS__ }
#else
#define OSCHECK_IF_IOS7_OR_GREATER(...)
#endif

#define OSCHECK_IF_PRE_IOS7(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0 || __IPHONE_OS_VERSION_MAX_ALLOWED < 70000) { __VA_ARGS__ }

