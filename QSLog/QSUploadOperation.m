//
//  QSUploadOperation.m
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import "QSUploadOperation.h"

@implementation QSUploadOperation

#pragma mark - NSOperation Concurrency

+ (NSOperationQueue *) queue
{
	static NSOperationQueue		*sUploadQueue = nil;
	static dispatch_once_t		sOnceToken;
	
	dispatch_once(&sOnceToken, ^{
		sUploadQueue = [[NSOperationQueue alloc] init];
	});
	
	return sUploadQueue;
}

- (void) start
{
	DBSession			*dbSession = [DBSession sharedSession];
	NSString			*logfilePath = [self.logURL path];
	
	self.executing = YES;
	
	self.dbRestClient = [[DBRestClient alloc] initWithSession: dbSession];
	self.dbRestClient.delegate = self;
	dispatch_async(dispatch_get_main_queue(), ^{	// dropbox really wants these calls made from the main thread
		[self.dbRestClient uploadFile: [logfilePath lastPathComponent] toPath: @"/" withParentRev: nil fromPath: logfilePath];
	});
}


- (BOOL) isConcurrent
{
  return YES;
}

- (BOOL) isExecuting
{
	return self.executing;
}

- (BOOL) isFinished
{
	return self.finished;
}

- (void) finishUpload
{
	[[NSFileManager defaultManager] removeItemAtURL: self.logURL error: nil];

	self.executing = NO;
	self.finished = YES;
}

#pragma mark - Setters / Getters

- (void) setExecuting: (BOOL) inExecuting
{
    [self willChangeValueForKey: @"isExecuting"];
	_executing = inExecuting;
    [self didChangeValueForKey: @"isExecuting"];
}

- (void) setFinished: (BOOL) inFinished
{
    [self willChangeValueForKey: @"isFinished"];
	_finished = inFinished;
    [self didChangeValueForKey: @"isFinished"];
}

#pragma mark - DBRestClientDelegate

- (void) restClient: (DBRestClient *) inClient
	uploadedFile: (NSString *) inDestPath
	from: (NSString *) inSrcPath
	metadata: (DBMetadata *) inMetadata
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self finishUpload];
}

- (void) restClient: (DBRestClient *) inClient
	uploadProgress: (CGFloat) inProgress
	forFile: (NSString *) inDestPath
	from: (NSString *) inSrcPath
{
	NSLog(@"%s: %f", __PRETTY_FUNCTION__, inProgress);
}

- (void) restClient: (DBRestClient *) inClient
	uploadFileFailedWithError: (NSError *) inError
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self finishUpload];
}

@end
