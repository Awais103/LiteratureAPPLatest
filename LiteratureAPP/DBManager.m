//
//  DBManager.m
//  StepOne
//
//  Created by adnan on 22/02/2016.
//  Copyright © 2016 Limitless. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

//+(DBManager*)getSharedInstance{
//    if (!sharedInstance) {
//        sharedInstance = [[super allocWithZone:NULL]init];
//        [sharedInstance createDB];
//    }
//    return sharedInstance;
//}

+(DBManager *) getSharedInstance{
    
    @synchronized(self){
        
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
            [sharedInstance createDB];
            
        }
    }
    return sharedInstance;
}

+ (void)resetSharedInstance {
    
    @synchronized(self){
        sharedInstance = nil;
        database = nil;
        statement = nil;
    }
}


- (NSString *)versionNumberString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return majorVersion;
}

-(BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"StepOneDB.db"]];
    //    NSLog(@"db path = %@",databasePath);
    BOOL isSuccess = YES;
    NSString *currentVersion = [self versionNumberString];
    //    NSLog(@"db Version = %f",[currentVersion floatValue]);
    //    NSLog(@"db Version = %f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"oldAppVersion"] floatValue]);
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldAppVersion"];
    if (previousVersion==nil || [previousVersion compare: currentVersion options: NSNumericSearch] == NSOrderedAscending) {
        //            NSLog(@"New Version Received");
        NSString *valueToSave = currentVersion;
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"oldAppVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
           
            "create table if not exists tbl_Settings (Men text, Women text, MenAndWomen text, LowerAgeRange text,UpperAgeRange text, OpenChat text, AutoCheckIn text,VisibleOutsideVenue text,ShowVisible text,SteppersAttending text , ShowAge text,ShowHomeTown text,ShowFacebookInterests text , ShowInstagramID text ,ShowInstagramPhotos text , ShowMobileContact text,ShowEmailContact text ,ShowEmployer text , showWork text , ShowSchool text , NewMatch text, Chats text,showPlaces text);"
            
            "create table if not exists tbl_Digest (Digest_ID text, cover_image text, NoOfPages text);"
            
            "create table if not exists tbl_NearbyPlaces(ID INTEGER PRIMARY KEY AUTOINCREMENT,PlaceName text, PlaceID Text, PlacePhone Text, PlaceAddress Text,PlaceDistance Text, PlaceLat Text , Placelng Text,PlaceIcon Text,description Text,opening_days Text,opening_time Text,website Text);"
            
            "create table if not exists tbl_CheckInPlaces(ID INTEGER PRIMARY KEY AUTOINCREMENT,PlaceID TEXT,PlaceName text,PlacePhone Text,PlaceAddress Text, PlaceCity Text,PlaceDistance Text, PlaceLat Text , Placelng Text,PlaceIcon Text,Date Text,CurrentStatus Text);"
            
            "create table if not exists tbl_CheckInTimeInOut(ID INTEGER PRIMARY KEY AUTOINCREMENT,CheckInTime Text,CheckOutTime Text, CheckInPlaceID Text);"
            
            "create table if not exists tbl_FBUserDetail(facebook_id text, name Text, email Text, gender Text, dob Text, photo Text, about_me Text, school Text, job Text, employer Text, interest text, mobile text, gcm_id Text, InstagramId text, FBRelationship Text, birthDay Text,Hometown text,Location text);"
            
            "create table if not exists tbl_StepOnOff(ID INTEGER PRIMARY KEY   AUTOINCREMENT,PlaceID TEXT,PlaceName text,PlacePhone Text,PlaceAddress Text, PlaceLat Text , Placelng Text,Distance Text,PlaceIcon Text,CurrentStatus Text,Date Text);"
            
            "create table if not exists tbl_StepOneChatFriendList(block_status TEXT,chat_status TEXT,facebook_id TEXT, gcm_id TEXT, match_status TEXT, msg TEXT, msg_date TEXT, msg_type TEXT, mute_status TEXT, my_block_status TEXT, new_msg_cnt TEXT, open_chat TEXT, stepper_name TEXT, transaction_date TEXT, venue_id TEXT, venue_name TEXT);"
            
            "create table if not exists tbl_UnreadChatMessages(facebook_id TEXT,unread_count TEXT);"
            
            "create table if not exists tbl_OnlineStatus(facebook_id TEXT,status TEXT,dateTime TEXT);"
            
            "create table if not exists tbl_GalleryImages(ID INTEGER PRIMARY KEY AUTOINCREMENT,photo_filename TEXT,venue_name TEXT,venue_id TEXT,venue_address TEXT,photo_taken Text);"
            
            "create table if not exists tbl_StepOneChatRoomList(chat_key TEXT,chat_status text,curTime Text,id Text, is_deleted Text, msg Text, imageAttachment Text, received_datetime Text,receiver_id Text,sender_id Text, sent_datetime Text,show_message Text,type Text, unique_msg_id Text,message_saved Text,friend_id Text);"
            
            "create table if not exists fbTable(block_status Text,chat_status Text,gcm_id Text,match_status Text,msg Text,msg_date Text,msg_type Text,mute_status Text,my_block_status Text,new_msg_cnt Text,open_chat Text,stepper_id Text,stepper_name Text,transaction_date Text,venue_id Text,venue_name Text);"
            "create table if not exists testTable(Name Text,FatherName Text,Address Text);"
            
            "create table if not exists signupTable(FullName Text,EmailAddress Text,Password Text);";
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            
            return  isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
        
    }
    
    return isSuccess;
}

#pragma mark
#pragma mark Settings Database actions

- (BOOL)saveSettingsFromServer:(NSArray *)arrSettings {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into tbl_Settings (Men,Women,MenAndWomen, LowerAgeRange,UpperAgeRange,OpenChat,AutoCheckIn,VisibleOutsideVenue,ShowVisible,SteppersAttending,ShowAge,ShowHomeTown,ShowFacebookInterests,ShowInstagramID,ShowInstagramPhotos,ShowMobileContact,ShowEmailContact,ShowEmployer,showWork,ShowSchool,NewMatch,Chats,showPlaces) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_men"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_women"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_men_women"]]], [NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_age_min"]], [NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_age_max"]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_openchat"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_autocheck"]]],[self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"visible_outside_venue"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_visible"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", @"1"]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_show_age"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_hometown"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_fb_interests"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_instagram_id"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_instagram_photos"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_mobile"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_email"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_employer"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"show_work"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_school"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_notf_newmatch"]]], [self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"settings_notf_chat"]]],[self getTrueFalseByValue:[NSString stringWithFormat:@"%@", [arrSettings valueForKey:@"show_places"]]]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //            NSLog(@"Success");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else {
            NSLog(@"failed to insert");
            return NO;
        }
    }
    return NO;
}

//////-------SignupTable Data insertion-------/////////
- (BOOL)insertSignup:(NSArray *)arrSignup{
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *insert;
    char *update = "insert into singupTable (FullName, EmailAddress, Password) values (?,?,?)";
    if (sqlite3_prepare_v2(database, update, -1, &insert, nil) == SQLITE_OK) {
        
        for (int x = 0; x<[arrSignup count]; x++) {
            
            NSString *FullName = [[arrSignup objectAtIndex:x] objectForKey:@"full_name"];
            NSString *EmailAddress= [[arrSignup objectAtIndex:x] objectForKey:@"email_address"];
            NSString *Password = [[arrSignup objectAtIndex:x] objectForKey:@"password"];
            
            sqlite3_bind_text(insert, 1, [FullName UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [EmailAddress UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [Password UTF8String], -1, NULL);
            
            
            if (sqlite3_step(insert) != SQLITE_DONE) // ALWAYS RETURNS Error: NULL
                NSLog(@"Error updating table: %s", sqlite3_errmsg(database));
            sqlite3_reset(insert);
            
        }
        
        sqlite3_finalize(insert);
        
    }
    
    sqlite3_close(database);
    NSLog(@"success");
    return YES;
    
}

/////////-----------------------------------------////////////
////////-------Select From SignupTable-----------////////////

- (NSMutableArray*)getSignup{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select * from signupTable"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                
                NSString *FullName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *EmailAddress = [NSString stringWithUTF8String:(char *)
                                        sqlite3_column_text(compiledStatement, 1)];
                NSString *Password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                
                
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",FullName] forKey:@"full_name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",EmailAddress] forKey:@"email_address"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Password] forKey:@"password"];
                
                
                
                [array addObject:dataDictionary];
                
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}

/////////-----------------------------------------////////////

- (void)deleteChatFriendList{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOneChatFriendList"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
        }else {
            NSLog(@"failed to delete");
        }
    }
}

