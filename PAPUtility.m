//
//  PAPUtility.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/18/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPUtility.h"
#import "PAPConstants.h"
#import "PAPCache.h"
#import "UIImage+ResizeAdditions.h"
#import "MainController.h"
#import "SiriusActivity.h"
#import "SiriusPhoto.h"

@implementation PAPUtility


#pragma mark - PAPUtility
#pragma mark Like Photos

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [SiriusActivity query];
	
    [queryExistingLikes whereKey:kPAPActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeLike];
    [queryExistingLikes whereKey:kPAPActivityFromUserKey equalTo:[SiriusUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (SiriusActivity *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        SiriusActivity	*likeActivity	= [SiriusActivity object];
		//SiriusUser		*toUser			= ((SiriusPhoto *)photo).user;
		
        likeActivity.type		= kPAPActivityTypeLike;
        likeActivity .fromUser	= [SiriusUser currentUser];
        //likeActivity.toUser		= toUser;
        likeActivity.photo		= photo;
        
        PFACL *likeACL = [PFACL ACLWithUser:[SiriusUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        //[likeACL setWriteAccess:YES forUser: toUser];
        likeActivity.ACL = likeACL;

        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
			
			//[[MainController sharedController] sendPushNotificationOfType: kPAPActivityTypeLike toUser: toUser];

            // refresh cache
            PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    NSMutableArray *comments = [NSMutableArray array];

                    BOOL isLikedByCurrentUser = NO;
                    
                    for (SiriusActivity *activity in objects) {
                        if ([activity.type isEqualToString:kPAPActivityTypeLike] && activity.fromUser) {
                            [likers addObject: activity.fromUser];
                        } else if ([activity.type isEqualToString: kPAPActivityTypeComment] && activity.fromUser) {
                            [commenters addObject: activity.fromUser];
                        }
                        
                        if ([activity.type isEqualToString:kPAPActivityTypeComment]) {
                            [comments addObject:activity];
                        }

                        if ([[activity.fromUser objectId] isEqualToString:[[SiriusUser currentUser] objectId]]) {
                            if ([activity.type isEqualToString:kPAPActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters comments:comments likedByCurrentUser:isLikedByCurrentUser];
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];

        }];
    }];

}

+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [SiriusActivity query];
	
    [queryExistingLikes whereKey:kPAPActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeLike];
    [queryExistingLikes whereKey:kPAPActivityFromUserKey equalTo:[SiriusUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (SiriusActivity *activity in activities) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }

            // refresh cache
            PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    NSMutableArray *comments = [NSMutableArray array];

                    BOOL isLikedByCurrentUser = NO;
                    
                    for (SiriusActivity *activity in objects) {
                        if ([activity.type isEqualToString:kPAPActivityTypeLike] && activity.fromUser) {
                            [likers addObject: activity.fromUser];
                        } else if ([activity.type isEqualToString: kPAPActivityTypeComment] && activity.fromUser) {
                            [commenters addObject: activity.fromUser];
                        }
                        
                        if ([activity.type isEqualToString:kPAPActivityTypeComment]) {
                            [comments addObject:activity];
                        }

                        if ([[activity.fromUser objectId] isEqualToString:[[SiriusUser currentUser] objectId]]) {
                            if ([activity.type isEqualToString:kPAPActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters comments:comments likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];

        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];  
}


#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    if (newProfilePictureData.length == 0) {
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.

    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory

    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];

        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            return;
        }
    }

    UIImage *image = [UIImage imageWithData:newProfilePictureData];

    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];

    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);

    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[SiriusUser currentUser].profilePictureMedium	= fileMediumImage;
                [[SiriusUser currentUser] save];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[SiriusUser currentUser].profilePictureSmall	= fileSmallRoundedImage;
                [[SiriusUser currentUser] save];
            }
        }];
    }
}

+ (BOOL)userHasValidFacebookData:(SiriusUser *)user {
    NSString *facebookId = user.facebookId;
	
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(SiriusUser *)user
{
    //return (user.profilePictureMedium && user.profilePictureSmall);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(SiriusUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[SiriusUser currentUser] objectId]]) {
        return;
    }
    
    SiriusActivity		*followActivity = [SiriusActivity object];
	
    followActivity.fromUser	= [SiriusUser currentUser];
    followActivity.toUser	= user;
    followActivity.type		= kPAPActivityTypeFollow;
    
    PFACL *followACL = [PFACL ACLWithUser:[SiriusUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[PAPCache sharedCache] setFollowStatus:YES user:user];
	
	[[MainController sharedController] sendPushNotificationOfType: kPAPActivityTypeFollow toUser: user];
}

+ (void)followUserEventually:(SiriusUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[SiriusUser currentUser] objectId]]) {
        return;
    }
    
    SiriusActivity *followActivity = [SiriusActivity object];
	
    followActivity.fromUser	= [SiriusUser currentUser];
    followActivity.toUser	= user;
    followActivity.type		= kPAPActivityTypeFollow;
    
    PFACL *followACL = [PFACL ACLWithUser:[SiriusUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[PAPCache sharedCache] setFollowStatus:YES user:user];
	
	[[MainController sharedController] sendPushNotificationOfType: kPAPActivityTypeFollow toUser: user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    for (SiriusUser *user in users) {
        [PAPUtility followUserEventually:user block:completionBlock];
        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
}


+ (void)unfollowUserEventually:(SiriusUser *)user {
    PFQuery *query = [SiriusActivity query];
	
    [query whereKey:kPAPActivityFromUserKey equalTo:[SiriusUser currentUser]];
    [query whereKey:kPAPActivityToUserKey equalTo:user];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (SiriusActivity *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    [[PAPCache sharedCache] setFollowStatus:NO user:user];
}


+ (void)unfollowUsersEventually:(NSArray *)users {
    PFQuery *query = [SiriusActivity query];
	
    [query whereKey:kPAPActivityFromUserKey equalTo:[SiriusUser currentUser]];
    [query whereKey:kPAPActivityToUserKey containedIn:users];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (SiriusActivity *activity in activities) {
            [activity deleteEventually];
        }
    }];
    for (SiriusUser *user in users) {
        [[PAPCache sharedCache] setFollowStatus:NO user:user];
    }
}


#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *queryLikes = [SiriusActivity query];
	
    [queryLikes whereKey:kPAPActivityPhotoKey equalTo:photo];
    [queryLikes whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeLike];
    
    PFQuery *queryComments = [SiriusActivity query];
	
    [queryComments whereKey:kPAPActivityPhotoKey equalTo:photo];
    [queryComments whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];

    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kPAPActivityFromUserKey];
    [query includeKey:kPAPActivityPhotoKey];
    [query orderByAscending:@"createdAt"];

    return query;
}


#pragma mark Shadow Rendering

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y - 5.0f, 
                                          rect.size.width, 
                                          rect.size.height + 5.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {    
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y - 10.0f, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y, 
                                          rect.size.width, 
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {    
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y - 5.0f, 
                                          rect.size.width, 
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController {
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, navigationController.navigationBar.frame.size.height, navigationController.navigationBar.frame.size.width, 3.0f)];
    [gradientView setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    navigationController.navigationBar.clipsToBounds = NO;
    [navigationController.navigationBar addSubview:gradientView];	    
}

@end
