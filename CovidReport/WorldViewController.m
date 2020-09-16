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
																	NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
																	NSLog(@"Response is: %@", jsonResponse);
																	// get status or token
																	// NSLog(@"Response is: %@", jsonResponse[@"accepted_tos_status"]);
																	
																	// get error if any
																	// NSLog(@"Response is: %@", jsonResponse[@"error"]);
																}];
	[task resume];
}

@end
