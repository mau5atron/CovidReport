//
//  ViewController.m
//  CovidReport
//
//  Created by Gabriel Betancourt on 9/8/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import "WorldViewController.h"
#import "USStateDataTableViewController.h"

@interface WorldViewController ()

@property (retain, readwrite) USStateDataTableViewController *stateDataTableViewControllerPtr;
@end

@implementation WorldViewController
@synthesize stateDataDict;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// [self buildTermsOfUsePopop];
	// on load we need to make the token checks
	deviceWidth = CGRectGetWidth(self.view.bounds);
	deviceHeight = CGRectGetHeight(self.view.bounds);
	unsigned int leftInset = self.view.safeAreaInsets.left;
	self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, deviceHeight, deviceWidth, deviceHeight - 300);
	[self checkForValidTokenFunc]; // inside this function we need to work out the bit response from the server
	
	// self.tableViewContainerOutlet.layer.hidden = TRUE;
	self.tableViewContainerOutlet.layer.zPosition = -1.0f;
	
	// this stateDataDict will get set by the request through the api
	self.stateDataDict = @{
												 @"CA": @{@"positive": @2, @"recovered": @3, @"deaths": @4, @"date": @"9/27/2020", @"state_abbrev": @"CA", @"state_name": @"California"},
												 @"FL": @{@"positive": @400, @"recovered": @30, @"deaths": @340, @"date": @"9/27/2020", @"state_abbrev": @"FL", @"state_name": @"Florida"}
											 };
	// time to make api request
	self.stateDataTableViewControllerPtr.stateDataDict = self.stateDataDict;
}

// Actions *****************************************

- (IBAction)getApiToken:(id)sender {
	
	// prepare endpoint request
	//NSString *baseUri = @"http://localhost:8090";
	NSString *baseUri = @"http://192.168.0.74:8090";
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
	NSURLSessionDataTask *task = [
			  session dataTaskWithRequest:request
			  completionHandler:^(
			  NSData * _Nullable data,
			  NSURLResponse * _Nullable response,
			  NSError * _Nullable error
			){
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
					// If the plist for the token does not exists, then copy the file from mainBundle to documents
					if ( ![fileManager fileExistsAtPath:plistPath] ){
						NSString *mBundle = [[NSBundle mainBundle] pathForResource:@"token" ofType:@"plist"];
						[fileManager copyItemAtPath:mBundle toPath:plistPath error:&plistError];
					}
					
					NSMutableDictionary *dataToWrite = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
					[dataToWrite setObject:jsonResponse[@"api_access_token"] forKey:@"api_token"];
					[dataToWrite writeToFile:plistPath atomically:TRUE];
					NSLog(@"------Completed request------");
					NSLog(@"Token saved... breaking down popup");
					[self teardownTermsPopup];
				} @catch (NSException *exception) {
					NSLog(@"error performing request: %@", exception);
				}
			}
	];
	[task resume];
}

- (IBAction)teardownTermsPopup {
	deviceWidth = CGRectGetWidth(self.view.bounds);
	deviceHeight = CGRectGetHeight(self.view.bounds);
	__block unsigned int leftInset = self.view.safeAreaInsets.left;
	
	NSLog(@"Device width: %.2f", deviceWidth);

	// initial position - dont need to set this, will resolve to animation
	// self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, deviceHeight, deviceWidth, deviceHeight - 300);
	
		// apply transparency if reduce transparency is not enabled
	if ( !UIAccessibilityIsReduceTransparencyEnabled() ){ // check if reduce transparency setting is disabled
		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		visualEffectView.frame = self.acceptTermsPopupViewOutlet.bounds;
		visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		visualEffectView.layer.cornerRadius = 10.0;
		visualEffectView.layer.masksToBounds = TRUE; // clips the edges so that corner radius is noticeable
			// [self.acceptTermsPopupViewOutlet addSubview:visualEffectView]; // this does not work
		[self.acceptTermsPopupViewOutlet insertSubview:visualEffectView atIndex:0];
	}
	
		// handling animation
	[UIView animateWithDuration:0.5f delay:0.5f options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn animations:^{
		NSLog(@"Device height before teardown: %.2f", self->deviceHeight); // 896 xs max
		// device height seems to teardown the popup perfectly
		self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, self->deviceHeight, self->deviceWidth, self->deviceHeight - 300);
	} completion:^(BOOL finished){
		NSLog(@"Finished animation");
	}];
	
	self.acceptTermsPopupViewOutlet.layer.cornerRadius = 10.0;
}

