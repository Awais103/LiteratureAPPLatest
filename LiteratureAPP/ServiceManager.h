    //
//  ServiceManager.h
//  StepOne
//
//  Created by Tahir Hameed on 06/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AFNetworking.h"
#import <AddressBookUI/AddressBookUI.h>

@protocol ServiceManagerCallBackDelegate <NSObject>

@optional
-(void)serviceManagerCallBackMethod:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodForOthersUserProfile:(NSMutableDictionary*)dictData;
-(void)serviceManagerCallBackMethodForNearbyPlaces:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodSteppersList:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodForChatUserList:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodForChatRoom:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodForChatRoomFailure:(NSString*)errorDescription;
-(void)serviceManagerCallBackMethodForUpdateChatUnreadMessages:(NSMutableDictionary*)dictResponse;
-(void)serviceManagerCallBackMethodForUpdateChatUnreadMessagesFailure:(NSString*)errorDescription;
-(void)serviceManagerCallBackMethodForChatMessageFailedRetryAgain:(NSString*)unique;
-(void)serviceManagerCallBackMethodForImageUploadingFirstCaseChatMessageFailedRetryAgain:(NSString*)unique;
-(void)serviceManagerCallBackMethodForChatMessageSuccess:(NSString*)unique;
-(void)serviceManagerCallBackMethodForChatRoomForKillMode:(NSArray*)arrayData;
-(void)serviceManagerCallBackMethodForChatRoomFailureForKillMode:(NSString*)errorDescription;
-(void)serviceManagerCallBackMethodForDeleteChat:(NSDictionary*)params;
-(void)serviceManagerCallBackMethodForChatPassword:(NSArray*)arrayData;
-(void)userFBLikes:(NSArray*)arrayData;
-(void)userFBSchoolInfo:(NSArray *)arrayData;
-(void)userFBEmployeeInfo:(NSArray *)arrayData;
-(void)userFBJobInfo:(NSArray *)arrayData;
-(void)userFBAlubmInfo:(NSArray *)arrayData;
-(void)HomeViewNavigate;
-(void)completeInfoOfSteppers:(NSArray *)arrInfo;
-(void)ProfileViewNavigateWithResponse:(NSMutableDictionary *)dicUserDetails;
-(void)ProfileViewNavigateToHomePage:(NSMutableDictionary *)dicUserDetails;
-(void)profileImageUploaded:(NSMutableDictionary *)result;
-(void)profileImageUploadedFailure;
-(void)profileImageUploadedRetry;
-(void)profileImageUploadedFailureRetry;
-(void)chatImageUploaded:(NSMutableDictionary*)params;
-(void)deleteProfileImages;
-(void)deleteProfileImagesAfterPostImages;
-(void)fetchFBPhotosAlbum:(NSMutableDictionary *)dicPhotoAlbum;
-(void)serviceManagerCallBackMethod_ForCorssedPaths:(NSArray*)arrayData;
-(void)galleryImageUploaded;
-(void)serviceManagerCallBackMethodForVenueLiveImages:(NSArray *)arrInfo;
@end

@interface ServiceManager : NSObject
@property (weak, nonatomic) id<ServiceManagerCallBackDelegate> delegate;

@property (assign) NSInteger selectedIndexForImageUploadFirstTime;
@property (nonatomic, strong) NSString *str_Nearby_PlaceId;
@property (nonatomic, strong) NSString *str_Nearby_PlaceName;
@property (nonatomic, strong) NSString *str_Nearby_PlacePhone;
@property (nonatomic, strong) NSString *str_Nearby_PlaceAddress;
@property (nonatomic, strong) NSString *str_Nearby_PlaceCity;
@property (nonatomic, strong) NSString *str_Nearby_PlaceLat;
@property (nonatomic, strong) NSString *str_Nearby_PlaceLng;
@property (nonatomic, strong) NSString *str_Nearby_PlaceDistance;
@property (nonatomic, strong) NSString *str_Nearby_PlaceCategoryName;
@property (nonatomic, strong) NSString *str_Nearby_PlaceIconUrl;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableDictionary *dicUserDetails;
@property (nonatomic, strong) NSOperationQueue *myQueue;
@property (nonatomic, strong) NSString *str_FBUserName;
@property (nonatomic, strong) NSString *str_FBUserMail;
@property (nonatomic, strong) NSString *str_FBUserMobileNo;
@property (nonatomic, strong) NSString *str_FBUserRelationship;
@property (nonatomic, strong) NSString *str_FBUserGender;
@property (nonatomic, strong) NSString *str_FBUserProfilePic;
@property (nonatomic, strong) NSString *str_FBUserBio;
@property (nonatomic, strong) NSString *str_FBUserDOB;
@property (nonatomic, strong) NSString *str_FBUserAboutMe;

