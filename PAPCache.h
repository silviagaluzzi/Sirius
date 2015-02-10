//
//  PAPCache.h
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SiriusUser.h"

@interface PAPCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters comments:(NSArray *)comments likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
- (NSArray *)likersForPhoto:(PFObject *)photo;
- (void)setLikers:(NSArray*)likers forPhoto:(PFObject *)photo;
- (NSArray *)likersNamesForPhoto:(PFObject *)photo;
- (NSArray *)commentersForPhoto:(PFObject *)photo;
- (NSArray *)commentsForPhoto:(PFObject *)photo;
- (void)addComment:(PFObject*)activity forPhoto:(PFObject*)photo;
- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;
- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo;
- (void)incrementLikerCountForPhoto:(PFObject *)photo;
- (void)decrementLikerCountForPhoto:(PFObject *)photo;
- (void)incrementCommentCountForPhoto:(PFObject *)photo;
- (void)decrementCommentCountForPhoto:(PFObject *)photo;

- (NSDictionary *)attributesForUser:(SiriusUser *)user;
- (NSNumber *)photoCountForUser:(SiriusUser *)user;
- (BOOL)followStatusForUser:(SiriusUser *)user;
- (void)setPhotoCount:(NSNumber *)count user:(SiriusUser *)user;
- (void)setFollowStatus:(BOOL)following user:(SiriusUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;
@end
