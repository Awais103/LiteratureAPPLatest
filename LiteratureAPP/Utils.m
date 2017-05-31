//
//  Utils.m
//  StepOne
//
//  Created by Amit Kumar on 02/10/15.
//  Copyright (c) 2015 Inteligent Global Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "Constants.h"

@implementation Utils

+ (NSString*)creatingJSonStringWithLatLng:(NSInteger)api requestData:(NSMutableDictionary*) requestData{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSDate *date = [NSDate date];
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    NSString* apiString = [NSString stringWithFormat:@"%li", (long)api];
    NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
    //
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"newLocation"];
    if (userLoc) {
        [jsonObj setObject:[userLoc objectForKey:@"lat"] forKey:@"lat"];
        [jsonObj setObject:[userLoc objectForKey:@"long"] forKey:@"lng"];
    }else{
            [jsonObj setObject:@"25.098246" forKey:@"lat"];
            [jsonObj setObject:@"55.178598" forKey:@"lng"];
    }
    [jsonObj setObject:@"iOS" forKey:@"device"];
    [jsonObj setObject:language forKey:@"locale"];
    [jsonObj setObject:tzName forKey:@"timezone"];
    [jsonObj setObject:@"0" forKey:@"dst"];
    [jsonObj setObject:timeInMS forKey:@"timestamp_milli"];
    [jsonObj setObject:apiString forKey:@"jsonapi"];
    [jsonObj setObject:requestData forKey:@"input"];
    [jsonObj setObject:@"xxnull" forKey:@"address"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] init];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
    
}


+ (NSString*)jsonForUploadingInterests:(NSInteger)api requestData:(NSMutableDictionary*) requestData
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSDate *date = [NSDate date];
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    NSString* apiString = [NSString stringWithFormat:@"%li", (long)api];
    NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
    //
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"newLocation"];
    // Test Akhzar Nazir
//    [jsonObj setObject:@"25.098246" forKey:@"lat"];
//    [jsonObj setObject:@"55.178598" forKey:@"lng"];
    if (userLoc) {
//        [jsonObj setObject:[userLoc objectForKey:@"lat"] forKey:@"lat"];
//        [jsonObj setObject:[userLoc objectForKey:@"long"] forKey:@"lng"];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *facebook_id = [prefs objectForKey:@"facebook_id"];
    [jsonObj setObject:facebook_id forKey:@"facebook_id"];
    [jsonObj setObject:@"iOS" forKey:@"device"];
    [jsonObj setObject:language forKey:@"locale"];
    [jsonObj setObject:tzName forKey:@"timezone"];
    [jsonObj setObject:@"0" forKey:@"dst"];
    [jsonObj setObject:timeInMS forKey:@"timestamp_milli"];
    [jsonObj setObject:apiString forKey:@"jsonapi"];
    [jsonObj setObject:requestData forKey:@"input"];
    [jsonObj setObject:@"xxnull" forKey:@"address"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] init];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
    
}

//+ (NSString*)getJsonRequest:(int)api requestData:(NSMutableDictionary*) requestData {
//    
//    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    NSString *tzName = [timeZone name];
//    NSDate *date = [NSDate date];
//    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
//    NSString* apiString = [NSString stringWithFormat:@"%i", api];
//    NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
//    
//    [jsonObj setObject:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"facebook_id"]] forKey:@"facebook_id"];
//    
//    
//    [jsonObj setObject:@"iOS" forKey:@"device"];
//    [jsonObj setObject:language forKey:@"locale"];
//    [jsonObj setObject:tzName forKey:@"timezone"];
//    [jsonObj setObject:@"0" forKey:@"dst"];
//    [jsonObj setObject:timeInMS forKey:@"timestamp_milli"];
//    [jsonObj setObject:apiString forKey:@"jsonapi"];
//    [jsonObj setObject:requestData forKey:@"input"];
//    //"birthday": "01\/04\/1982",
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] init];
//    if (!jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    
//    return jsonString;
//
//}

+ (NSString*)creatingJSonStringWithRequestData:(NSArray*) requestData {
    NSMutableArray *jsonObj = [[NSMutableArray alloc] initWithArray:requestData];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] init];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

+ (id)alloc {
    [NSException raise:@"Cannot be instantiated!" format:@"Static class 'Utils' cannot be instantiated!"];
    return nil;
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components1];
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *thatdate = [cal dateFromComponents:components1];
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                    options:0];
    
    if (components.year > 0)
    {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0)
    {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0)
    {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0)
    {
        if (components.day > 1)
        {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a"];
            NSString *startTimeString = [NSString stringWithFormat:@"last scene Yesterday at %@",[formatter stringFromDate:date]];
            return startTimeString;
        }
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *startTimeString = [NSString stringWithFormat:@"last scene today at %@",[formatter stringFromDate:date]];
        return startTimeString;
    }
}

