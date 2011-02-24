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
	[archiver encodeObject:obj forKey:file];
	[archiver finishEncoding];
	BOOL success = [data writeToFile:file atomically:YES]; 
	[archiver release];
	[data release];
	NSLog(@"%i", success);
	return success;
}

+(NSMutableArray*)loadFile:(NSString*)file
{		
	NSMutableArray* gamearea;
	NSData *data;
	NSKeyedUnarchiver *unarchiver;
	//NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:];
	
	data = [NSData dataWithContentsOfFile:file];
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	// Customize unarchiver here
	gamearea = [unarchiver decodeObjectForKey:file];
	[unarchiver finishDecoding];
	[unarchiver release];
	return gamearea;
}

/*
+(BOOL)store:(id)obj:(NSString*)key
{
		
}

+(id)load:(NSString*)key
{
	id obj;
	NSData *data;
	NSKeyedUnarchiver *unarchiver;
	data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@.archive", key]];
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	obj = [unarchiver decodeObjectForKey:key];
	NSLog(@"%@",key);
	
	[unarchiver finishDecoding];
	[unarchiver release];
	
	return obj;
}
*/

@end