- (void)deleteTest{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOneChatFriendList"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
        }else {
            NSLog(@"failed to delete");
        }
    }
}


- (NSMutableArray*)getAllStudentList{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select * from testTable"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                
                NSString *Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *FatherName = [NSString stringWithUTF8String:(char *)
sqlite3_column_text(compiledStatement, 1)];
                NSString *Address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
               
                
                
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Name] forKey:@"Name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",FatherName] forKey:@"FatherName"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Address] forKey:@"Address"];
            
                
                
                [array addObject:dataDictionary];
            
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}

- (NSMutableArray*)getDataFromApi{
    NSMutableArray *arrayGet = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select * from fbTable"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionaryGet=[[NSMutableDictionary alloc] init];
                
                NSString *block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *chat_status = [NSString stringWithUTF8String:(char *)
                                        sqlite3_column_text(compiledStatement, 1)];
                NSString *gcm_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *match_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *msg = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 4)];
                NSString *msg_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *msg_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *mute_status = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 7)];
                NSString *my_block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *new_msg_cnt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *open_chat = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 10)];
                NSString *stepper_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *stepper_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString *transaction_date = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 13)];
                NSString *venue_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString *venue_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                
                
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",block_status] forKey:@"block_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",chat_status] forKey:@"chat_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",gcm_id] forKey:@"gcm_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",match_status] forKey:@"match_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg] forKey:@"msg"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg_date] forKey:@"msg_date"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg_type] forKey:@"msg_type"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",mute_status] forKey:@"mute_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",my_block_status] forKey:@"my_block_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",new_msg_cnt] forKey:@"new_msg_cnt"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",open_chat] forKey:@"open_chat"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",stepper_id] forKey:@"stepper_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",stepper_name] forKey:@"stepper_name"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",transaction_date] forKey:@"transaction_date"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",venue_id] forKey:@"venue_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",venue_name] forKey:@"venue_name"];

                [arrayGet addObject:dataDictionaryGet];
                
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return arrayGet;
}




- (BOOL)insertTest:(NSArray *)arrTest{
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *insert;
    char *update = "insert into testTable (Name, FatherName, Address) values (?,?,?)";
    if (sqlite3_prepare_v2(database, update, -1, &insert, nil) == SQLITE_OK) {
        
        for (int x = 0; x<[arrTest count]; x++) {
            
            NSString *Name = [[arrTest objectAtIndex:x] objectForKey:@"name"];
            NSString *FatherName= [[arrTest objectAtIndex:x] objectForKey:@"father_name"];
            NSString *Address = [[arrTest objectAtIndex:x] objectForKey:@"address"];

            sqlite3_bind_text(insert, 1, [Name UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [FatherName UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [Address UTF8String], -1, NULL);

            
            if (sqlite3_step(insert) != SQLITE_DONE) // ALWAYS RETURNS Error: NULL
                NSLog(@"Error updating table: %s", sqlite3_errmsg(database));
            sqlite3_reset(insert);
        
        }
        
        sqlite3_finalize(insert);
    
    }
    
    sqlite3_close(database);
    NSLog(@"success");
    return YES;

}


- (BOOL)insertFB:(NSArray *)arrayFB{
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *insert;
    char *update = "insert into fbTable (block_status, chat_status, gcm_id, match_status, msg, msg_date, msg_type, mute_status, my_block_status, new_msg_cnt, open_chat, stepper_id, stepper_name, transaction_date, venue_id, venue_name) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, update, -1, &insert, nil) == SQLITE_OK) {
        
        for (int x = 0; x<[arrayFB count]; x++) {
            
            NSString *block_status = [[arrayFB objectAtIndex:x] objectForKey:@"block_status"];
            NSString *chat_status= [[arrayFB objectAtIndex:x] objectForKey:@"chat_status"];
            NSString *gcm_id = [[arrayFB objectAtIndex:x] objectForKey:@"gcm_id"];
            NSString *match_status = [[arrayFB objectAtIndex:x] objectForKey:@"match_status"];
            NSString *msg= [[arrayFB objectAtIndex:x] objectForKey:@"msg"];
            NSString *msg_date = [[arrayFB objectAtIndex:x] objectForKey:@"msg_date"];
            NSString *msg_type = [[arrayFB objectAtIndex:x] objectForKey:@"msg_type"];
            NSString *mute_status= [[arrayFB objectAtIndex:x] objectForKey:@"mute_status"];
            NSString *my_block_status = [[arrayFB objectAtIndex:x] objectForKey:@"my_block_status"];
            NSString *new_msg_cnt = [[arrayFB objectAtIndex:x] objectForKey:@"new_msg_cnt"];
            NSString *open_chat= [[arrayFB objectAtIndex:x] objectForKey:@"open_chat"];
            NSString *stepper_id = [[arrayFB objectAtIndex:x] objectForKey:@"stepper_id"];
            NSString *stepper_name = [[arrayFB objectAtIndex:x] objectForKey:@"stepper_name"];
            NSString *transaction_date= [[arrayFB objectAtIndex:x] objectForKey:@"transaction_date"];
            NSString *venue_id = [[arrayFB objectAtIndex:x] objectForKey:@"venue_id"];
            NSString *venue_name = [[arrayFB objectAtIndex:x] objectForKey:@"venue_name"];

            
            sqlite3_bind_text(insert, 1, [block_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [chat_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [gcm_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 4, [match_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 5, [msg UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 6, [msg_date UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 7, [msg_type UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 8, [mute_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 9, [my_block_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 10, [new_msg_cnt UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 11, [open_chat UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 12, [stepper_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 13, [stepper_name UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 14, [transaction_date UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 15, [venue_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 16, [venue_name UTF8String], -1, NULL);
            
            if (sqlite3_step(insert) != SQLITE_DONE) // ALWAYS RETURNS Error: NULL
                NSLog(@"Error updating table: %s", sqlite3_errmsg(database));
            sqlite3_reset(insert);
            
        }
        
        sqlite3_finalize(insert);
        
    }
    
    sqlite3_close(database);
    NSLog(@"success");
    return YES;
    
}

- (void) deletefromfbTable {
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from fbTable"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            //            NSLog(@"delete profile from local db success");
        }
        else {
            NSLog(@"failed to delete profile in local db");
        }
    }
}


// Update DB
- (void)updateChatRoomHistory:(NSString *)unique message_saved:(NSString *)message_saved {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE tbl_StepOneChatRoomList SET %@ = '%@' WHERE unique_msg_id = '%@'",@"message_saved", message_saved,unique];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //            NSLog(@"Success update in local db");
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else {
            NSLog(@"failed to insert in local db");
        }
    }
}


- (void)deleteChatRoomHistory:(NSString*)friend_id{
    
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOneChatRoomList where friend_id = %@",friend_id];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"failed to delete");
        }
    }
}

- (void)deleteChatRoomForAllUsersToGetChatLatestHistory{
    
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOneChatRoomList"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"failed to delete");
        }
    }
}


- (BOOL)saveChatFriendList:(NSArray *)arrChatFriendList{
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *insert;
    char *update = "insert into tbl_StepOneChatFriendList (block_status,chat_status,facebook_id,gcm_id,match_status,msg,msg_date,msg_type,mute_status,my_block_status,new_msg_cnt,open_chat,stepper_name,transaction_date,venue_id,venue_name) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, update, -1, &insert, nil) == SQLITE_OK) {
        for (NSDictionary *dict in arrChatFriendList) {
            NSString *block_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"block_status"]];
            NSString *chat_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"chat_status"]];
            NSString *facebook_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"facebook_id"]];
            NSString *gcm_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"gcm_id"]];
            NSString *match_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"match_status"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]];
            NSString *msg_date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msg_date"]];
            NSString *msg_type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msg_type"]];
            NSString *mute_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mute_status"]];
            NSString *my_block_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"my_block_status"]];
            NSString *new_msg_cnt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"new_msg_cnt"]];
            NSString *open_chat = [NSString stringWithFormat:@"%@",[dict objectForKey:@"open_chat"]];
            NSString *stepper_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"stepper_name"]];
            NSString *transaction_date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"transaction_date"]];
            NSString *venue_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"venue_id"]];
            NSString *venue_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"venue_name"]];
            sqlite3_bind_text(insert, 1, [block_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [chat_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [facebook_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 4, [gcm_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 5, [match_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 6, [msg UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 7, [msg_date UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 8, [msg_type UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 9, [mute_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 10, [my_block_status UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 11, [new_msg_cnt UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 12, [open_chat UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 13, [stepper_name UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 14, [transaction_date UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 15, [venue_id UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 16, [venue_name UTF8String], -1, NULL);
            if (sqlite3_step(insert) != SQLITE_DONE) // ALWAYS RETURNS Error: NULL
                NSLog(@"Error updating table: %s", sqlite3_errmsg(database));
            sqlite3_reset(insert);
        }
        sqlite3_finalize(insert);
    }
    sqlite3_close(database);
    NSLog(@"success");
    return YES;
}

- (NSMutableArray*)getAllChatFriendList{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select * from tbl_StepOneChatFriendList"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                
                NSString *block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *chat_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *gcm_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *match_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *msg_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *msg_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *mute_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *my_block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *new_msg_cnt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *open_chat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *stepper_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString *transaction_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString *venue_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString *venue_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",block_status] forKey:@"block_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",chat_status] forKey:@"chat_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",gcm_id] forKey:@"gcm_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",match_status] forKey:@"match_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",msg] forKey:@"msg"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",msg_date] forKey:@"msg_date"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",msg_type] forKey:@"msg_type"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",mute_status] forKey:@"mute_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",my_block_status] forKey:@"my_block_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",new_msg_cnt] forKey:@"new_msg_cnt"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",open_chat] forKey:@"open_chat"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",stepper_name] forKey:@"stepper_name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",transaction_date] forKey:@"transaction_date"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",venue_id] forKey:@"venue_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",venue_name] forKey:@"venue_name"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}

- (void)deleteOnlineStatusList{
    
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from tbl_OnlineStatus"];
        const char *insert_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
        }else {
            NSLog(@"failed to delete");
        }
    }
}

- (void)saveOnlineStatusList:(NSDictionary *)dictOnlineStatusList{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"SELECT * FROM tbl_OnlineStatus where facebook_id='%@'",[dictOnlineStatusList objectForKey:@"facebook_id"]];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [insertSQL UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *dateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",dateTime] forKey:@"dateTime"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    if ([array count]==0) {
        [self insertOnlineStatusList:dictOnlineStatusList];
    }else{
        [self updateOnlineStatusList:dictOnlineStatusList];
    }
    //return array;
}

- (void) updateOnlineStatusList:(NSDictionary *)dictOnlineStatusList{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE tbl_OnlineStatus SET status='%@',dateTime='%@' WHERE facebook_id='%@'",[dictOnlineStatusList objectForKey:@"status"],[dictOnlineStatusList objectForKey:@"dateTime"],[dictOnlineStatusList objectForKey:@"facebook_id"]];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //            NSLog(@"Success update in local db");
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else {
            NSLog(@"failed to insert in local db");
        }
    }
}

- (void)insertOnlineStatusList:(NSDictionary *)dictOnlineStatusList{
    
    //const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        char* errorMessage;
        sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
        NSString *insertSQL = [NSString stringWithFormat:@"insert into tbl_OnlineStatus (facebook_id,status,dateTime) values ('%@','%@','%@')",[dictOnlineStatusList objectForKey:@"facebook_id"],[dictOnlineStatusList objectForKey:@"status"],[dictOnlineStatusList objectForKey:@"dateTime"]];
        
        if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
        {
            NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
            //return NO;
        }
        // }
        sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    }
    NSLog(@"success dfdsf");
    //return YES;
    
}

- (NSMutableArray*)getAllOnlineStatusList{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_OnlineStatus"];
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *dateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",dateTime] forKey:@"dateTime"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}

- (NSMutableArray*)getOnlineStatusList:(NSString*)facebook_id{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_OnlineStatus where facebook_id = '%@'",facebook_id];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *dateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",dateTime] forKey:@"dateTime"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
    }
    return array;
}

- (void)saveChatRoomList:(NSArray *)arrChatFriendList FriendList:(NSString*)FriendID{
    
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from tbl_StepOneChatRoomList where friend_id = %@",FriendID];
        const char *insert_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"delete success");
            sqlite3_finalize(statement);
            [self SaveChatRoomListAfterOldRecordDeleted:arrChatFriendList FrindList:FriendID];
        }else {
            NSLog(@"failed to delete");
        }
    }
}

