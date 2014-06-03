//
//  MHSXMLHelper.h
//  XMLSample3
//
//  Created by Maher Suboh on 6/1/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHSXMLTagHelper : NSObject
{
	NSMutableString *XMLString;
    
}

@property(nonatomic,retain) NSMutableString *XMLString;

-(void)addTagToXML:(NSString *)tag withValue:(NSString *)value;
-(void)addSelfClosedTag:(NSString *)tag withInnerValueTitle:(NSString *)innerValueTitle andValue:(NSString *)value;
-(void)addSelfClosedTag:(NSString *)tag withInnerString:(NSString *)innerString;
-(void)addSingleTag:(NSString *)tag withInnerValueTitle:(NSString *)innerValueTitle andValue:(NSString *)value;
-(void)addSingleTag:(NSString *)tag withInnerString:(NSString *)innerString;
-(void)addSingleValue:(NSString *)value;
-(void)addSingleTag:(NSString *)tag;
-(void)endSingleTag:(NSString *)tag;
-(void)closeXML;

@end
