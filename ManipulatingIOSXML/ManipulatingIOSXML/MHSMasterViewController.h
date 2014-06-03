//
//  MHSMasterViewController.h
//  ManipulatingIOSXML
//
//  Created by Maher Suboh on 6/1/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "MHSmyXMLBooksParser.h"


@interface MHSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (nonatomic,retain) NSMutableArray *xmlBookArray;

@property (strong, nonatomic)  UIActivityIndicatorView *spinner;


@end