-(void)SaveChatRoomListAfterOldRecordDeleted:(NSArray *)arrChatFriendList FrindList:(NSString*)FriendID {
    
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *insert;
    char *update = "insert into tbl_StepOneChatRoomList (chat_key,chat_status,curTime, id,is_deleted,msg,imageAttachment,received_datetime,receiver_id,sender_id,sent_datetime,show_message,type,unique_msg_id,message_saved, friend_id) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, update, -1, &insert, nil) == SQLITE_OK) {
        for (NSDictionary *dict in arrChatFriendList) {
            NSString *curTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"curTime"]];
            NSString *message_saved = [dict objectForKey:@"message_saved"];
            if ([message_saved isEqualToString:@"0"]) {
                message_saved = @"0";
            }else{
                message_saved = @"1";
            }
            
            
            NSString *sent_datetime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sent_datetime"]];
            sqlite3_bind_text(insert, 1, [[dict objectForKey:@"chat_key"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [[dict objectForKey:@"chat_status"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [curTime UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 4, [[dict objectForKey:@"id"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 5, [[dict objectForKey:@"is_deleted"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 6, [[dict objectForKey:@"msg"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 7, [[dict objectForKey:@"imageAttachment"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 8, [[dict objectForKey:@"received_datetime"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 9, [[dict objectForKey:@"receiver_id"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 10, [[dict objectForKey:@"sender_id"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 11, [sent_datetime UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 12, [[dict objectForKey:@"showMessage"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 13, [[dict objectForKey:@"type"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 14, [[dict objectForKey:@"unique"] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 15, [message_saved UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 16, [FriendID  UTF8String], -1, NULL);
            
            sqlite3_bind_text(insert, 1, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"chat_key"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"chat_status"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 3, [[NSString stringWithFormat:@"%@",curTime] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 4, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 5, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"is_deleted"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 6, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 7, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageAttachment"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 8, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"received_datetime"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 9, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"receiver_id"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 10, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"sender_id"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 11, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"sent_datetime"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 12, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"showMessage"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 13, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 14, [[NSString stringWithFormat:@"%@",[dict objectForKey:@"unique"]] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 15, [[NSString stringWithFormat:@"%@",message_saved] UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 16, [[NSString stringWithFormat:@"%@",FriendID] UTF8String], -1, NULL);
            
            
            if (sqlite3_step(insert) != SQLITE_DONE) // ALWAYS RETURNS Error: NULL
                NSLog(@"Error updating table: %s", sqlite3_errmsg(database));
            sqlite3_reset(insert);
        }
        sqlite3_finalize(insert);
    }
    sqlite3_close(database);
    
}

- (NSMutableArray*)getAllChatRoomList:(NSString*)friend_id
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        //        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_StepOneChatRoomList where friend_id = '%@' ORDER BY friend_id DESC LIMIT 40",friend_id];
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_StepOneChatRoomList where friend_id = '%@'",friend_id];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *chat_key = ((char *)sqlite3_column_text(compiledStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] : nil;;
                NSString *chat_status = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                NSString *curTime = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                NSString *ID =((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                NSString *is_deleted = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                NSString *msg = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                NSString *imageAttachment= ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                NSString *received_datetime = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                NSString *receiver_id = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                NSString *sender_id = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                NSString *sent_datetime = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                NSString *show_message = ((char *)sqlite3_column_text(compiledStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] : nil;
                NSString *type = ((char *)sqlite3_column_text(compiledStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] : nil;
                NSString *unique = ((char *)sqlite3_column_text(compiledStatement, 13)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)] : nil;
                NSString *message_saved = ((char *)sqlite3_column_text(compiledStatement, 14)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)] : nil;
                NSString *friend_ID = ((char *)sqlite3_column_text(compiledStatement, 15)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)] : nil;
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",chat_key] forKey:@"chat_key"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",chat_status] forKey:@"chat_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",curTime] forKey:@"curTime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",is_deleted] forKey:@"is_deleted"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",msg] forKey:@"msg"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",imageAttachment] forKey:@"imageAttachment"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",received_datetime] forKey:@"received_datetime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",receiver_id] forKey:@"receiver_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",sender_id] forKey:@"sender_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",sent_datetime] forKey:@"sent_datetime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",show_message] forKey:@"show_message"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",type] forKey:@"type"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",unique] forKey:@"unique"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",message_saved] forKey:@"message_saved"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",friend_ID] forKey:@"friend_id"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    return array;
}

- (NSMutableArray*)getChatRoomListForSpecificID:(NSString*)UniqueID{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_StepOneChatRoomList where unique_msg_id = '%@'",UniqueID];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *chat_key = ((char *)sqlite3_column_text(compiledStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] : nil;;
                NSString *chat_status = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                NSString *curTime = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                NSString *ID =((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                NSString *is_deleted = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                NSString *msg = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                NSString *imageAttachment= ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                NSString *received_datetime = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                NSString *receiver_id = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                NSString *sender_id = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                NSString *sent_datetime = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                NSString *show_message = ((char *)sqlite3_column_text(compiledStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] : nil;
                NSString *type = ((char *)sqlite3_column_text(compiledStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] : nil;
                NSString *unique = ((char *)sqlite3_column_text(compiledStatement, 13)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)] : nil;
                NSString *message_saved = ((char *)sqlite3_column_text(compiledStatement, 14)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)] : nil;
                NSString *friend_ID = ((char *)sqlite3_column_text(compiledStatement, 15)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)] : nil;
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",chat_key] forKey:@"chat_key"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",chat_status] forKey:@"chat_status"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",curTime] forKey:@"curTime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",is_deleted] forKey:@"is_deleted"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",msg] forKey:@"msg"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",imageAttachment] forKey:@"imageAttachment"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",received_datetime] forKey:@"received_datetime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",receiver_id] forKey:@"receiver_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",sender_id] forKey:@"sender_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",sent_datetime] forKey:@"sent_datetime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",show_message] forKey:@"show_message"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",type] forKey:@"type"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",unique] forKey:@"unique"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",message_saved] forKey:@"message_saved"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",friend_ID] forKey:@"friend_id"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    return array;
}

- (NSMutableArray*)fetchDataFromfbTable{
    NSMutableArray *arrayGet = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select * from fbTable"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionaryGet=[[NSMutableDictionary alloc] init];
                
                NSString *block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *chat_status = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 1)];
                NSString *gcm_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *match_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *msg = [NSString stringWithUTF8String:(char *)
                                 sqlite3_column_text(compiledStatement, 4)];
                NSString *msg_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *msg_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *mute_status = [NSString stringWithUTF8String:(char *)
                                         sqlite3_column_text(compiledStatement, 7)];
                NSString *my_block_status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *new_msg_cnt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *open_chat = [NSString stringWithUTF8String:(char *)
                                       sqlite3_column_text(compiledStatement, 10)];
                NSString *stepper_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *stepper_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString *transaction_date = [NSString stringWithUTF8String:(char *)
                                              sqlite3_column_text(compiledStatement, 13)];
                NSString *venue_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString *venue_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                
                
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",block_status] forKey:@"block_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",chat_status] forKey:@"chat_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",gcm_id] forKey:@"gcm_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",match_status] forKey:@"match_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg] forKey:@"msg"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg_date] forKey:@"msg_date"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",msg_type] forKey:@"msg_type"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",mute_status] forKey:@"mute_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",my_block_status] forKey:@"my_block_status"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",new_msg_cnt] forKey:@"new_msg_cnt"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",open_chat] forKey:@"open_chat"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",stepper_id] forKey:@"stepper_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",stepper_name] forKey:@"stepper_name"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",transaction_date] forKey:@"transaction_date"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",venue_id] forKey:@"venue_id"];
                [dataDictionaryGet setObject:[NSString stringWithFormat:@"%@",venue_name] forKey:@"venue_name"];
                
                [arrayGet addObject:dataDictionaryGet];
                
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return arrayGet;
}

- (NSString *) validateNilString:(NSString *)strValue {
    
    NSString *returnString = @"";
    
    @try {
        if (!strValue)
            return returnString;
        
        if ([strValue isKindOfClass:[NSNull class]])
            return returnString;
        
        if ([strValue isEqualToString:@"<nil>"])
            return returnString;
        
        if ([strValue isEqualToString:@"<null>"])
            return returnString;
        
        if ([strValue isEqualToString:@"NULL"])
            return returnString;
        
        if ([strValue isEqualToString:@"nil"])
            return returnString;
        
        if ([strValue isEqualToString:@"(null)"])
            return returnString;
        
        return strValue;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",exception);
        return returnString;
    }
}


- (NSMutableArray*)getAllUnreadChatMessages:(NSString*)facebook_id{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_UnreadChatMessages where facebook_id = %@",facebook_id];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *unread_count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",unread_count] forKey:@"unread_count"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}

- (NSMutableArray*)getAllUnreadChatMessages
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_UnreadChatMessages"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *facebook_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *unread_count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",facebook_id] forKey:@"facebook_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",unread_count] forKey:@"unread_count"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    // sqlite3_close(database);
    return array;
}


