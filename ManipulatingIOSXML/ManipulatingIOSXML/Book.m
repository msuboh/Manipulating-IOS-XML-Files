//
//  Book.m
//  XMLSample2
//
//  Created by Maher Suboh on 5/29/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "Book.h"

@implementation Book



@dynamic recordID;
@dynamic bookID;
@dynamic author;
@dynamic title;
@dynamic bookDescription;
@dynamic isbn;
@dynamic edition;
@dynamic price;
@dynamic publishDate;
@dynamic timeStamp;

- (NSString *)firstCharaterSection
{
    return [self.title substringToIndex:1 ];
}


@end
