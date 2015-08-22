//
//  Azure.m
//  CatToday
//
//  Created by cjlin on 2015/8/23.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "Azure.h"
#import "PrivateKey.h"

@implementation Azure
+ (void)azureFaceAPI:(NSString *)imageUrl
{
	//NSString* path = @"https://api.projectoxford.ai/face/v0/identifications";
	NSString *path = @"https://api.projectoxford.ai/face/v0/detections?analyzesFaceLandmarks=false&analyzesAge=false&analyzesGender=false&analyzesHeadPose=false";
	NSArray* array = @[
					   // Request parameters
					   @"entities=true",
					   ];

	NSString* string = [array componentsJoinedByString:@"&"];
	path = [path stringByAppendingFormat:@"?%@", string];

	NSLog(@"%@", path);

	NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
	[_request setHTTPMethod:@"POST"];
	// Request headers
	[_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[_request setValue:faceApiKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];

	//// Request body
	[_request setHTTPBody:[[NSString stringWithFormat:@"{\"url\":\"%@\"}",imageUrl]
						    dataUsingEncoding:NSUTF8StringEncoding]];

	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];

	if (nil != error)
	{
		NSLog(@"Error: %@", error);
	}
	else
	{
		NSError* error = nil;
		NSMutableDictionary* json = nil;
		NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
		NSLog(@"%@", dataString);

		if (nil != _connectionData)
		{
			json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
		}

		if (error || !json)
		{
			NSLog(@"Could not parse loaded json with error:%@", error);
		}

		NSLog(@"%@", json);
		_connectionData = nil;
	}
}
@end