- (BOOL)saveAllUnreadChatMessages:(NSArray *)arrUnreadChatMessagesList{
    
    //const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        char* errorMessage;
        sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
        for (NSDictionary *dict in arrUnreadChatMessagesList) {
            NSString *insertSQL = [NSString stringWithFormat:@"insert into tbl_UnreadChatMessages (facebook_id,unread_count) values ('%@','%@')",[dict objectForKey:@"facebook_id"],[dict objectForKey:@"unread_count"]];
            if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
            {
                NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
                return NO;
            }
        }
        sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    }
    
    return YES;
    
}

- (void)deleteAlreadyReadMessages:(NSString*)facebook_id{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from tbl_UnreadChatMessages where facebook_id = %@",facebook_id];
        const char *insert_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
            // sqlite3_close(database);
        }else {
            NSLog(@"failed to delete");
        }
    }
}

- (NSString *)getTrueFalseByValue:(NSString *)value {
    if ([value isEqualToString:@"1"])
        return @"true";
    else
        return @"false";
}

- (void)updateSettingByKey:(NSString *)key Value:(NSString *)valu {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE tbl_Settings SET %@ = '%@' WHERE rowid = 1",key, valu];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //            NSLog(@"Success update in local db");
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else {
            NSLog(@"failed to insert in local db");
        }
    }
}

- (NSMutableArray*)getCheckInPlaceIdAndNames{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        //        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_CheckInPlaces order by ID desc "];
        //        NSString *sqlStatement_userInfo = [NSString stringWithFormat:@"select PlaceID,PlaceName from tbl_CheckInPlaces where CurrentStatus = 3"];
        
        //SELECT labs.* FROM labs INNER JOIN visit ON visit.id = labs.visitID AND patientID = ?
        
        //        NSString *sqlStatement_userInfo = [NSString stringWithFormat:@"select PlaceID,PlaceName,CheckInTime,CheckOutTime from tbl_CheckInPlaces OUTER JOIN tbl_CheckInTimeInOut where tbl_CheckInPlaces.CurrentStatus = 3 AND tbl_CheckInPlaces.PlaceID = tbl_CheckInTimeInOut.PlaceID"];
        NSString *sqlStatement_userInfo = [NSString stringWithFormat:@"select PlaceID,PlaceName,PlaceAddress from tbl_CheckInPlaces where CurrentStatus = 3"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"PlaceID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"PlaceName"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"PlaceAddress"];
                [array addObject:dataDictionary];
            }
        }else{
            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
        }
        sqlite3_busy_timeout(database, 500);
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return array;
}


- (NSMutableArray*)getCheckInAndCheckOutTime{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        //        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_CheckInPlaces order by ID desc "];
        NSString *sqlStatement_userInfo = [NSString stringWithFormat:@"select CheckInTime,CheckOutTime,CheckInPlaceID from tbl_CheckInTimeInOut"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *CheckInTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *CheckOutTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *CheckInPlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CheckInTime] forKey:@"CheckInTime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CheckOutTime] forKey:@"CheckOutTime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CheckInPlaceID] forKey:@"CheckInPlaceID"];
                [array addObject:dataDictionary];
            }
        }else{
            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
        }
        sqlite3_busy_timeout(database, 500);
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return array;
}

