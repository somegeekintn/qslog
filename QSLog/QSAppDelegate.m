//
//  QSAppDelegate.m
//  QSLog
//
//  Created by Casey Fleser on 3/27/14.
//  Copyright (c) 2014 Quiet Spark. All rights reserved.
//

#import "QSAppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>

#define DROPBOX_APPKEY				@"appkey"
#define DROPBOX_APPSECRET			@"appsecret"
#define DROPBOX_USERID				@"userid"
#define DROPBOX_ACCESSTOKEN			@"accesstoken"
#define DROPBOX_ACCESSTOKENSECRET	@"accesstokensecret"

@implementation QSAppDelegate

- (BOOL) application: (UIApplication *) inApplication
	didFinishLaunchingWithOptions: (NSDictionary *) inLaunchOptions
{
	[self configureDropbox];
	
	return YES;
}

- (BOOL) application: (UIApplication *) inApplication
	openURL: (NSURL *) inURL
	sourceApplication: (NSString *) inSourceApplication
	annotation: (id) inAnnotation
{
	DBSession			*session = [DBSession sharedSession];
	BOOL				didOpen = NO;
	
	if ([session handleOpenURL: inURL]) {
		if ([session isLinked]) {
			MPOAuthCredentialConcreteStore		*credentials;
			
			NSLog(@"App linked successfully!");

			for (NSString *userID in session.userIds) {
				credentials = [session credentialStoreForUserId: userID];
				NSLog(@"User ID: %@", userID);
				NSLog(@"\taccessToken: %@", credentials.accessToken);
				NSLog(@"\taccessTokenSecret: %@", credentials.accessTokenSecret);
			}
		}
		didOpen = YES;
	}
	
	return didOpen;
}

- (void) configureDropbox
{
    NSString			*appKey = DROPBOX_APPKEY;
	NSString			*appSecret = DROPBOX_APPSECRET;
	NSString			*root = kDBRootAppFolder;
	DBSession			*session = [[DBSession alloc] initWithAppKey: appKey appSecret: appSecret root: root];

#if HAVE_DROPBOX_TOKENS
	[session updateAccessToken: DROPBOX_ACCESSTOKEN accessTokenSecret: DROPBOX_ACCESSTOKENSECRET forUserId: DROPBOX_USERID];
#else
	[session unlinkAll];
#endif
	[DBSession setSharedSession: session];
	
#if HAVE_DROPBOX_TOKENS
	if ([session isLinked]) {
		NSLog(@"Linked to dropbox from access token");
	}
#endif
}

@end
