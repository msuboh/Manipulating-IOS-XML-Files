//
//  MHSmyXMLBooksParser.h
//  XMLSample3
//
//  Created by Maher Suboh on 5/30/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHSmyXMLBooksParser : NSObject <NSXMLParserDelegate>


@property (nonatomic,retain) NSMutableDictionary *dic;
@property (nonatomic,retain) NSMutableString *value;
@property (nonatomic,retain) NSMutableArray *book_array;
-(void)print_array;

-(NSMutableArray *)parseDocumentWithURL:(NSURL *)url;


@end
