//
//  QSSimpleLog.h
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSSimpleLog : NSObject

- (QSSimpleLog *)	initWithID: (NSString *) inLogID;

- (void)			finishLogging;

- (void)			logEvent: (NSString *) inEvent;

@property (nonatomic, strong) NSString			*logID;

@end
