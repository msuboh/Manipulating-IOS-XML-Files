//
//  MHSMasterViewController.m
//  ManipulatingIOSXML
//
//  Created by Maher Suboh on 6/1/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController.h"

#import "MHSDetailViewController.h"

#import "Book.h"
#import "MHSXMLTagHelper.h"



@interface MHSMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MHSMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // 1. Backup Core Data data by build xml tag string
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backupCoreDataToXMLFile:)];
    // 2. Backup Core Data data by building  dictionary as PLIS file
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backupCoreDataAsPLISTFile:)];
    //3. Backup/copy data from another XML file
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backupXMLFileFromXMLFile:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionItem:)];

    
    self.navigationItem.rightBarButtonItem = addButton;
    
    //////////////////////////////////////////////
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
    _spinner.center = self.view.center;
    [_spinner setColor:[UIColor blueColor]];
    [self.view addSubview:_spinner];
    [self.view bringSubviewToFront:_spinner];
    /////////////////////////////////////////////
    
    
    [self.spinner startAnimating];
    [self deleteAllRecords];
    [self performSelectorOnMainThread:@selector(parseXMLFile) withObject:nil waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.spinner stopAnimating];
    });
    
//    [self parseXMLFile];

}


- (void)actionItem:(id)sender
{
    // Look for Localizable.strings file in [Supporting Files] group in the App main domain directory for NSLocalizedString(@"Cancel", @"") what those mean:
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"AlertTitle", @"")  delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                         destructiveButtonTitle:NSLocalizedString(@"Delete", @"")
                                              otherButtonTitles:@"Import XML File to Core Data", @"Backup/Export Core Data to XML File", @"Backup/Export Core Data to PLIST File", @"XML File To Another XML File", nil];
    [sheet showInView:[self.view window]];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    [self.spinner startAnimating];

    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Delete", @"") ])
    {
        NSLog(@"Destructive pressed --> Delete Something");
        [self deleteAllRecords];
    }
    if ([buttonTitle isEqualToString:@"Import XML File to Core Data"])
    {
        [self performSelectorOnMainThread:@selector(parseXMLFile) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.spinner stopAnimating];
        });
//        [self parseXMLFile];
    }

    if ([buttonTitle isEqualToString:@"Backup/Export Core Data to XML File"])
    {
        [self backupCoreDataToXMLFile:nil];
    }
    if ([buttonTitle isEqualToString:@"Backup/Export Core Data to PLIST File"])
    {
        [self backupCoreDataAsPLISTFile:nil];
    }
    if ([buttonTitle isEqualToString:@"XML File To Another XML File"])
    {
        [self backupXMLFileFromXMLFile:nil];
    }
 
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Cancel", @"") ]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    
    [self.spinner stopAnimating];

    //  if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    //	switch (buttonIndex) {
    //		case 0:
    //		{
    ////			NSLog(@"Item A Selected %@", actionSheet.address );
    ////            [self showDirectionByMailingAddress:actionSheet.address];
    //
    //			break;
    //		}
    //		case 1:
    //		{
    //			NSLog(@"Item B Selected");
    ////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"telprompt://%@", actionSheet.phoneNumber ]    ]];
    //
    //            //            NSURL *url = [NSURL URLWithString:@"tel://6348338352"];
    //            //            [[UIApplication sharedApplication] openURL:url];
    //			break;
    //		}
    //		case 2:
    //		{
    //			NSLog(@"Item C Selected");
    ////            [self performSegueWithIdentifier:@"ShowContactUS" sender:nil];
    //            
    //			break;
    //		}
    //	}
    
    
}

- (void) parseXMLFile;
{
    [self deleteAllRecords];

    
    NSURL *url=[[NSURL alloc] initWithString:@"http://localhost/Kababish/Books.xml"]; // Write your file path here
    //    MHSmyXMLBooksParser *myBooksXML =[[MHSmyXMLBooksParser alloc] initWithContentsOfURL:url];


    MHSmyXMLBooksParser *myXML = [[MHSmyXMLBooksParser alloc] init];


    _xmlBookArray = [myXML parseDocumentWithURL:url];

    if (_xmlBookArray)
    {
        NSLog(@"We Got it .........");
        [self update_CoreData:_xmlBookArray];
    }
    else
    NSLog(@"Noooooooo");
    

}

