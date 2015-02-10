//
//  PAPConstants.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/25/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPConstants.h"

NSString *const kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kPAPUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.Anypic.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kPAPLaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification

NSString *const PAPAppDelegateApplicationDidReceiveRemoteNotification           = @"com.parse.Anypic.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const PAPUtilityUserFollowingChangedNotification                      = @"com.parse.Anypic.utility.userFollowingChanged";
NSString *const PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.Anypic.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const PAPUtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification";
NSString *const PAPTabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.Anypic.tabBarController.didFinishEditingPhoto";
NSString *const PAPTabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification";
NSString *const PAPPhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.Anypic.photoDetailsViewController.userDeletedPhoto";
NSString *const PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.parse.Anypic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const PAPPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.Anypic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kPAPEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kPAPInstallationUserKey = @"user";

#pragma mark - Activity Class
// Class key
NSString *const kPAPActivityClassKey = @"Activity";

// Field keys
NSString *const kPAPActivityTypeKey        = @"type";
NSString *const kPAPActivityFromUserKey    = @"fromUser";
NSString *const kPAPActivityToUserKey      = @"toUser";
NSString *const kPAPActivityContentKey     = @"content";
NSString *const kPAPActivityPhotoKey       = @"photo";

// Type values
NSString *const kPAPActivityTypeLike        = @"like";
NSString *const kPAPActivityTypeFollow      = @"follow";
NSString *const kPAPActivityTypeComment     = @"comment";
NSString *const kPAPActivityTypeJoined      = @"joined";
NSString *const kPAPActivityTypeWish        = @"wish";
NSString *const kPAPActivityTypePurchase    = @"purchase";

#pragma mark - Bolla Class
// Class Key
NSString *const kPAPBollaClassKey           = @"Bolle";

//Field keys
NSString *const kPAPBollaIDClienteKey       = @"IDcliente";
NSString *const kPAPBollaQtaKey             = @"Qta";
NSString *const kPAPBollaCodiceKey          = @"codice";
NSString *const kPAPBollaCodiceArticoloKey  = @"codice_articolo";
NSString *const kPAPBollaCodiceUnivocoKey   = @"codice_univoco";
NSString *const kPAPBollaDataKey            = @"data";
NSString *const kPAPBollaIDOrdineKey        = @"idordine";


#pragma mark - Brand Class
// Class Key
NSString *const kPAPBrandClassKey           = @"Brand";

//Field keys
NSString *const kPAPBrandNameKey            = @"name";

/*
#pragma mark - Client Class
// Class Key
NSString *const kPAPClientClassKey          = @"Client";

//Field keys
NSString *const kPAPClientIdClienteKey      = @"IdCliente";
NSString *const kPAPClientContentKey        = @"content";
NSString *const kPAPClientDescrizioneKey    = @"descrizioneCliente";
NSString *const kPAPClientIdCaogioKey       = @"idCaogio";
NSString *const kPAPClientWebUrlKey         = @"webUrl";
*/

#pragma mark - PFObject Clienti Class
// Field keys
NSString *const kPAPClientiClassKey         =@"Clienti";

NSString *const kPAPClientiIdClienteKey     =@"idCliente";
NSString *const kPAPClientiCittaKey         =@"citta";
NSString *const kPAPClientiDeletedKey       =@"deleted";
NSString *const kPAPClientiEmailKey         =@"email";
NSString *const kPAPClientiIdCaogioKey      =@"idCaogio";
NSString *const kPAPClientiIsCaovillaKey    =@"idCaovilla";
NSString *const kPAPClientiLongDescKey      =@"longDesc";
NSString *const kPAPClientiNazioneKey       =@"nazione";
NSString *const kPAPClientiPhoneHey         =@"phone";
NSString *const kPAPClientiShortDescKey     =@"shortDesc";
NSString *const kPAPClientiViaKey           =@"via";
NSString *const kPAPClientiWebUrlKey        =@"webUrl";


#pragma mark - CodiciUsati Class
// Class Key
NSString *const kPAPCodiciUsatiClassKey         =@"CodiciUsati";

//Field keys
NSString *const kPAPCodiceUsatoCodUnivocoKey    = @"codice_univoco";
NSString *const kPAPCodiceUsatoUserKey          = @"user";


#pragma mark - User Class
// Field keys
NSString *const kPAPUserDisplayNameKey                          = @"displayName";
NSString *const kPAPUserFacebookIDKey                           = @"facebookId";
NSString *const kPAPUserPhotoIDKey                              = @"photoId";
NSString *const kPAPUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kPAPUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kPAPUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kPAPUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";


#pragma mark - Photo Class
// Class key
NSString *const kPAPPhotoClassKey = @"Photo";

// Field keys
NSString *const kPAPPhotoPictureKey         = @"image";
NSString *const kPAPPhotoThumbnailKey       = @"thumbnail";
NSString *const kPAPPhotoUserKey            = @"user";
NSString *const kPAPPhotoCaptionKey         = @"caption";
NSString *const kPAPPhotoTypeKey			= @"type";
NSString *const kPAPPhotoProductKey			= @"codiceArticolo";


#pragma mark - Cached Photo Attributes
// keys
NSString *const kPAPPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kPAPPhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kPAPPhotoAttributesLikersKey               = @"likers";
NSString *const kPAPPhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kPAPPhotoAttributesCommentersKey           = @"commenters";
NSString *const kPAPPhotoAttributesCommentsKey             = @"comments";


#pragma mark - Cached User Attributes
// keys
NSString *const kPAPUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kPAPUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kPAPPushPayloadPayloadTypeKey          = @"p";
NSString *const kPAPPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kPAPPushPayloadActivityTypeKey     = @"t";
NSString *const kPAPPushPayloadActivityLikeKey     = @"l";
NSString *const kPAPPushPayloadActivityCommentKey  = @"c";
NSString *const kPAPPushPayloadActivityFollowKey   = @"f";

NSString *const kPAPPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kPAPPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kPAPPushPayloadPhotoObjectIdKey    = @"pid";