@property (nonatomic, strong) NSString *str_FBUserLikes;
@property (nonatomic, strong) NSString *str_FBUserAlumbImages;


////getMyPlaces History

@property (nonatomic, strong) NSString *str_MyVenue_PlaceId;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceName;
@property (nonatomic, strong) NSString *str_MyVenue_PlacePhone;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceAddress;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceLat;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceLng;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceDistance;
@property (nonatomic, strong) NSString *str_MyVenue_PlaceCategoryName;
@property (nonatomic, strong) NSString *str_MyVenue_AttendType;
@property (nonatomic, strong) NSString *str_MyVenue_timestamp;

/////

@property (nonatomic, strong) NSString *str_Steppers_name;
@property (nonatomic, strong) NSString *str_Steppers_about_me;
@property (nonatomic, strong) NSString *str_Steppers_dob;
//@property (nonatomic, strong) NSString *str_Steppers_email;
//@property (nonatomic, strong) NSString *str_Steppers_employer;
@property (nonatomic, strong) NSString *str_Steppers_facebook_id;
@property (nonatomic, strong) NSString *str_Steppers_frnd_status;
@property (nonatomic, strong) NSString *str_Steppers_gcm_id;
@property (nonatomic, strong) NSString *str_Steppers_gender;
@property (nonatomic, strong) NSMutableArray *str_Steppers_interest;
@property (nonatomic, strong) NSString *str_Steppers_is_visible;
@property (nonatomic, strong) NSString *str_Steppers_job;
@property (nonatomic, strong) NSString *str_Steppers_last_known_lat;
@property (nonatomic, strong) NSString *str_Steppers_last_known_lng;
@property (nonatomic, strong) NSString *str_Steppers_like_status;
//@property (nonatomic, strong) NSString *str_Steppers_mobile;
//@property (nonatomic, strong) NSString *str_Steppers_my_status;
@property (nonatomic, strong) NSString *str_Steppers_open_chat;
//@property (nonatomic, strong) NSString *str_Steppers_school;
@property (nonatomic, strong) NSString *str_Steppers_time_left;
//@property (nonatomic, strong) NSString *str_Steppers_user_friends;
@property (nonatomic, strong) NSString *str_Steppers_venue_name;
@property (nonatomic, strong) NSString *str_Steppers_cnt_frnd;
@property (nonatomic, strong) NSString *str_Steppers_cnt_loc;
@property (nonatomic, strong) NSString *str_Steppers_interested_in;
@property (nonatomic, strong) NSString *str_Steppers_hometown;
@property (nonatomic, strong) NSString *str_Steppers_cross_paths;
@property (nonatomic, strong) NSString *str_Steppers_LoginUserVenueId;
@property (nonatomic, strong) NSString *str_Steppers_setpperVenueId;

//@property (nonatomic) NSMutableDictionary *fbLickDic;
@property (nonatomic, strong) NSDictionary *dicUserFbDetails;

//// Steppers NearToMeUser