- (NSMutableDictionary*)getSettingsDetails{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"select * from tbl_Settings"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableDictionary *resultArray = [[NSMutableDictionary alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *Men = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                [resultArray setObject:Men forKey:@"Men"];
                NSString *Women = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 1)];
                [resultArray setObject:Women forKey:@"Women"];
                NSString *Friendship = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                [resultArray setObject:Friendship forKey:@"MenAndWomen"];
                NSString *LowerAgeRange = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 3)];
                [resultArray setObject:LowerAgeRange forKey:@"LowerAgeRange"];
                
                NSString *UpperAgeRange = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 4)];
                [resultArray setObject:UpperAgeRange forKey:@"UpperAgeRange"];
                NSString *OpenChat = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 5)];
                [resultArray setObject:OpenChat forKey:@"OpenChat"];
                NSString *AutoCheckIn = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 6)];
                [resultArray setObject:AutoCheckIn forKey:@"AutoCheckIn"];
                NSString *VisibleOutsideVenue = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 7)];
                [resultArray setObject:VisibleOutsideVenue forKey:@"VisibleOutsideVenue"];
                NSString *ShowVisible = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 8)];
                [resultArray setObject:ShowVisible forKey:@"ShowVisible"];
                NSString *SteppersAttending = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 9)];
                [resultArray setObject:SteppersAttending forKey:@"SteppersAttending"];
                NSString *ShowAge = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 10)];
                [resultArray setObject:ShowAge forKey:@"ShowAge"];
                NSString *ShowHomeTown = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 11)];
                [resultArray setObject:ShowHomeTown forKey:@"ShowHomeTown"];
                NSString *ShowFacebookInterests = [[NSString alloc] initWithUTF8String:
                                                   (const char *) sqlite3_column_text(statement, 12)];
                [resultArray setObject:ShowFacebookInterests forKey:@"ShowFacebookInterests"];
                NSString *ShowInstagramID = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 13)];
                [resultArray setObject:ShowInstagramID forKey:@"ShowInstagramID"];
                NSString *ShowInstagramPhotos = [[NSString alloc] initWithUTF8String:
                                                 (const char *) sqlite3_column_text(statement, 14)];
                [resultArray setObject:ShowInstagramPhotos forKey:@"ShowInstagramPhotos"];
                NSString *ShowMobileContact = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 15)];
                [resultArray setObject:ShowMobileContact forKey:@"ShowMobileContact"];
                NSString *ShowEmailContact = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 16)];
                [resultArray setObject:ShowEmailContact forKey:@"ShowEmailContact"];
                NSString *ShowEmployer = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 17)];
                [resultArray setObject:ShowEmployer forKey:@"ShowEmployer"];
                NSString *showWork = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 18)];
                [resultArray setObject:showWork forKey:@"showWork"];
                NSString *ShowSchool = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 19)];
                [resultArray setObject:ShowSchool forKey:@"ShowSchool"];
                NSString *NewMatch = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 20)];
                [resultArray setObject:NewMatch forKey:@"NewMatch"];
                NSString *Chats = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 21)];
                [resultArray setObject:Chats forKey:@"Chats"];
                NSString *showPlaces = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 22)];
                [resultArray setObject:showPlaces forKey:@"showPlaces"];
                sqlite3_finalize(statement);
                //  sqlite3_close(database);
                return resultArray;
            }else{
                NSLog(@"Not found");
                return nil;
            }
        }
    }
    return nil;
}

#pragma mark - FB user profile

- (void) delete_tbl_FBProfile {
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_FBUserDetail"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            //            NSLog(@"delete profile from local db success");
        }
        else {
            NSLog(@"failed to delete profile in local db");
        }
    }
}

- (BOOL)insertFBdetails:(NSMutableDictionary*)dicUserDetail{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        char* errorMessage;
        sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
        NSString *str_facebook_id = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"facebook_id"]];
        NSString *str_name = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"name"]];
        NSString *str_email = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"email"]];
        NSString *str_gender = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"gender"]];
        NSString *str_dob = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"dob"]];
        NSString *str_photo = [dicUserDetail objectForKey:@"photo"];
        NSString *str_about_me = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"about_me"]];
        str_about_me=[str_about_me stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *str_school = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"school"]];
        str_school=[str_school stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *str_job = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"job"]];
        NSString *str_employer = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"employer"]];
        str_employer=[str_employer stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *str_interest = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"interest"]];
        str_interest = [str_interest stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *str_mobile = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"mobile"]];
        NSString *str_gcm_id = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"gcm_id"]];
        NSString *str_InstagramId = [NSString stringWithFormat:@"%@", @"InstagramId"];
        NSString *str_FBRelationship = [NSString stringWithFormat:@"%@", @"FBRelationship"];
        NSString *str_birthDay = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"birthDay"]];
        NSString *str_hometown = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"hometown"]];
        NSString *str_location = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"location"]];
        NSString *query = [NSString stringWithFormat:@"INSERT INTO tbl_FBUserDetail (facebook_id, name, email, gender, dob, photo, about_me, school, job, employer, interest, mobile, gcm_id, InstagramId, FBRelationship, birthDay,Hometown,Location) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",str_facebook_id, str_name, str_email, str_gender, str_dob, str_photo, str_about_me, str_school, str_job, str_employer, str_interest, str_mobile, str_gcm_id, str_InstagramId, str_FBRelationship, str_birthDay,str_hometown,str_location];
        if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
            NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
            return NO;
        }
        sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    }
    return YES;
}

- (BOOL)updateFBdetails:(NSMutableDictionary*)dicUserDetail {
    NSString *str_facebook_id = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"facebook_id"]];
    NSString *str_name = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"name"]];
    NSString *str_email = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"email"]];
    NSString *str_gender = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"gender"]];
    NSString *str_dob = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"dob"]];
    NSString *str_birthDay = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"birthDay"]];
    NSString *str_photo = [dicUserDetail objectForKey:@"photo"];
    NSString *str_about_me = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"about_me"]];
    str_about_me=[str_about_me stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *str_school = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"school"]];
    NSString *str_job = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"job"]];
    NSString *str_employer = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"employer"]];
    NSString *str_interest = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"interest"]];
    str_interest = [str_interest stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *str_mobile = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"mobile"]];
    NSString *str_gcm_id = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"gcm_id"]];
    NSString *str_InstagramId = [NSString stringWithFormat:@"%@", @""];
    NSString *str_FBRelationship = [NSString stringWithFormat:@"%@", @""];
    NSString *str_hometown = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"hometown"]];
    NSString *str_location = [NSString stringWithFormat:@"%@", [dicUserDetail objectForKey:@"location"]];
    NSString *query = [NSString stringWithFormat:@"UPDATE tbl_FBUserDetail SET facebook_id = '%@', name = '%@', email = '%@', gender = '%@', dob = '%@', photo = '%@', about_me = '%@', school = '%@', job = '%@', employer = '%@', interest = '%@', mobile = '%@', gcm_id = '%@', InstagramId = '%@', FBRelationship = '%@', birthDay = '%@',Hometown = '%@', Location = '%@' WHERE rowid = 1",str_facebook_id, str_name, str_email, str_gender, str_dob, str_photo, str_about_me, str_school, str_job, str_employer, str_interest, str_mobile, str_gcm_id, str_InstagramId, str_FBRelationship, str_birthDay,str_hometown,str_location];
    [self executeQuery:query];
    return NO;
    
}

- (void)updateFBDetailByKey:(NSString *)key Value:(NSString *)valu {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE tbl_FBUserDetail SET %@ = '%@' WHERE rowid = 1",key, valu];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //            NSLog(@"Success update in local db");
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else {
            NSLog(@"failed to insert in local db");
        }
    }
}

-(void)executeQuery:(NSString *)query {
    sqlite3_stmt *statement;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_finalize(statement);
            }
        }else {
            //        NSLog(@"query Statement Not Compiled");
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }else{
        NSLog(@"Data not Opened");
    }
}

