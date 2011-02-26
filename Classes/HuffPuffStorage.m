//
//  HuffPuffStorage.m
//  HuffPuff
//
//  Created by Angad Singh on 1/29/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "HuffPuffStorage.h"

@implementation HuffPuffStorage

-(id)init
{
	return self;
}

+(BOOL)writeToFile:(NSMutableArray*)obj:(NSString*)file
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [rootPath stringByAppendingPathComponent:file];
	[archiver encodeRootObject:obj];
	[archiver finishEncoding];
	BOOL success = [data writeToFile:filePath atomically:YES]; 
	[archiver release];
	[data release];
	NSLog(@"%i", success);
	return success;
}

+(NSMutableArray*)loadFile:(NSString*)file
{		
	NSMutableArray* models;
	NSData *data;
	NSKeyedUnarchiver *unarchiver;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [rootPath stringByAppendingPathComponent:file];

	data = [NSData dataWithContentsOfFile:filePath];
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

	// Customize unarchiver here
	models = [unarchiver decodeObject];
	[unarchiver finishDecoding];
	[unarchiver release];
	return models;
}

@end