//- (void)fetchingData:(NSMutableDictionary*)params;
//- (void)StoreSettingsDetailService:(NSMutableDictionary*)params;
//- (void)getAllVenueAtendeeService:(NSMutableDictionary*)params;
//- (void)getPasswordForChatService:(NSMutableDictionary*)params;
- (void)getUserListForChatService:(NSMutableDictionary*)params;
- (void)geoNamesService:(NSString*)strURL;
//- (void)getCompleteInfoOfStepper:(NSString *)facebook_id;
//- (void)getSettingsOfUser:(NSString *)facebook_id;
//- (void)getRegisterForChatService:(NSMutableDictionary*)params;
//- (void)SaveSentMessagesForChatService:(NSMutableDictionary*)params;
//- (void)SaveSentMessagesForChatImageService:(NSMutableDictionary*)params;
//- (void)GetMessageHistoryForChatService:(NSMutableDictionary*)params;
//- (void)GetMessageHistoryForChatServiceForKillMode:(NSMutableDictionary*)params;
//- (void)updateUnreadMessageStatus:(NSMutableDictionary*)params;
//- (void)CheckInOut_StepOnOffService:(NSMutableDictionary*)params;
//- (void)postFBProfileData:(NSMutableDictionary *)result;
//- (void)postFBInterestData:(NSMutableDictionary *)result;
//- (void)postFBWorkEducation:(NSMutableDictionary *)result;
//- (void)postFBUpdate:(NSMutableDictionary *)result;
//- (void)postFBProfileImages:(NSMutableDictionary *)result ProfileImagesArray:(NSMutableArray*)arrProfileImages;
//- (void)postFBProfileImagesOneByOne:(NSMutableDictionary *)result;
//- (void)setHideAndUnhideUserForVenueWithHideUnhide:(NSString *)ZeroAndOne;
//- (void)deleteProfileImage:(NSMutableArray *)result ProfileImagesArray:(NSMutableArray*)profileImages;
//- (void)getUserProfileByFacebookId:(NSString *)facebookId;
//- (void)getStepperBlockListByFbId:(NSString *)facebook_id;
//- (void)blockUnblockSteppersByFbId:(NSMutableDictionary *)params;
//- (void)muteUnmuteSteppersByFbId:(NSMutableDictionary *)params;

//- (void)blockUnblockSteppersByFbId:(NSString *)facebook_id stepper_id:(NSString *)stepper_id blockOrMute:(NSString *)action perform0Or1:(NSString *)perform;

//- (void)getFbUserDetails;
//- (void)getAllFacebookAlbums;
//- (void)getFBAlbumPhotos : (NSString*)albumId;
//
//- (void)syncFBUserDetails;
//- (void)StepperLikeDislikeService:(NSMutableDictionary*)params;
//- (void) getNearToMePeopleListService:(NSMutableDictionary*)params ApidCode:(NSInteger)Code;
//- (void)AddGcmIdService:(NSMutableDictionary*)params;
//- (void)fetchNearByPlacesExploreQuery:(NSMutableDictionary*)params;

//- (void)fbLoginUserDetailService:(NSMutableDictionary*)params;
//- (void)getRegisterForChatService:(NSMutableDictionary*)params;
//- (void)getUserVenueVisitedHistory:(NSMutableDictionary*)params;
//- (void)getLiveVenueImages:(NSMutableDictionary*)params;
//- (void)postVenueCapturePhotos:(NSMutableDictionary *)result;
//- (void)deleteGalleryPhotoFromServer:(NSMutableDictionary*)params;
//- (void)getCrossedPathsList:(NSMutableDictionary*)params;
//- (void)ReportStepper:(NSMutableDictionary*)params;
//- (void)ContactUsImagePost:(NSMutableDictionary *)result;
//- (void)ContactUsAPI:(NSMutableDictionary*)params;
//- (void)DeleteChatByFbId:(NSMutableDictionary *)params;

//- (void)fetchGalleryImagesCompletionBlock:(NSMutableDictionary*)dicParams
//                     andCompletionHandler:(void (^)(NSArray *photos))success
//                             failureBlock:(void (^)(NSError *error))failure;
//- (void)deleteGalleryImagesCompletionBlock:(NSMutableDictionary*)dicParams
//                     andCompletionHandler:(void (^)(NSArray *jsonResponse))success
//                             failureBlock:(void (^)(NSError *error))failure;
//- (void)fetchVenuesCompletionBlock:(NSMutableDictionary*)dicParams
//                      andCompletionHandler:(void (^)(NSArray *jsonResponse))success
//                              failureBlock:(void (^)(NSError *error))failure;
//- (void)SearchSpecificVenueCompletionBlock:(NSMutableDictionary*)dicParams
//              andCompletionHandler:(void (^)(NSArray *jsonResponse))success
//                      failureBlock:(void (^)(NSError *error))failure;

//- (void)fetchMessageHistoryForChatCompletionBlock:(NSMutableDictionary*)paramsDict
//                             andCompletionHandler:(void (^)(NSMutableArray *chatHistory))success
//                                     failureBlock:(void (^)(NSError *error))failure;

@end