-(NSMutableDictionary*) getFBProfile {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"select * from tbl_FBUserDetail"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableDictionary *resultArray = [[NSMutableDictionary alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *FBid = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBid] forKey:@"facebook_id"];
                NSString *FBName = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBName] forKey:@"name"];
                NSString *FBMail = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 2)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBMail] forKey:@"email"];
                NSString *FBGender = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBGender] forKey:@"gender"];
                NSString *FBDOB = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 4)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBDOB] forKey:@"dob"];
                NSString *FBProifleImage = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBProifleImage] forKey:@"photo"];
                NSString *FBBio = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 6)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBBio] forKey:@"about_me"];
                NSString *FBSchoolName = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 7)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBSchoolName] forKey:@"school"];
                NSString *FBJob = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 8)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBJob] forKey:@"job"];
                NSString *FBEmployee = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 9)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBEmployee] forKey:@"employer"];
                NSString *FBInterest = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 10)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBInterest] forKey:@"interest"];
                NSString *FBContact = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 11)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBContact] forKey:@"mobile"];
                NSString *gcm_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 12)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",gcm_id] forKey:@"gcm_id"];
                //                NSString *InstagramId = [[NSString alloc] initWithUTF8String:
                //                                         (const char *) sqlite3_column_text(statement, 13)];
                NSString *FBRelationship = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 14)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",FBRelationship] forKey:@"FBRelationship"];
                NSString *birthDay = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 15)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",birthDay] forKey:@"birthDay"];
                NSString *hometown = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 16)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",hometown] forKey:@"hometown"];
                NSString *location = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 17)];
                [resultArray setObject:[NSString stringWithFormat:@"%@",location] forKey:@"location"];
                sqlite3_finalize(statement);
                return resultArray;
            }else{
                NSLog(@"Not found");
                return nil;
            }
        }
        //        NSLog(@"all array %@",resultArray);
    }
    return nil;
}

#pragma mark
#pragma mark Home Database actions



- (void) deleteAllRowsIn_tbl_NearbyPlaces{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_NearbyPlaces"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete deleteAllRowsIn_tbl_NearbyPlaces");
            sqlite3_finalize(statement);
        }else{
            NSLog(@"failed to delete deleteAllRowsIn_tbl_NearbyPlaces");
        }
    }
}

- (NSMutableArray*)getAllDetailsFrom_tbl_NearbyPlaces{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        // Setup the SQL Statement and compile it for faster access
        //Where PlaceDistance  BETWEEN '0' AND '100'
        //SQLIte Statement
        //order by PlaceDistance asc
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_NearbyPlaces order by cast(PlaceDistance as REAL) asc"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceDistance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *PlaceIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                //                NSUInteger blobLength = sqlite3_column_bytes(compiledStatement, 10);
                //                NSData *data = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 10) length:blobLength];
                NSString *opening_days = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *opening_time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                //
                //                NSDictionary *dictionary=[NSJSONSerialization
                //                                          JSONObjectWithData:data
                //                                          options:kNilOptions
                //                                          error:nil];
                //                id json = [NSJSONSerialization JSONObjectWithData:data
                //                                                          options:0 error:nil];
                //
                //
                ////                NSData* data = [venue_timing dataUsingEncoding:NSUTF8StringEncoding];
                ////
                //                NSDictionary *myArrayFromDB = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"place_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"formatted_phone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"vicinity"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceDistance] forKey:@"distance"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"latitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"longitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceIcon] forKey:@"photo_ref"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",description] forKey:@"description"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",opening_days] forKey:@"opening_days"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",opening_time] forKey:@"opening_time"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",website] forKey:@"website"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
    }
    return array;
}



#pragma mark - tbl_CheckInPlaces

- (BOOL) insertIn_tbl_CheckInPlaces:(NSMutableDictionary*)arrayData{
    NSString *placeId = [arrayData valueForKey:@"PlaceID"];
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        char* errorMessage;
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_CheckInPlaces Where PlaceID = \"%@\"",placeId];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            NSString *query = [NSString stringWithFormat:@"insert into tbl_CheckInPlaces (PlaceID,PlaceName,PlacePhone,PlaceAddress,PlaceCity,PlaceDistance,PlaceLat,Placelng,PlaceIcon,Date,CurrentStatus) values (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",[arrayData valueForKey:@"PlaceID"],[arrayData valueForKey:@"PlaceName"],[arrayData valueForKey:@"PlacePhone"],[arrayData valueForKey:@"PlaceAddress"],[arrayData valueForKey:@"PlaceCity"],[arrayData valueForKey:@"PlaceDistance"],[arrayData valueForKey:@"PlaceLat"],[arrayData valueForKey:@"Placelng"],[arrayData valueForKey:@"PlaceIcon"],[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"CurrentStatus"]];
            if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
                NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
                return NO;
            }else{
                NSString *query2 = [NSString stringWithFormat:@"insert into tbl_CheckInTimeInOut (CheckInTime,CheckOutTime,CheckInPlaceID) values (\"%@\",'0',\"%@\")",[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"PlaceID"]];
                
                if (sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
                    NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
                    return NO;
                }else{
                    //                    NSLog(@"inserted successfully");
                }
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }else{
            NSLog(@"failed to delete");
            //            NSString *query = [NSString stringWithFormat:@"insert into tbl_CheckInPlaces (PlaceID,PlaceName,PlacePhone,PlaceAddress,PlaceCity,PlaceDistance,PlaceLat,Placelng,PlaceIcon,Date,CurrentStatus) values (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",[arrayData valueForKey:@"PlaceID"],[arrayData valueForKey:@"PlaceName"],[arrayData valueForKey:@"PlacePhone"],[arrayData valueForKey:@"PlaceAddress"],[arrayData valueForKey:@"PlaceCity"],[arrayData valueForKey:@"PlaceDistance"],[arrayData valueForKey:@"PlaceLat"],[arrayData valueForKey:@"Placelng"],[arrayData valueForKey:@"PlaceIcon"],[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"CurrentStatus"]];
            //
            //            if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
            //            {
            //                NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
            //                return NO;
            //            }
            //            else
            //            {
            //                NSString *query2 = [NSString stringWithFormat:@"insert into tbl_CheckInTimeInOut (CheckInTime,CheckOutTime,CheckInPlaceID) values (\"%@\",'0',\"%@\")",[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"PlaceID"]];
            //
            //                if (sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
            //                {
            //                    NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
            //                    return NO;
            //                }
            //                else
            //                {
            //                    NSLog(@"inserted successfully");
            //                }
            //            }
            //
            //            sqlite3_finalize(statement);
            //            sqlite3_close(database);
            //
        }
    }
    return false;
    
    /*    sqlite3 *database;
     
     NSString *placeId= [arrayData valueForKey:@"PlaceID"];
     if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
     {
     char* errorMessage;
     
     NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_CheckInPlaces Where  PlaceID = \"%@\"",placeId];
     
     sqlite3_stmt *compiledStatement;
     if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
     {
     
     // Loop through the results and add them to the feeds array
     if(sqlite3_step(compiledStatement) == SQLITE_ROW)
     {
     NSLog(@"Row exit");
     
     // if place/venue already exist in checkIn places table
     
     NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_CheckInPlaces Where PlaceID = \"%@\"",placeId];
     
     const char *insert_stmt = [insertSQL UTF8String];
     sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
     if (sqlite3_step(statement) == SQLITE_DONE)
     {
     NSLog(@"delete success");
     
     sqlite3_finalize(statement);
     // sqlite3_close(database);
     }
     else {
     NSLog(@"failed to delete");
     }
     
     
     
     const char *sql = "update tbl_CheckInPlaces Set CurrentStatus = ? , Date = ? where PlaceID = ?";
     if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL)==SQLITE_OK)
     {
     sqlite3_bind_text(compiledStatement, 1, [[arrayData objectForKey:@"CurrentStatus"] UTF8String], -1, SQLITE_TRANSIENT); //1
     sqlite3_bind_text(compiledStatement, 2, [[arrayData objectForKey:@"Date"] UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(compiledStatement, 3, [[arrayData objectForKey:@"PlaceID"] UTF8String], -1, SQLITE_TRANSIENT);
     
     if(SQLITE_DONE != sqlite3_step(compiledStatement))
     {
     NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
     }
     else
     {
     NSString *query2 = [NSString stringWithFormat:@"insert into tbl_CheckInTimeInOut (CheckInTime,CheckOutTime,CheckInPlaceID) values (\"%@\",'0',\"%@\")",[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"PlaceID"]];
     
     if (sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
     {
     NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
     return NO;
     }
     else
     {
     NSLog(@"inserted successfully");
     
     }
     
     }
     
     }
     
     
     
     
     
     }
     else
     {
     NSLog(@"not exist");
     
     NSString *query = [NSString stringWithFormat:@"insert into tbl_CheckInPlaces (PlaceID,PlaceName,PlacePhone,PlaceAddress,PlaceCity,PlaceDistance,PlaceLat,Placelng,PlaceIcon,Date,CurrentStatus) values (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",[arrayData valueForKey:@"PlaceID"],[arrayData valueForKey:@"PlaceName"],[arrayData valueForKey:@"PlacePhone"],[arrayData valueForKey:@"PlaceAddress"],[arrayData valueForKey:@"PlaceCity"],[arrayData valueForKey:@"PlaceDistance"],[arrayData valueForKey:@"PlaceLat"],[arrayData valueForKey:@"Placelng"],[arrayData valueForKey:@"PlaceIcon"],[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"CurrentStatus"]];
     
     if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
     {
     NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
     return NO;
     }
     else
     {
     NSString *query2 = [NSString stringWithFormat:@"insert into tbl_CheckInTimeInOut (CheckInTime,CheckOutTime,CheckInPlaceID) values (\"%@\",'0',\"%@\")",[arrayData valueForKey:@"Date"],[arrayData valueForKey:@"PlaceID"]];
     
     if (sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK)
     {
     NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
     return NO;
     }
     else
     {
     NSLog(@"inserted successfully");
     }
     }
     
     }
     
     sqlite3_busy_timeout(database, 500);
     
     sqlite3_finalize(compiledStatement);
     sqlite3_close(database);
     
     }
     else
     {
     NSLog(@"No Data Found '%s'", sqlite3_errmsg(database));
     
     }
     
     // Release the compiled statement from memory
     
     }
     
     return false;
     */
    
}