-(void)update_CoreData:( NSMutableArray *)theBooksXMLArray
{
    
    
    NSDictionary *keyNames=[theBooksXMLArray objectAtIndex:0];
    
    for (int i=0; i < [keyNames count]; i++)
        NSLog(@" field %d %@",i, [[keyNames allKeys] objectAtIndex:i] );
    //    NSLog(@" field 1 %@",[[keyNames allKeys] objectAtIndex:1] );
    //    NSLog(@" field 2 %@",[[keyNames allKeys] objectAtIndex:2] );
    //    NSLog(@" field 3 %@",[[keyNames allKeys] objectAtIndex:3] );
    //    NSLog(@" field 4 %@",[[keyNames allKeys] objectAtIndex:4] );
    //    NSLog(@" field 5 %@",[[keyNames allKeys] objectAtIndex:5] );
    //    NSLog(@" field 6 %@",[[keyNames allKeys] objectAtIndex:6] );
    //    NSLog(@" field 7 %@",[[keyNames allKeys] objectAtIndex:7] );
    //    NSLog(@" field 8 %@",[[keyNames allKeys] objectAtIndex:8] );
    
    //    for (int i=0 ; i < [theBooksXMLArray count]; i++)
    //    {
    //         NSMutableDictionary *temp=[theBooksXMLArray objectAtIndex:i];
    ////        NSLog(@" Book ID %@",[temp valueForKey:@"id"]);
    ////        NSLog(@" Book Author %@",[temp valueForKey:@"author"]);
    ////        NSLog(@" Book Title %@",[temp valueForKey:@"title"]);
    ////        NSLog(@" Book Price %@",[temp valueForKey:@"price"]);
    ////        NSLog(@" Book Publish Date %@",[temp valueForKey:@"publishdate"]);
    ////        NSLog(@" Book Description %@",[temp valueForKey:@"description"]);
    //    }
    
    for (int j=0 ; j < [theBooksXMLArray count]; j++)
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        Book *bookObject = [NSEntityDescription    insertNewObjectForEntityForName:@"Books"    inManagedObjectContext:context];
        
        bookObject.timeStamp = [NSDate date];
        bookObject.title = @"-";
        
        
        NSMutableDictionary *temp=[theBooksXMLArray objectAtIndex:j];
        
        for (int i=0; i < [keyNames count]; i++)
        {
            
            
            NSString *forkeyName = [[keyNames allKeys] objectAtIndex:i];
            id forKeyValue = [temp valueForKey:forkeyName];
            
            
            if ([ forkeyName isEqualToString:@"publishDate"])
            {
                [bookObject setValue: [NSDate date] forKey: forkeyName ];
                
            }
            else if ([ forkeyName isEqualToString:@"price"])
            {
                [bookObject setValue: [NSNumber numberWithDouble:  [ forKeyValue  doubleValue]   ] forKey:forkeyName ];
                
            }
            else if ([  [[keyNames allKeys] objectAtIndex:i]  isEqualToString:@"recordID"]  )
            {
                [bookObject setValue: [NSNumber numberWithInteger:  [ forKeyValue  integerValue]   ] forKey:forkeyName ];
                
            }
            else
            {
                
                [bookObject setValue:forKeyValue forKey:forkeyName ];
                
            }
            
            
            
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        
    }
    
    
    //      [self.tableView reloadData];
    
}



