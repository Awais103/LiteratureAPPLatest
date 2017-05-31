//
//  Utils.h
//  StepOne
//
//  Created by Amit Kumar on 02/10/15.
//  Copyright (c) 2015 Inteligent Global Software. All rights reserved.
//

#ifndef StepOne_Utils_h
#define StepOne_Utils_h

#import <UIKit/UIKit.h>

@interface Utils : UIView
+ (NSString*)creatingJSonStringWithLatLng:(NSInteger)api requestData:(NSMutableDictionary*) requestData;
+ (NSString*)creatingJSonStringWithRequestData:(NSArray*) requestData;
+ (NSString *)relativeDateStringForDate:(NSDate *)date;
+ (NSString*)jsonForUploadingInterests:(NSInteger)api requestData:(NSMutableDictionary*) requestData;
+ (NSString *)getUserImageByUrl:(NSString *)fileName type:(NSString*)fileType;
+ (NSString *)resizeImage:(NSString *)photo_url;
+ (BOOL )stringIsEmpty:(NSString *)aString;

+ (NSString*)getFirstName:(NSString*)fullString;

//+(void)updateUserOnlineStatus:(UIBarButtonItem *)aBarButtonItem;
//+ (void)setUserOnlineStatus:(UIBarButtonItem *)aBarButtonItem;
//+(void)displayToastWithMessage:(NSString *)toastMessage;

@end

#endif