- (NSMutableArray*)getAllDetailsFrom_tbl_CheckInPlaces{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_CheckInPlaces order by ID desc "];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            //
            //            ID INTEGER PRIMARY KEY AUTOINCREMENT,PlaceID TEXT,PlaceName text,PlacePhone Text,PlaceAddress Text, PlaceCity Text,PlaceDistance Text, PlaceLat Text , Placelng Text,PlaceIcon Text,Date Text,Time Text,CurrentStatus Text
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceCity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *PlaceDistance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *PlaceIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *Date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"PlaceName"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"PlaceID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"PlacePhone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"PlaceAddress"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceCity] forKey:@"PlaceCity"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceDistance] forKey:@"PlaceDistance"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"PlaceLat"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"Placelng"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceIcon] forKey:@"PlaceIcon"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Date] forKey:@"Date"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
                [array addObject:dataDictionary];
            }
        }else{
            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
        }
        sqlite3_busy_timeout(database, 500);
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return array;
}

- (NSMutableDictionary*)getLastInsertedRowFrom_tbl_CheckInPlaces{
    NSMutableDictionary *resultArray = [[NSMutableDictionary alloc]init];
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"Select * from tbl_CheckInPlaces WHERE CurrentStatus = '2'"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [resultArray setObject:PlaceID forKey:@"PlaceID"];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [resultArray setObject:PlaceName forKey:@"PlaceName"];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [resultArray setObject:ID forKey:@"ID"];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                [resultArray setObject:PlaceLat forKey:@"PlaceLat"];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                [resultArray setObject:Placelng forKey:@"Placelng"];
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return resultArray;
            }else{
                NSLog(@"Not found");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return resultArray;
}


-(BOOL)updateCheckOut_tbl_CheckInPlaces:(NSMutableDictionary*)arrayData{
    sqlite3_stmt *updateStmt;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        //        sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errmsg);
        const char *sql = "update tbl_CheckInPlaces Set CurrentStatus = ? where PlaceID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(updateStmt, 1, [[arrayData objectForKey:@"CurrentStatus"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(updateStmt, 2, [[arrayData objectForKey:@"PlaceID"] UTF8String], -1, SQLITE_TRANSIENT);
            if(SQLITE_DONE != sqlite3_step(updateStmt)){
                NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
            }else{
                //                const char *sql2 = "update tbl_CheckInTimeInOut Set CheckOutTime = ? where CheckInPlaceID = ?";
                //
                //                if(sqlite3_prepare_v2(database, sql2, -1, &updateStmt, NULL)==SQLITE_OK)
                //                {
                //                    sqlite3_bind_text(updateStmt, 1, [[arrayData objectForKey:@"Date"] UTF8String], -1, SQLITE_TRANSIENT);
                //                    sqlite3_bind_text(updateStmt, 2, [[arrayData objectForKey:@"PlaceID"] UTF8String], -1, SQLITE_TRANSIENT);
                //
                //                    if(SQLITE_DONE != sqlite3_step(updateStmt)){
                //                        NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
                //                    }
                //                    else
                //                    {
                //                        NSLog(@"suces");
                //                    }
                //
                //                }
            }
        }else{
            NSLog(@"FAIL");
        }
        sqlite3_busy_timeout(database, 500);
        // sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errmsg);
        sqlite3_finalize(updateStmt);
        sqlite3_close(database);
    }else{
        NSLog(@"No Data Found %s", sqlite3_errmsg(database));
    }
    return NO;
}

#pragma mark - tbl_CheckInTimeInOut
-(BOOL)updateCheckOut_tbl_CheckInTimeInOut:(NSMutableDictionary*)arrayData{
    sqlite3_stmt *updateStmt;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        // sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errmsg);
        const char *sql2 = "update tbl_CheckInTimeInOut Set CheckOutTime = ? where ID = ?";
        if(sqlite3_prepare_v2(database, sql2, -1, &updateStmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(updateStmt, 1, [[arrayData objectForKey:@"Date"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(updateStmt, 2, [[arrayData objectForKey:@"ID"] UTF8String], -1, SQLITE_TRANSIENT);
            if(SQLITE_DONE != sqlite3_step(updateStmt)){
                NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
            }else{
                //                NSLog(@"suces");
            }
        }else{
            NSLog(@"FAIL");
        }
        sqlite3_busy_timeout(database, 500);
        sqlite3_finalize(updateStmt);
        sqlite3_close(database);
        //  sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errmsg);
    }else{
        NSLog(@"No Data Found %s", sqlite3_errmsg(database));
    }
    return NO;
}

- (NSMutableArray*)getAllDetails_tbl_CheckInTimeInOut : (NSString*)PlaceID{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_CheckInTimeInOut WHERE CheckInPlaceID =\"%@\"",PlaceID];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *CheckInTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *CheckOutTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CheckInTime] forKey:@"CheckInTime"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CheckOutTime] forKey:@"CheckOutTime"];
                [array addObject:dataDictionary];
            }
        }else{
            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
        }
        sqlite3_busy_timeout(database, 500);
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return array;
}

#pragma mark - tbl_StepOnOff

- (NSMutableArray*)getCheckInPlaceByCurrentStatus {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"Select * from tbl_StepOnOff WHERE CurrentStatus = '2'"];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *Date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                //PlaceID,PlaceName,PlacePhone,PlaceAddress, PlaceLat, Placelng,CurrentStatus,Date
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"PlaceID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"PlaceName"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"PlacePhone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"PlaceAddress"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"PlaceLat"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"Placelng"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Date] forKey:@"Date"];
                [array addObject:dataDictionary];
                sqlite3_finalize(compiledStatement);
                sqlite3_close(database);
                return array;
            }
            else{
                NSLog(@"Not found");
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database);
    }
    return array;
}


- (NSMutableArray*)getCheckInPlaceByPlaceId:(NSString *)placeID {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"Select * from tbl_StepOnOff WHERE PlaceID =\"%@\"", placeID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *Date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                //PlaceID,PlaceName,PlacePhone,PlaceAddress, PlaceLat, Placelng,CurrentStatus,Date
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"PlaceID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"PlaceName"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"PlacePhone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"PlaceAddress"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"PlaceLat"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"Placelng"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Date] forKey:@"Date"];
                [array addObject:dataDictionary];
                sqlite3_finalize(compiledStatement);
                sqlite3_close(database);
                return array;
            }
            else{
                NSLog(@"Not found");
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database);
    }
    return array;
}


-(BOOL) insertIn_tbl_StepOnOff:(NSMutableDictionary*)arrayData{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"insert into tbl_StepOnOff (PlaceID,PlaceName,PlacePhone,PlaceAddress,PlaceLat, Placelng,Distance,PlaceIcon,CurrentStatus,Date) values (\"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\",datetime('now','localtime'))",[arrayData valueForKey:@"place_id"],[arrayData valueForKey:@"name"],[arrayData valueForKey:@"formatted_phone"],[arrayData valueForKey:@"vicinity"],[arrayData valueForKey:@"latitude"],[arrayData valueForKey:@"longitude"],[arrayData valueForKey:@"distance"],[arrayData valueForKey:@"photo_ref"],[arrayData valueForKey:@"CurrentStatus"]];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }else {
            NSLog(@"failed to insert");
            return NO;
        }
    }
    return NO;
}

