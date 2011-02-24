//
//  HuffPuffStorage.h
//  HuffPuff
//
//  Created by Angad Singh on 1/29/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuffPuffStorage : NSObject {
}

//The file reading and writing implementation

+(BOOL)writeToFile:(NSMutableArray*)obj:(NSString*)file;
+(NSMutableArray*)loadFile: (NSString*)file;

@end
