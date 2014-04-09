//
//  QSUploadOperation.h
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface QSUploadOperation : NSOperation <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient			*dbRestClient;
@property (nonatomic, strong) NSURL					*logURL;
@property (nonatomic, assign) BOOL					finished;
@property (nonatomic, assign) BOOL					executing;

+ (NSOperationQueue *)		queue;

@end


