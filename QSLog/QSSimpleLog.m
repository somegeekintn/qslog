//
//  QSSimpleLog.m
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import "QSSimpleLog.h"
#import "QSUploadOperation.h"

@interface QSSimpleLog ()

@property (nonatomic, strong) NSMutableString		*logText;
@property (nonatomic, strong) NSDateFormatter		*dateFormatter;

@end


@implementation QSSimpleLog

- (QSSimpleLog *) initWithID: (NSString *) inLogID
{
	if ((self = [super init]) != nil) {
		self.logID = inLogID;
		self.logText = [NSMutableString string];
		
		self.dateFormatter = [[NSDateFormatter alloc] init];
		[self.dateFormatter setTimeZone: [[NSCalendar currentCalendar] timeZone]];
		[self.dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
	}
	
	return self;
}

- (void) finishLogging
{
	if ([[DBSession sharedSession] isLinked]) {
		QSUploadOperation	*uploadOperation = [[QSUploadOperation alloc] init];
		NSData				*logData = [self.logText dataUsingEncoding: NSUTF8StringEncoding];
		NSOutputStream		*outputStream;
		
		uploadOperation.logURL = [self logfileURL];
		
		outputStream = [NSOutputStream outputStreamWithURL: uploadOperation.logURL append: NO];
		[outputStream open];
		[outputStream write: [logData bytes] maxLength: [logData length]];
		[outputStream close];
		
		[[QSUploadOperation queue] addOperation: uploadOperation];
		
		self.logText = [NSMutableString string];
	}
	else {
		NSLog(@"Dropbox isn't linked. Could not create log");
	}
}

- (void) logEvent: (NSString *) inEvent
{
	[self.logText appendString: [NSString stringWithFormat: @"%@| %@\n", [self.dateFormatter stringFromDate: [NSDate date]], inEvent]];
}

- (NSURL *) logDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}

- (NSURL *) logfileURL
{
	return [[self logDirectory] URLByAppendingPathComponent: [self.logID stringByAppendingPathExtension: @"log"]];
}

@end


