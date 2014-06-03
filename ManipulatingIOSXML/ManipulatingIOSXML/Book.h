//
//  Book.h
//  XMLSample2
//
//  Created by Maher Suboh on 5/29/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSManagedObject

@property (nonatomic, readwrite) NSInteger recordID;
@property (nonatomic, readwrite) NSString *bookID;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *bookDescription;
@property (nonatomic, retain) NSString *isbn;
@property (nonatomic, retain) NSString *edition;
@property (nonatomic, retain) NSNumber  *price;
@property (nonatomic, retain) NSDate  *publishDate;
@property (nonatomic, retain) NSDate  *timeStamp;


- (NSString *)firstCharaterSection;


@end

/*
 <author>Fisher, Patton, and Ury</author>
 <title>Getting To Yes: Negotiating Agreement Without Giving In</title>
 <edition>(Houghton Mifflin 2nd Ed. 1991)</edition>
 <isbn>ISBN: 0-3956-3124-6 or ISBN13: 9780395631249</isbn>
 <price>15.00</price>
 <description>Coming Soon ... We are working on it ...</description>
 <publishdate>2014-12-01</publishdate>
*/