// Functions *************************************************

- (NSString *)readSavedToken {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsPath = [paths objectAtIndex:0]; // first document
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"];
	
	NSMutableDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	return [plistContents objectForKey:@"api_token"];
}

- (void)requestTos {
	// request setup
	// NSString *baseUri = @"http://localhost:8090";
	NSString *baseUri = @"http://192.168.0.74:8090";
	NSString *endpoint = @"/terms_of_service";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUri, endpoint]]];
	
	// no json body necessary as it is get request
	[request setHTTPMethod:@"GET"];
	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:NULL delegateQueue:[NSOperationQueue mainQueue]];
	
	// storing json
	__block NSMutableDictionary *jsonResponse;
	
	// creating task to perform request
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
		self.termsOfServiceTextViewOutlet.editable = FALSE; // disable editing the textview
		@try {
			jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
			self.termsOfServiceTextViewOutlet.text = [jsonResponse objectForKey:@"terms_of_service"];
			// NSLog(@"API response: %@", [jsonResponse objectForKey:@"terms_of_service"]);
			self.getApiTokenBtnOutlet.enabled = TRUE;
		} @catch (NSException *exception) {
			// disble when not able to grab the terms of service
			self.getApiTokenBtnOutlet.enabled = FALSE;
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unabled to retrieve terms of service" message:@"Please try again later." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL];
			[alert addAction:defaultAction];
			[self presentViewController:alert animated:TRUE completion:NULL];
			NSLog(@"Error performing request: %@", exception);
		}
	}];
	[task resume];
}

- (void)checkForValidTokenFunc {
	NSLog(@"Starting check for token.....");
	//NSString *baseUri = @"http://localhost:8090";
	NSString *baseUri = @"http://192.168.0.74:8090";
	
	NSString *endPoint = @"/validate_token";
	
	// setup request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUri, endPoint]]];
	
	// setting up json to send to server
	// read token documents
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsPath = [paths objectAtIndex:0]; // first doc
	NSLog(@"Made it past documentsPath");
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"]; // path to plist
	NSError *plistError;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the plist for the token does not exists, then copy the file from mainBundle to documents
	if ( ![fileManager fileExistsAtPath:plistPath] ){
		NSString *mBundle = [[NSBundle mainBundle] pathForResource:@"token" ofType:@"plist"];
		[fileManager copyItemAtPath:mBundle toPath:plistPath error:&plistError];
	}

	/*
	 Upon new startup, the first action we perform is check if the token is valid
	 However, the token.plist might not already be copied into the documents folder
	 of the device, so first thing we need to do is make a check (like we do in that
	 other request and make a copy into device documents before trying to check if
	 token is valid, otherwise there will be an error
	 
	 plist contents is nil, need to copy over the plist from the main bundle
	*/
	
	// dictionary with plist contents
	NSMutableDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	// get saved token
	NSString *savedToken = [plistContents objectForKey:@"api_token"];
	
	// json to send
	NSDictionary *jsonBody = @{ @"token": savedToken };
	NSLog(@"Setting dictionary json: %@", jsonBody);
	NSError *error;
	// serialize json for transport
	NSData *jsonBodySerialized = [NSJSONSerialization dataWithJSONObject:jsonBody options:kNilOptions error:&error];
	
	// setting headers
	[request setHTTPMethod:@"POST"];
	request.timeoutInterval = 10.0f;
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:jsonBodySerialized];
	
	// session configuration before request
	NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:NULL delegateQueue:[NSOperationQueue mainQueue]];
	
	// task to perform request
	NSURLSessionDataTask *requestDataTask = [session
		dataTaskWithRequest:request
	 	completionHandler:^(
			NSData *data,
			NSURLResponse *response,
			NSError *error
		){
			
			@try {
				NSLog(@"Performing token check.......");
				NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
				NSNumber *responseBit = jsonResponse[@"token_valid"];
				NSLog(@"response to nsnumber: %@", responseBit);
				// handle bit response here
				// could also do [responseBit isEqualToNumber:0];
				if ( [responseBit intValue] == 0 ){
					// add animation here to hide the uiview container
					NSLog(@"Token is invalid!");
					 self.tableViewContainerOutlet.layer.hidden = TRUE;
					// [self showTermsPopup];
					[self buildTermsOfUsePopop];
				} else if ( [responseBit intValue] == 1 ) {
					NSLog(@"Token is valid");
					self.tableViewContainerOutlet.layer.hidden = FALSE;
					// add animation here to show the uiview container
				}
				
			} @catch (NSException *exception) {
				NSLog(@"Error performing token validation request: %@", exception);
				// if fails, display popup
				[self buildTermsOfUsePopop];
			}
		}
	];
	[requestDataTask resume];
}

