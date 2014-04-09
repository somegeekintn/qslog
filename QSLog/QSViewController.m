//
//  QSViewController.m
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import "QSViewController.h"
#import "QSSimpleLog.h"
#import <DropboxSDK/DropboxSDK.h>

@interface QSViewController ()

@property (nonatomic, strong) QSSimpleLog		*simpleLog;

@end


@implementation QSViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self updateLogAndReset];
}

- (void) viewDidAppear: (BOOL) inAnimated
{
	[super viewDidAppear: inAnimated];
	
#if !HAVE_DROPBOX_TOKENS
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController: self];
	}
#endif
}

- (void) updateLogAndReset
{
	NSDateFormatter		*dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat: @"yyMMdd_HHmmss"];
	
	if (self.simpleLog != nil)
		[self.simpleLog finishLogging];
		
	self.simpleLog = [[QSSimpleLog alloc] initWithID: [dateFormatter stringFromDate: [NSDate date]]];
}

- (IBAction) handleLogUpload: (id) inSender
{
	[self updateLogAndReset];
}

- (IBAction) handleLogRequest: (id) inSender
{
	UIButton	*button = inSender;
	NSString	*eventName;
	
	switch (button.tag) {
		case 0:		eventName = @"Button A";		break;
		case 1:		eventName = @"Button B";		break;
		case 2:		eventName = @"Button C";		break;
		case 3:		eventName = @"Button D";		break;
		default:	eventName = @"Huh?";			break;
	}
	
	[self.simpleLog logEvent: eventName];
}

@end
