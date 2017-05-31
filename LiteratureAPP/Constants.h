//
//  Constants.h
//  StepOne
//
//  Created by Tahir Hameed on 06/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Constants : NSObject

//FOUNDATION_EXPORT NSString *const SERVER_URL_RizTest;
FOUNDATION_EXPORT NSString *const CHAT_IMAGE_URL;
FOUNDATION_EXPORT NSString *const PROFILE_IMAGE_URL;
FOUNDATION_EXPORT NSString *const SERVER_URL;
FOUNDATION_EXPORT NSString *const SERVER_URLOLD;
FOUNDATION_EXPORT NSString *const SERVICE_URL_FOR_CHAT;
FOUNDATION_EXPORT NSString *const iOS7AppStoreURLFormat;
FOUNDATION_EXPORT NSString *const iOSAppStoreURLFormat;

#define GOOGLE_MAP_API_KEY @"AIzaSyCE6mu0um8HkO9fRnQPO2cc9kYrT-KMI0k"// @"AIzaSyCE6mu0um8HkO9fRnQPO2cc9kYrT-KMI0k"
//@"AIzaSyCRsF0BPk1IhyfHk0x0JHS583Ts7REQkV4"
//#define GOOGLE_PLACES_API_KEY      @"AIzaSyA9pl2FkLpaoS6bKQr1DRoesIHM9gHLRLo"// @"AIzaSyCt5IgyC6MBu11kXoiSlFpKByey1dsM344"
#define GOOGLE_PLACES_API_KEY @"AIzaSyBt9ekiFkj9ElYm8UhN9FO8ixNZJ0qp5uE"

//Autocomplete Search
#define GooglePlaceEstbType                 @"establishment"
#define GooglePlaceGeocodeType              @"geocode"
#define RaidusForNearByPlaces               5000 //In meters
#define LocManagerAuthorizeErrorCode        2000
#define MAX_PLACES_IN_LIST                  20

#define iPhone4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)

//API NUMBER
#define PROFILE_API 1000 //Used to add Facebook basic details in server
#define VENUE_ATTENDANCE_API 1002 //Used to add venue selected option (yes/maybe) in database
#define VENUE_ATTENDEE_API 1003 //Used to select all the attendee for a venue in particular date.
#define  PROFILE_FETCH_API 1004 //Used to fetch profile of user.
#define PROFILE_EDIT_API  1005 //Used to save edited field of user profile.
#define NEAR_TO_ME_API  10002 //Used to fetch list of people available inside venue
#define LIKE_DISLIKE_API 1007 //Used to like/dislike people
#define PROFILE_GCM_API 1008 //Used to add GCM/device id
#define CHAT_SEND_API 1010 //Used to store chat conversation on server.
#define PROFILE_IS_VISIBLE_API 1011 //Used to set hide/unhide of user inside venue
#define CHAT_HISTORY_API 1013 //Used to get chat history
#define PROFILE_INTEREST_API 1015 //Used to update Facebook liked page (interest) in server.
#define PROFILE_SETTINGS_API 1021
#define MY_VENUE_DETAILS_ATTEND_API 1018
#define NEAR_TO_ME_LIST_API 10003
#define GET_PASSWORDFORCHAT_API 1031 //Used to select all the attendee for a venue in particular date.
#define GET_USERLISTFORCHAT_API 1009 //GET USER LIST FOR CHAT NAMES TO DISPLAY.
#define CHAT_STATUS_UPDATE_API 1026 // [Chat Update Message Status Batch]
#define PROFILE_JOB_EDUCATION_API 1033 //used to post data for user job and education
#define USER_BLOCK_MUTE_DELETE_API 1034 //To block and mute any stepper
#define PROFILE_IMAGE_DELETE_API 1035 //It will delete profile image
#define USER_BLOCKED_LIST_API 1037 //To get List of blocked Stepper
#define CHAT_DELETED_API 1039
#define USER_VENUE_VISIT_HISTORY_API 10004
#define CHAT_UPDATE_BLOCK_STATUS_API 1040
#define VENUE_LIST_SEARCH_WISE 10007
#define VENUE_IMAGE_LIST 10014
#define DELETE_GALLERY_PHOTO 10010
#define FETCH_CROSS_PATH_API 10011
#define ADD_REPORT_API  10015
#define ADD_CONTACT_API 10020
#define GALLERY_API 10021

#define ProfileImagesEditedOneByOne @"ProfileImagesEditedOneByOne" //used to call nsnotification for profile images edit
#define ProfileImagesEdited @"ProfileImagesEdited" //used to call nsnotification for profile images edit
#define ProfileImagesEditedFirstTime @"ProfileImagesEditedFirstTime" //used to call nsnotification for profile images edit
#define ProfileImagesRetry @"ProfileImagesRetry" //used to call nsnotification for profile images edit
#define ProfileImagesDownloadAtStart @"ProfileImagesDownloadAtStart" //used to call nsnotification for profile images edit
#define CacheImageLoaded @"CacheImageLoaded" //used to call nsnotification for cache image loaded
#define totalSecondsForHomeTimer 20
//home auto check in timer

//#define geofenceRadius 30000000 //1512000000 //1500 //1000 //1512000 //radius for geofence


#define geofenceRadius 3000000000 //300 //1000//1512000// //radius for geofence

//#define geofenceRadius 1512000000 //1500 //1000 //1512000 //radius for geofence

#define EnterExitRegion @"callEnterExitRegion"
#define profilePhotoLimit 9
#define YOUR_APP_STORE_ID 1128444231

@end