//https://str01.stepone-app.com/file.php?type=profile&filename=979118392162855_0.jpg&width=100&height=100&profileId=979118392162855

+ (NSString *)getUserImageByUrl:(NSString *)fileName type:(NSString*)fileType{
 // filetypes =  profile, chat, instagram
//    float Height = [UIScreen mainScreen].bounds.size.height ;
//    float Width =  [UIScreen mainScreen].bounds.size.width;
    NSArray* foo = [fileName componentsSeparatedByString: @"_"];
    NSString* facebookId = [foo objectAtIndex: 0];
//    NSString *imageUrl =[NSString stringWithFormat:@"%@type=profile&filename=%@.jpg&width=%.f&height=%.f&profileId=%@",PROFILE_IMAGE_URL,fileName,Width,Height,facebookId];

//    NSString *imageUrl =[NSString stringWithFormat:@"%@type=%@&filename=%@.jpg&profileId=%@",PROFILE_IMAGE_URL,fileType,fileName,facebookId];
    
    NSString *imageUrl;
    if ([fileType isEqualToString:@"instagram"]) {
        imageUrl =[NSString stringWithFormat:@"%@type=%@&filename=%@&profileId=%@",PROFILE_IMAGE_URL,fileType,fileName,facebookId];
    }
    else{
        imageUrl =[NSString stringWithFormat:@"%@type=%@&filename=%@.jpg&profileId=%@",PROFILE_IMAGE_URL,fileType,fileName,facebookId];
    }

    return imageUrl;
}


+ (NSString *)resizeImage :(NSString *)photo_url
{
    NSArray* foo = [photo_url componentsSeparatedByString: @","];
    NSString* photo_ref = [foo objectAtIndex: 0];
    
    if ([photo_ref rangeOfString:@"/img/general/"].location != NSNotFound)
    {
        //   NSLog(@"string contains bla!");
        NSArray* foo = [photo_ref componentsSeparatedByString: @"/"];
        NSString* firstBit = [foo objectAtIndex:5];
        NSArray* foo2 = [firstBit componentsSeparatedByString: @"x"];
        float actualWidth = [[foo2 objectAtIndex:0] floatValue];
        float actualHeight = [[foo2 objectAtIndex:1] floatValue];
        float maxHeight = 200;// [UIScreen mainScreen].bounds.size.height; //568.0;
        float maxWidth = 300;//[UIScreen mainScreen].bounds.size.width;//320.0;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = maxWidth/maxHeight;
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        /*
         float imgRatio = actualWidth/actualHeight;
         float maxRatio = 320.0/480.0;
         if(imgRatio!=maxRatio){
         if(imgRatio < maxRatio){
         imgRatio = 480.0 / actualHeight;
         actualWidth = imgRatio * actualWidth;
         actualHeight = 480.0;
         }
         else{
         imgRatio = 320.0 / actualWidth;
         actualHeight = imgRatio * actualHeight;
         actualWidth = 320.0;
         }
         }
         else
         {
         NSLog(@"alrady small image");
         }
         */
        
//        NSString *finalSize = [NSString stringWithFormat:@"%@x%@",[NSNumber numberWithFloat:actualWidth].stringValue,[NSNumber numberWithFloat:actualHeight].stringValue];
        NSString *finalSize = [NSString stringWithFormat:@"%.fx%.f",actualWidth,actualHeight];
        photo_ref = [photo_ref stringByReplacingOccurrencesOfString:firstBit withString:finalSize];
        return photo_ref;
    }
    else
    {
        return photo_ref;
    }
}

+ (BOOL) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    else if (aString == nil) {
        return YES;
    }
    /*else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }*/
    else if ([aString isEqualToString:@"<null>"]) {
        return YES;
    }
    else if ([aString isEqualToString:@"(null)"]) {
        return YES;
    }
    else if ([aString isEqualToString:@""]) {
        return YES;
    }

    return NO;
    
}

+ (NSString*)getFirstName:(NSString*)fullString{
    NSString *nameStr = [NSString stringWithFormat:@"%@",fullString];
    NSArray *firstLastStrings = [nameStr componentsSeparatedByString:@" "];
    NSString *firstName = [firstLastStrings objectAtIndex:0];
    return firstName;
}

@end