- (void)buildTermsOfUsePopop {
	// [self settingExampleThing:@"yeah" addingSecondNamedParam:@"yeah"];
	/*
		when the app first loads, token.plist may not be in the documents folder on ios device
		therefore, we should copy the token.plist from the main bundle first before we try to write to it
		should be a check but dont have it run each time as it will overwrite the token.plist in the documents
		folder with a clean version from bundle if its already present in documents rather than copy to
  */
	
	deviceWidth = CGRectGetWidth(self.view.bounds);
	deviceHeight = CGRectGetHeight(self.view.bounds);
	__block unsigned int leftInset = self.view.safeAreaInsets.left;
	// CGFloat rightInset = self.view.safeAreaInsets.right;
	// CGFloat bottomInset = self.view.safeAreaInsets.bottom;
	NSLog(@"Device width: %.2f", deviceWidth);
	// self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, 300, deviceWidth, deviceHeight - 300); // where we want frame to be on screen
	// self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, deviceHeight - 10, deviceWidth, deviceHeight - 300);
	self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, deviceHeight, deviceWidth, deviceHeight - 300); // initial position
	
	// apply transparency if reduce transparency is not enabled
	if ( !UIAccessibilityIsReduceTransparencyEnabled() ){ // check if reduce transparency setting is disabled
		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		visualEffectView.frame = self.acceptTermsPopupViewOutlet.bounds;
		visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		visualEffectView.layer.cornerRadius = 10.0;
		visualEffectView.layer.masksToBounds = TRUE; // clips the edges so that corner radius is noticeable
		// [self.acceptTermsPopupViewOutlet addSubview:visualEffectView]; // this does not work
		[self.acceptTermsPopupViewOutlet insertSubview:visualEffectView atIndex:0];
	}
	
		// handling animation
	[UIView animateWithDuration:0.5f delay:0.5f options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn animations:^{
		self.acceptTermsPopupViewOutlet.frame = CGRectMake(leftInset, 300, self->deviceWidth, self->deviceHeight - 300);
	} completion:^(BOOL finished){
		NSLog(@"Finished animation");
	}];
	
	self.acceptTermsPopupViewOutlet.layer.cornerRadius = 10.0;
		// self.getApiTokenBtnOutlet.frame = CGRectMake(100, 50, 50, 30);
	[self requestTos]; // only call this when we are rendering the popup
}

//- (void)settingExampleThing:(NSString *)someStringAdded addingSecondNamedParam:(NSString *)someOtherString {
//	
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showStateDataTableView"]){
		NSLog(@"Segue for table view from US View");
		/*
		 creating USStateDataTableViewController instance
		 assigning instance to ptr in WorldViewController property to retain it and assign it the
		 instances stateDataArray in viewDidLoad
		*/
	
		USStateDataTableViewController *stateDataTableViewController = [segue destinationViewController];
		// reference view controller instance so we can use in viewDidLoad
		self.stateDataTableViewControllerPtr = stateDataTableViewController;
	}
}

- (void)getLatestUSCovidData {
	// make request///
	
}

@end