- (void) backupCoreDataToXMLFile:(id)sender
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"EmptyXMLFile" ofType:@"xml"];
    NSError* error = nil;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *jsonEntity = [NSEntityDescription entityForName:@"Books" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:jsonEntity];
    
    MHSXMLTagHelper *XMLStringFile = [[MHSXMLTagHelper alloc] init];
    
    for (NSManagedObject *selectedObjects in [context executeFetchRequest:fetchRequest error:&error])
    {
        [XMLStringFile addSingleTag:@"Book" withInnerValueTitle:@"recordID" andValue:[[selectedObjects valueForKey:@"recordID"] description] ];
        
        for (NSPropertyDescription *property in jsonEntity)
        {
            
            
            if (![property.name isEqualToString:@"recordID"])
            {
                if ([property.name isEqualToString:@"publishDate"] || [property.name isEqualToString:@"timeStamp"])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/dd/yyyy"];
                    NSString *dateString = [dateFormat stringFromDate:[selectedObjects valueForKey:property.name]];
                    [XMLStringFile addTagToXML:property.name withValue: [ dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  ];
                }
                else
                    [XMLStringFile addTagToXML:property.name withValue: [ [[selectedObjects valueForKey:property.name] description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  ];
                
                //[XMLStringFile addTagToXML:property.name withValue: [ [[selectedObjects valueForKey:property.name] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""]  ];
                //[yourString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
            }
            
        }
        [XMLStringFile endSingleTag:@"book"];
        
    }
    
    //    [XMLStringFile addTagToXML:@"name" withValue:@"Maher Suboh"];
    //    [XMLStringFile addTagToXML:@"name" withValue:@"Hazem Suboh"];
    [XMLStringFile closeXML];
    NSLog(@"%@", XMLStringFile.XMLString);
    
    [XMLStringFile.XMLString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(error)
    {
        // If error object was instantiated, handle it.
        NSLog(@"ERROR while Writing to EmptyXMLFile.xml: %@", error);
    }
    else
    {
        error = nil;
        NSString* content = [NSString stringWithContentsOfFile:path     encoding:NSUTF8StringEncoding    error:&error];
        if(error)
        {
            // If error object was instantiated, handle it.
            NSLog(@"ERROR while readin from EmptyXMLFile.xml: %@", error);
        }
        else
        {
            if (content)
            {
                NSLog(@"The Content of the main bundle empty xml file which is included with the project:\n %@",content);
            }
        }
        
    }
    
}

- (void) backupXMLFileFromXMLFile:(id)sender
{
    /*
     <author>Fisher, Patton, and Ury</author>
     <title>Getting To Yes: Negotiating Agreement Without Giving In</title>
     <edition>(Houghton Mifflin 2nd Ed. 1991)</edition>
     <isbn>ISBN: 0-3956-3124-6 or ISBN13: 9780395631249</isbn>
     <price>15.00</price>
     <description>Coming Soon ... We are working on it ...</description>
     <publishdate>2014-12-01</publishdate>
     */
    
    
    
    //    // construct path within our documents directory
    //    NSString *applicationDocumentsDir =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"sample.xml"];
    //
    //    // write to file atomically (using temp file)
    //    [data writeToFile:storePath atomically:TRUE];
    
    ///////////////////////////////////////////////////////////
    //
    // !!! NOTE: You CAN'T ***Create*** a file in the iOS main bumdle but you can ***Write*** into it. Nor Delete, remove, nor rename. the Main Bundle directory is a read only and secure.
    // I use this trick, to include an empty file of any  kind of format with the project, and write to it
    //
    /////////////////////////////////////////////////////////////////////////////////
    
    //1. Method -1-
    
    // - Read the XML Data from a server site
    NSURL *url = [NSURL URLWithString:@"http://localhost/Kababish/Books.xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];  // Load XML data from web
    //
    // - Write the XML Data from the Web to the Main Bundle File.
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"EmptyXMLFile" ofType:@"xml"];
    NSFileHandle *filehandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    [filehandle seekToEndOfFile];
    //    [filehandle writeData:   [@"ggggggg" dataUsingEncoding:NSUTF8StringEncoding]   ];
    [filehandle writeData:data];
    [filehandle closeFile];
    
    // - Read back the file which you just wrote
    NSString* path = [[NSBundle mainBundle] pathForResource:@"EmptyXMLFile"     ofType:@"xml"];
    NSError* error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path    encoding:NSUTF8StringEncoding      error:&error];
    
    if(error)
    {
        // If error object was instantiated, handle it.
        NSLog(@"ERROR while loading from file: %@", error);
        // …
    }
    else
    {
        if (content)
        {
            NSLog(@"Here is the Content of the file you just wrote to: %@",content);
        }
    }
    
    
    
}

- (void) backupCoreDataAsPLISTFile:(id)sender
{
    
    
    //    One Way:
    //    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                @"First Object", @"First Key",
    //                                @"Second Object", @"Second Key",
    //                                @"Third Object", @"Third Key",
    //                                nil
    //                                ];
    
    //    // Another Way:
    //    NSArray *xmlKeys = @[@"First Key", @"Second Key", @"Third Key", @"Forth Key"];
    //    NSArray *xmlValues = @[@"First Object", @"Second Object",   @"Third Object", @"Forth Object"];
    //    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:xmlValues forKeys:xmlKeys];
    
    
    // This is the Way I want to add Objects and keys dynamically:
    NSMutableArray *xmlKeys = [NSMutableArray array]; //@[@"First Key", @"Second Key", @"Third Key", @"Forth Key"];
    NSMutableArray *xmlValues = [NSMutableArray array];  // @[@"First Object", @"Second Object",   @"Third Object", @"Forth Object"];
    
    //    [xmlKeys addObject:@"First Key"];
    //    [xmlValues addObject:@"First Object"];
    //    [xmlKeys addObject:@"Second Key"];
    //    [xmlValues addObject:@"Second Object"];
    //    [xmlKeys addObject:@"Third Key"];
    //    [xmlValues addObject:@"Third Object"];
    //    [xmlKeys addObject:@"Forth Key"];
    //    [xmlValues addObject:@"Forth Object"];
    //    [xmlKeys addObject:@"Fifth Key"];
    //    [xmlValues addObject:@"Fifth Object"];
    
    
    NSError* error = nil;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *xmlEntity = [NSEntityDescription entityForName:@"Books" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:xmlEntity];
    
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] init];
    
    int i = 0;
    for (NSManagedObject *selectedObjects in [context executeFetchRequest:fetchRequest error:&error])
    {
        
        for (NSPropertyDescription *property in xmlEntity)
        {
            [xmlKeys addObject:property.name];
            
            if ([property.name isEqualToString:@"publishDate"] || [property.name isEqualToString:@"timeStamp"])
            {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yyyy"];
                NSString *dateString = [dateFormat stringFromDate:[selectedObjects valueForKey:property.name]];
                [xmlValues addObject:dateString];
            }
            else
            {
                
                [xmlValues addObject: [  [[selectedObjects valueForKey:property.name] description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  ];
                
            }
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:xmlValues forKeys:xmlKeys];
        
        [plistDictionary setObject:dictionary  forKey:[NSString stringWithFormat:@"Book%d", i]];
        
        i +=1;
        
        
    }
    
    NSLog(@"Keys: %@, Values:%@",xmlKeys, xmlValues);
    
    
    
    
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmptyXMLFile" ofType:@"xml"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test_dictionary.plist"];
    //    NSLog(@"the path is %@", path);
    
    
    /*               The output file should be in this format
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
     <dict>
     <key>First Key</key>
     <string>First Object</string>
     <key>Second Key</key>
     <string>Second Object</string>
     <key>Third Key</key>
     <string>Third Object</string>
     </dict>
     </plist>
     */
    
    
    BOOL result = [plistDictionary writeToFile: path atomically:YES];
    //    NSLog(@"%@", result ? @"saved" : @"not saved");
    
    if (result)
    {
        NSDictionary* readData = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in readData)
            NSLog(@"%@: %@", key, [readData objectForKey: key]);
    }
    
    
}



- (void) deleteAllRecords
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Books" inManagedObjectContext:context]];
    
    //    NSSortDescriptor *sortDescriptorByAge = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    //    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorByAge, nil];
    //
    //
    //    [request setSortDescriptors:sortDescriptors];
    //
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"appDefault = 1"   ];
    //    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        // handle error
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Save Error!"
                                  message:[NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo] ]
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    else
    {
        for (NSManagedObject *object in objects)
        {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return  [[[self.fetchedResultsController sections] objectAtIndex:section] name];;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Books" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NOTE:
    // - The sectionNameKeyPath:@"firstCharaterSection" from the follow command have @"firstCharaterSection" as section name from Book.h Book.m which is a method which return the first charater from  "title" field/attribute from the entity.
    // - Make Sure the Book.h class inherate from NSManagedObject NOT from NSObject.
    // - Setup Data Model in core data for that entity to have the Class set to Book which is book.h?!
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"firstCharaterSection" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    cell.textLabel.text = [[object valueForKey:@"title"] description];

}

@end
