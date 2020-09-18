//
//  ViewController.m
//  CovidReport
//
//  Created by Gabriel Betancourt on 9/8/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import "WorldViewController.h"

@interface WorldViewController ()

@end

@implementation WorldViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	/* Core Animation stuff */
	// displays blue square
	//	CALayer *blueLayer = [CALayer layer];
	//	blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
	//	blueLayer.backgroundColor = [UIColor blueColor].CGColor;
	//	blueLayer.delegate = self;
	//	blueLayer.contentsScale = [UIScreen mainScreen].scale;
	//	[self.graphicsView.layer addSublayer:blueLayer];
	
	// UIImage *image = [UIImage imageNamed:@"virus_white.pdf"];
	// self.graphicsView.layer.contents = (__bridge id)image.CGImage;
	//	self.graphicsView.contentMode = UIViewContentModeScaleAspectFit;
	// does same thing but with CALayer
	//	self.graphicsView.layer.contentsGravity = kCAGravityResizeAspect;
	//	[blueLayer display]; // forces layer to redraw
	
	/* Core Animation stuff */
	
	/*
	 when the app first loads, token.plist may not be in the documents folder on ios device
	 therefore, we should copy the token.plist from the main bundle first before we try to write to it
	 should be a check but dont have it run each time as it will overwrite the token.plist in the documents
	 folder with a clean version from bundle if its already present in documents rather than copy to
	*/
}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//	CGContextSetLineWidth(ctx, 10.0f);
//	CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//	CGContextStrokeEllipseInRect(ctx, layer.bounds);
//}

- (IBAction)getApiToken:(id)sender {
	
	// prepare endpoint request
	NSString *baseUri = @"http://localhost:8090";
	NSString *endPoint = @"/agree_to_terms";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUri, endPoint]]];
	// NSDictionary *jsonBody = @{ @"accepted_tos": @"trueaaa" };
	NSDictionary *jsonBody = @{ @"accepted_tos": @"true" };
	NSError *error;
	NSData *jsonBodySerialized = [NSJSONSerialization dataWithJSONObject:jsonBody options:kNilOptions error:&error];
	
	// set header stuff
	[request setHTTPMethod:@"POST"];
	request.timeoutInterval = 10.0;
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:jsonBodySerialized];
	
	// session configuration
	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:NULL delegateQueue:[NSOperationQueue mainQueue]];
	
	// actual task queue to make request
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request
																					completionHandler:^(
																															NSData * _Nullable data,
																															NSURLResponse * _Nullable response,
																															NSError * _Nullable error
																															){
																						NSLog(@"------Completed request------");
																						
																							// if this was a non json response we would use
																							// NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
																						
																							// for json do this
																						@try { // try to save the data from response
																							
																							NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
																							NSLog(@"Response is: %@", jsonResponse);
																							
																								// set api key to plist file
																							NSError *plistError;
																							NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
																							NSString *documentsPath = [paths objectAtIndex:0]; // first document
																							NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"];
																							NSLog(@"Plist dir is: %@", plistPath);
																							
																							NSFileManager *fileManager = [NSFileManager defaultManager];
																							if ( ![fileManager fileExistsAtPath:plistPath] ){
																								NSString *mBundle = [[NSBundle mainBundle] pathForResource:@"token" ofType:@"plist"];
																								[fileManager copyItemAtPath:mBundle toPath:plistPath error:&plistError];
																							}
																							
																							NSMutableDictionary *dataToWrite = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
																							[dataToWrite setObject:jsonResponse[@"api_access_token"] forKey:@"api_token"];
																							[dataToWrite writeToFile:plistPath atomically:TRUE];
																							
																						} @catch (NSException *exception) {
																							NSLog(@"error performing request: %@", exception);
																						} @finally {
																							NSLog(@"Reached finally...");
																						}
																						
																					}];
	[task resume];
}

- (IBAction)readFromPlist:(id)sender {
	NSLog(@"Token from plist: %@", [self readSavedToken]);
}

- (NSString *)readSavedToken {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsPath = [paths objectAtIndex:0]; // first document
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"];
	
	NSMutableDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	return [plistContents objectForKey:@"api_token"];
}

- (NSMutableDictionary *)requestTos {
	NSString *baseUri = @"http://localhost:8090";
	NSString *endpoint = @"/accept_tos";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUri, endpoint]]];
	
	// no json body necessary as it is get request
}

@end
