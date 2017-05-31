//
//  ServiceManger.m
//  StepOne
//
//  Created by Tahir Hameed on 06/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import "ServiceManager.h"
#import "Globals.h"
#import "Reachability.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPRequestOperation.h"
#import "Constants.h"
#import "Utils.h"
#import "DBManager.h"

@implementation ServiceManager

@synthesize delegate, dicUserFbDetails,selectedIndexForImageUploadFirstTime;


- (void)getUserListForChatService:(NSMutableDictionary*)params{
    NSString *jsonRequestStr = [Utils creatingJSonStringWithLatLng:GET_USERLISTFORCHAT_API requestData:params];
    NSLog(@"%@",jsonRequestStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:SERVER_URL]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[jsonRequestStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        [delegate serviceManagerCallBackMethodForChatUserList:[jsonResponse objectForKey:@"ChatList"]];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                         NSLog(@"Error: %@", error);
                                     }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}
/*
 - (void)geoNamesService:(NSString*)strURL{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strURL]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [params setValue: forKey:
    [request setHTTPMethod:@"GET"];
    NSMutableData *postBody = [NSMutableData data];
    [request setHTTPBody:postBody];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        [delegate serviceManagerCallBackMethodForChatUserList:[jsonResponse objectForKey:@"geonames"]];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                         NSLog(@"Error: %@", error);
                                     }];
    [[NSOperationQueue mainQueue] addOperation:operation];

}
*/


@end
