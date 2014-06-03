//
//  MHSXMLHelper.m
//  XMLSample3
//
//  Created by Maher Suboh on 6/1/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSXMLTagHelper.h"

@implementation MHSXMLTagHelper

@synthesize XMLString;

-(id)init
{
	if ([super init])
    {
        XMLString = [[NSMutableString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n"];
    }
	return self;
}

-(void)addTagToXML:(NSString *)tag withValue:(NSString *)value{
	[XMLString appendFormat:@"<%@>%@</%@> \n",tag,value,tag];
}

-(void)addSelfClosedTag:(NSString *)tag withInnerValueTitle:(NSString *)innerValueTitle andValue:(NSString *)value{
	[XMLString appendFormat:@"<%@ %@=%@ /> \n",tag,innerValueTitle,value];
}

-(void)addSelfClosedTag:(NSString *)tag withInnerString:(NSString *)innerString{
	[XMLString appendFormat:@"<%@ %@ /> \n",tag,innerString];
}

-(void)addSingleTag:(NSString *)tag withInnerValueTitle:(NSString *)innerValueTitle andValue:(NSString *)value{
	[XMLString appendFormat:@"<%@ %@=%@ > \n",tag,innerValueTitle,value];
}

-(void)addSingleTag:(NSString *)tag withInnerString:(NSString *)innerString{
	[XMLString appendFormat:@"<%@ %@ > \n",tag,innerString];
}
-(void)addSingleValue:(NSString *)value{
	[XMLString appendFormat:@"%@ \n",value];
}

-(void)addSingleTag:(NSString *)tag{
	[XMLString appendFormat:@"<%@> \n",tag];
}

-(void)endSingleTag:(NSString *)tag{
	[XMLString appendFormat:@"</%@> \n",tag];
}

-(void)closeXML{
	[XMLString appendFormat:@"\n"];
}




@end
