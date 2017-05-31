//
//  ShelfViewController.m
//  LiteratureAPP
//
//  Created by Zain Haider on 20/04/2017.
//  Copyright © 2017 Zain Haider. All rights reserved.
//

#import "TestTableViewCell.h"
#import "SWRevealViewController.h"
#import "ReaderViewController.h"
#import "ShelfViewController.h"
#import "HTTPService.h"
#import "Books.h"

@interface ShelfViewController ()<ReaderViewControllerDelegate>

@end

@implementation ShelfViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BookList = [[NSArray alloc]init];
    
    /////------HTTPservice of Geting Books--------////
    [[HTTPService instance]getBooks:^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        if (dataArray) {
            
            NSMutableArray *arr =[[NSMutableArray alloc]init];
            
          
                
                arr = [dataArray valueForKey:@"image"];
            arraybook=[dataArray valueForKey:@"docfile"];
            
//            for (NSDictionary *d in dataArray) {
//                Books *bk= [[Books alloc]init];
//                bk.bookId=[d objectForKey:@"id"];
//                bk.bookTitle= [d valueForKey:@"title"];
//                bk.bookImg= [d valueForKey:@"image"];
//                bk.bookfile= [d valueForKey:@"docfile"];
//
            
           
            
         ArrayTestImg=arr;
            
            
          [self.tblTest reloadData];

            NSLog(@"%@",arraybook);
            
            [self PDFDownloader];
        
           
        }else if (errMessage){
            //Display alert to user
        }
    }];

    
    
    //////-------Menu Bar Item------//////
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barMenu setTarget: self.revealViewController];
        [self.barMenu setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    ///////------////////////
    
 //   ArrayTestImg = [[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg", nil];
    c = -1;
   // arraybook = [[NSMutableArray alloc] initWithObjects:@"book0",@"book1.pdf",@"book2.pdf",@"book3", nil];
    
    // Do any additional setup after loading the view.
    
    
    
    
    
//    NSString *stringURL = @"http://jamaat.org/ur/documents/Islam%20dor%20e%20jadeed%20ka%20mazhab.pdf";
//    NSURL  *url = [NSURL URLWithString:stringURL];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    if ( urlData )
//    {
//        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString  *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.pdf"];
//        [urlData writeToFile:filePath atomically:YES];
//    }
    

    
}

-(void)PDFDownloader{
    
    
//        for (int x = 0; x<10; x++) {
//            
//            NSLog(@"Downloading Started");
//            NSString *urlString = [arraybook objectAtIndex:x];
//    
//            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//
////        NSString *stringURL = @"http://jamaat.org/ur/documents/Islam%20dor%20e%20jadeed%20ka%20mazhab.pdf";
//        NSURL  *url = [NSURL URLWithString:urlString];
//        NSData *urlData = [NSData dataWithContentsOfURL:url];
//        if ( urlData )
//        {
//            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString  *documentsDirectory = [paths objectAtIndex:0];
//    
//            NSString  *filePath = [NSString stringWithFormat:@"%@/Book%d%d.pdf", documentsDirectory,x,x];
//            [urlData writeToFile:filePath atomically:YES];
//        }
//    }
    
    for (int x = 5; x<116; x++) {
        
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Downloading Started");
            
            NSString *urlString = [arraybook objectAtIndex:x];
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *urlToDownload = urlString;
            NSURL  *url = [NSURL URLWithString:urlToDownload];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                
                NSString  *filePath = [NSString stringWithFormat:@"%@/Book%d.pdf", documentsDirectory,x];
                
                //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                    [urlData writeToFile:filePath atomically:YES];
                    NSLog(@"File Saved !");
               });
            }
            
       });
        
    }

}

-(void) updateTableData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblTest reloadData];
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
//    int rem = [ArrayTestImg count]%3;
//    int count = (int)[ArrayTestImg count]/3;
//    if (rem == 0) {
//        return count;
//    }else
//        NSLog(@"%d",count);
//        return count+1;
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell= [[TestTableViewCell alloc]init];
        }

    
    if ((indexPath.row*3+0)<[ArrayTestImg count]) {
        
        cell.imgtest.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ArrayTestImg objectAtIndex:indexPath.row*3+0]]]]];
        
        [cell.btnBook1 setTag:indexPath.row*3+0];
        [cell.btnBook1 addTarget:self action:@selector(FirstBookClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ((indexPath.row*3+1)<[ArrayTestImg count]) {
        
        cell.imgtest1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ArrayTestImg objectAtIndex:indexPath.row*3+1]]]]];

        [cell.btnBook2 setTag:indexPath.row*3+1];
        [cell.btnBook2 addTarget:self action:@selector(SecondBookClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ((indexPath.row*3+2)<[ArrayTestImg count]) {
        cell.imgtest2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ArrayTestImg objectAtIndex:indexPath.row*3+2]]]]];
        [cell.btnBook3 setTag:indexPath.row*3+2];
        [cell.btnBook3 addTarget:self action:@selector(ThirdBookClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [[self navigationController] pushViewController:_tblTest animated:YES];

}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)OpenPDFBook:(NSInteger)selectedIndex{
    
//    NSString *stringURL = @"http://jamaat.org/ur/documents/Islam dor e jadeed ka mazhab.pdf";
//    NSURL  *url = [NSURL URLWithString:stringURL];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    if ( urlData )
//    {
//        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString  *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.pdf"];
//        [urlData writeToFile:filePath atomically:YES];
//    }
    
    
    
    
    
    
//    NSURL *url1 = [self applicationDocumentsDirectory];
//    
//    NSLog(@"Book PDF is = %@",[arraybook objectAtIndex:154]);
//    
//    // Get the PDF Data from the url in a NSData Object
//    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[
//                                                             NSURL URLWithString:[NSString stringWithFormat:@"%@",[arraybook objectAtIndex:154]]]];
//    
//    // Store the Data locally as PDF File
//    NSString *resourceDocPath = [[NSString alloc] initWithString:[
//                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
//                                                                  stringByAppendingPathComponent:@"Documents"
//                                                                  ]];
//    
//    NSString *filePath = [resourceDocPath
//                          stringByAppendingPathComponent:@"myPDF.pdf"];
//    [pdfData writeToFile:filePath atomically:YES];
    
    
    // Now create Request for the file that was saved in your documents folder
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
//    [webView setUserInteractionEnabled:YES];
//    [webView setDelegate:self];
//    [webView loadRequest:requestObj];
    
    
    
    
    
    NSString *bookName = [NSString stringWithFormat:@"%@book%ld.pdf",[arraybook objectAtIndex:selectedIndex],selectedIndex];
    
    NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bookName];
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:str password:nil];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, str, phrase);
    }

}

-(void)FirstBookClicked:(id)sender{
    
    [self OpenPDFBook:[sender tag]];
    
}

-(void)SecondBookClicked:(id)sender{
    [self OpenPDFBook:[sender tag]];
    
}

-(void)ThirdBookClicked:(id)sender{
    [self OpenPDFBook:[sender tag]];
    
}


#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


@end