- (BOOL)CheckValueExit_tbl_StepOnOff:(NSString*)PlaceID{
    sqlite3 *database;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"Select * from tbl_StepOnOff WHERE PlaceID =\"%@\"",PlaceID];
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT EXISTS(SELECT COUNT(*) FROM tbl_StepOnOff WHERE PlaceID = \"%@\" LIMIT 1)",PlaceID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return true;
            }else{
                NSLog(@"Not found");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return false;
}

- (void) deleteStepOffRow_tbl_StepOnOff:(NSString *)PlaceID{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOnOff WHERE PlaceID =\"%@\"",PlaceID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
        }else {
            NSLog(@"failed to delete");
        }
    }
}

- (void) deleteCheckInRow_tbl_StepOnOff{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        // NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOnOff WHERE CurrentStatus = '2' AND PlaceID =\"%@\"",PlaceID];
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_StepOnOff WHERE CurrentStatus = '2' "];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
            // sqlite3_close(database);
        }
        else {
            NSLog(@"failed to delete");
        }
    }
    
}


- (void) deleteOlderThenOneDayRow_tbl_StepOnOff{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM tbl_StepOnOff WHERE Date <= datetime('now', '-1440 minutes')"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }else {
            NSLog(@"failed to delete");
        }
    }
}

//  -- > old version ///

//- (NSMutableArray*)getAllDetailsFrom_tbl_StepOnOff
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//
//    // Setup the database object
//    sqlite3 *database;
//
//    // Open the database from the users filessytem
//    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
//    {
//        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_StepOnOff"];
//
//        sqlite3_stmt *compiledStatement;
//
//
//        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            // PlaceID,PlaceName,PlacePhone,PlaceAddress, PlaceCity,PlaceDistance, PlaceLat, Placelng,CurrentStatus,StepOnTime
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//
//                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
//
//                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
//                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
//                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
//                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
//                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
//                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
//                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
//                NSString *PlaceIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
//                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
//                NSString *StepOnTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
//
//
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"PlaceName"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"PlaceID"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"PlacePhone"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"PlaceAddress"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"PlaceLat"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"Placelng"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceIcon] forKey:@"PlaceIcon"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
//                [dataDictionary setObject:[NSString stringWithFormat:@"%@",StepOnTime] forKey:@"Date"];
//
//                [array addObject:dataDictionary];
//            }
//
//        }
//        else
//        {
//            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
//        }
////        sqlite3_busy_timeout(database, 500);
//
//        // Release the compiled statement from memory
//        sqlite3_finalize(compiledStatement);
//        sqlite3_close(database);
//
//    }
//
//
//
//    return array;
//}

- (NSMutableArray*)getAllDetailsFrom_tbl_StepOnOff{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_StepOnOff"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            // PlaceID,PlaceName,PlacePhone,PlaceAddress, PlaceCity,PlaceDistance, PlaceLat, Placelng,CurrentStatus,StepOnTime
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *Distance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *PlaceIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *StepOnTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"place_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"formatted_phone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"vicinity"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"latitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"longitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Distance] forKey:@"distance"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceIcon] forKey:@"photo_ref"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",StepOnTime] forKey:@"Date"];
                [array addObject:dataDictionary];
            }
        }else{
            NSLog(@"No Data Found %s", sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return array;
}

-(NSMutableArray*)getStepOnPlaceDetail_tbl_StepOnOff:(NSString*)PlaceID{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"Select * from tbl_StepOnOff WHERE PlaceID =\"%@\"",PlaceID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK){
            if (sqlite3_step(compiledStatement) == SQLITE_ROW){
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *PlaceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *PlaceName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *PlacePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PlaceAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *PlaceLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *Placelng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *Distance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *PlaceIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *CurrentStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *StepOnTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceName] forKey:@"name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceID] forKey:@"place_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlacePhone] forKey:@"formatted_phone"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceAddress] forKey:@"vicinity"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceLat] forKey:@"latitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Placelng] forKey:@"longitude"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",Distance] forKey:@"distance"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",PlaceIcon] forKey:@"photo_ref"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",CurrentStatus] forKey:@"CurrentStatus"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",StepOnTime] forKey:@"Date"];
                [array addObject:dataDictionary];
                sqlite3_finalize(compiledStatement);
                sqlite3_close(database);
                return array;
            }else{
                NSLog(@"Not found");
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database);
    }
    return array;
}

- (int) GetTotalUpcomingVenuesCount{
    int count = 0;
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        const char* sqlStatement = "SELECT COUNT(*) FROM tbl_StepOnOff where CurrentStatus = '1'";
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK ){
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW ){
                count = sqlite3_column_int(statement, 0);
            }
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return count;
}

#pragma mark - tbl_GalleryImages

- (BOOL) insertALLPhotoDetailsFirstTime_tbl_GalleryImages:(NSArray*)arrayData{
    //const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        char* errorMessage;
        sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
        for (int i =0; i <[arrayData count]; i++)
        {
            NSMutableArray *array = [arrayData objectAtIndex:i];
            NSString *filename = [NSString stringWithFormat:@"%@",[array valueForKey:@"photo_filename"]];

                NSString *query=[NSString stringWithFormat:@"insert into tbl_GalleryImages (photo_filename,venue_name,venue_id,venue_address,photo_taken) values (\"%@\", \"%@\", \"%@\",\"%@\", \"%@\")",filename,[array valueForKey:@"venue_name"],[array valueForKey:@"venue_id"],[array valueForKey:@"venue_address"],[array valueForKey:@"photo_taken"]];
                if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
                    NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
                    return NO;
                }
        }
        sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    }
    return YES;
}
- (BOOL)insertPhotoDetails_tbl_GalleryImages:(NSMutableDictionary*)arrayData{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        char* errorMessage;
        NSString *query=[NSString stringWithFormat:@"insert into tbl_GalleryImages (photo_filename,venue_name,venue_id,venue_address,photo_taken) values (\"%@\",\"%@\",\"%@\",\"%@\", \"%@\")",[arrayData valueForKey:@"filename"],[arrayData valueForKey:@"name"],[arrayData valueForKey:@"venue_id"],[arrayData valueForKey:@"venue_address"],[arrayData valueForKey:@"photo_taken"]];
        if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
            NSLog(@"DB Error. category transacation '%s'", sqlite3_errmsg(database));
            return NO;
        }else{
        }
    }
    return YES;
}

- (NSMutableArray*)getPhotoDetailsFrom_tbl_GalleryImages{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        // Setup the SQL Statement and compile it for faster access
        //Where PlaceDistance  BETWEEN '0' AND '100'
        //SQLIte Statement
        //order by PlaceDistance asc
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select * from tbl_GalleryImages order by ID desc "];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                // Init the Data Dictionary
                NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *filename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *venue_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *venue_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *venue_address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *photo_taken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",ID] forKey:@"ID"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",filename] forKey:@"photo_filename"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",venue_name] forKey:@"venue_name"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",venue_id] forKey:@"venue_id"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",venue_address] forKey:@"venue_address"];
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",photo_taken] forKey:@"photo_taken"];
                [array addObject:dataDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    
    // sqlite3_close(database);
    
    return array;
}

- (void) deletePhotoDetails_tbl_GalleryImages:(NSString *)fileName
{
    
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from tbl_GalleryImages WHERE photo_filename =\"%@\"",fileName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
            // sqlite3_close(database);
        }else{
            NSLog(@"failed to delete");
        }
    }
}

#pragma mark - clearing DB

- (NSMutableArray*)getAllTableNameList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Setup the database object
    sqlite3 *database;
    
    // Open the database from the users filessytem
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        //Where PlaceDistance  BETWEEN '0' AND '100'
        //SQLIte Statement
        //order by PlaceDistance asc
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type=\'table\'"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                //                NSString *tableName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *tableName = [NSString stringWithCString:(const char *)sqlite3_column_text(compiledStatement, 0)encoding:NSUTF8StringEncoding];
                [array addObject:tableName];
            }
            sqlite3_finalize(compiledStatement);
        }else{
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
    }
    
    // sqlite3_close(database);
    
    return array;
}

- (void) deleteAllTablesData:(NSString *)fileName{
    if (sqlite3_open_v2([databasePath UTF8String], &(database), SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"delete from \"%@\"",fileName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            //            NSLog(@"delete success");
            sqlite3_finalize(statement);
            // sqlite3_close(database);
        }else{
            NSLog(@"failed to delete");
        }
    }
}



@end
