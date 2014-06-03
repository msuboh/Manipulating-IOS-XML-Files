//
//  MHSmyXMLBooksParser.m
//  XMLSample3
//
//  Created by Maher Suboh on 5/30/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSmyXMLBooksParser.h"

@implementation MHSmyXMLBooksParser


- (MHSmyXMLBooksParser *) init
{
    //    [super init];
    if(self == [super init])
    {
        
    }
    
    return self;
}



-(NSMutableArray *)parseDocumentWithURL:(NSURL *)url
{
    if (url == nil)
        return NO;
    
    // this is the parsing machine
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    
//    xmlparser.delegate=self;
    [xmlparser parse];
    return _book_array;
    
    
//    // now parse the document
//    BOOL ok = [xmlparser parse];
//     _value=nil;
//    if (ok == NO)
//    {
//        NSLog(@"error");
//        return _book_array;
//    }
//    else
//    {
//        NSLog(@"OK");
//        return nil;
//    }
//    
    
}


-(void)print_array
{
    for (int i=0 ; i < [_book_array count]; i++)
    {
        NSMutableDictionary *temp=[_book_array objectAtIndex:i];
        NSLog(@" Book ID %@",[temp valueForKey:@"id"]);
        NSLog(@" Book Author %@",[temp valueForKey:@"author"]);
        NSLog(@" Book Title %@",[temp valueForKey:@"title"]);
        NSLog(@" Book Price %@",[temp valueForKey:@"price"]);
        NSLog(@" Book Publish Date %@",[temp valueForKey:@"publishdate"]);
        NSLog(@" Book Description %@",[temp valueForKey:@"description"]);
    }
}

/////////////////////////////////////////////////////////////

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"didStartDocument");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"--- didEndDocument ----");
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"books" ]) {
        // Initialize book_array to store xml file values
        _book_array=[[NSMutableArray alloc]init];
    }
    else
    {
        if([elementName isEqualToString:@"book"]){
            // Initialize Dictionary to store a file information
            // Store Book id Value
            _dic=[[NSMutableDictionary alloc]init];
            NSString *temp=[ attributeDict valueForKey:@"recordID"];
            //            [_dic setValue:_value forKey:@"id"];
            [_dic setValue:temp forKey:@"recordID"];
        }
        _value=nil;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!_value)
    {
        _value=[[NSMutableString alloc]init];
    }
    [_value appendString:string];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"books"])
    {
        // All XML file information is parse to book array
        // Now you can call a function in which you can use this array as you want.
//        [self print_array];
    }
    else if ( [elementName isEqualToString:@"book"] )
    {
        // Add book dictionary to book array
        [_book_array addObject:_dic];
        _dic=nil;
    }
    else if ([elementName isEqualToString:@"author"])
    {
        // add book author in book dictionary
        [_dic setValue:_value forKey:elementName];
    }
    else if([elementName isEqualToString:@"title"])
    { // add book title to book dictionary
        [_dic setValue:_value forKey:elementName];
    }
    else if ([elementName isEqualToString:@"price"])
    { // add book price to book dictionary
        [_dic setValue:_value forKey:elementName];
    }
    else if([elementName isEqualToString:@"publishDate"])
    { // add book publish date to book dictionary
        [_dic setValue:_value forKey:elementName];
        
    }
    else if([elementName isEqualToString:@"bookDescription"])
    { // add book description to book dictionary
        [_dic setValue:_value forKey:elementName];
    }
    else if([elementName isEqualToString:@"edition"])
    { // add book description to book dictionary
        [_dic setValue:_value forKey:elementName];
    }
    else if([elementName isEqualToString:@"bookID"])
    { // add book description to book dictionary
        [_dic setValue:_value forKey:elementName];
    }    else if([elementName isEqualToString:@"isbn"])
    { // add book description to book dictionary
        [_dic setValue:_value forKey:elementName];
    }
}


// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}



/////////////////////////////////////////////////////////////


@end
