//
//  StateDataViewController.m
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/23/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import "StateDataViewController.h"

@interface StateDataViewController ()
@end


@implementation StateDataViewController
@synthesize stateDataDict;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setStateData];
	[self setContainerProperties];
	//self.pieChartContainer.stringPassed = @"Yo whats up from View Controller!";
	[self setPieChartData];

	
	// figure out circle overlay
	// CLLocationCoordinate2D center = { 39.0f, -74.0f };
	// MKCircle *currentStateCircle = [MKCircle circleWithCenterCoordinate:center radius:150000];
	//
	// [self.stateMapView addOverlay:currentStateCircle];
	
	self.overlayedMapViewOutlet.layer.masksToBounds = TRUE;
	self.overlayedMapViewOutlet.layer.cornerRadius = 8.0f;
	
	CLLocationDistance radius = 150000.0f;
	MKCoordinateSpan span;
	MKCoordinateRegion region;
	CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake(44.068203, -114.742043);
	
	span.latitudeDelta = 5;
	span.longitudeDelta = 5;
	
	region.span = span;
	region.center = centerLocation;
	
	MKCircle *circle = [MKCircle circleWithCenterCoordinate:centerLocation radius:radius];
	// in order for the overlay to appear, we have to drag the map view to the controller button on top of the screen and add view controller as delegate
	[self.overlayedMapViewOutlet setRegion:region animated:TRUE];
	[self.overlayedMapViewOutlet addOverlay:circle];
}

- (void)setStateData {
	NSLog(@"Positive cases value in controller--------: %@", [self.stateDataDict objectForKey:@"positive"]);
	self.stateName.text = [self.stateDataDict objectForKey:@"state_name"];
	self.dateUpdated.text = [NSString stringWithFormat:@"Updated: %@", [self.stateDataDict objectForKey:@"date"]];
	self.positive.text = [NSString stringWithFormat:@"%@", [self.stateDataDict objectForKey:@"positive"]];
	self.recovered.text = [NSString stringWithFormat:@"%@", [self.stateDataDict objectForKey:@"recovered"]];
	self.deaths.text = [NSString stringWithFormat:@"%@", [self.stateDataDict objectForKey:@"deaths"]];
}

- (void)setContainerProperties {
	self.stateDataContainer.layer.cornerRadius = 8.0f;
	// setting pie chart card inside drawRect
	//self.statePieChartContainer.layer.cornerRadius = 8.0f;
}

- (void)setPieChartData {
	NSLog(@"Positive cases value in controller: %@", [self.stateDataDict objectForKey:@"positive"]);
	//self.pieChartContainer.positiveCases = [self.stateDataDict objectForKey:@"positive"];
	//self.pieChartContainer.recoveredCases = [self.stateDataDict objectForKey:@"recovered"];
	//self.pieChartContainer.deathCases = [self.stateDataDict objectForKey:@"deaths"];
	self.pieChartContainer.dataTotal = [[self.stateDataDict objectForKey:@"positive"] doubleValue]
																		 +
																		 [[self.stateDataDict objectForKey:@"recovered"] doubleValue]
																		 +
																		 [[self.stateDataDict objectForKey:@"deaths"] doubleValue];
	self.pieChartContainer.positiveCases = [[self.stateDataDict objectForKey:@"positive"] intValue];
	self.pieChartContainer.recoveredCases = [[self.stateDataDict objectForKey:@"recovered"] intValue];
	self.pieChartContainer.deathCases = [[self.stateDataDict objectForKey:@"deaths"] intValue];
}

//#pragma mark - Navigation
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//	MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
//	[circleView setFillColor:[UIColor redColor]];
//	[circleView setStrokeColor:[UIColor greenColor]];
//	[circleView setAlpha:1.0f];
//	return circleView;
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	MKCircle *circle = overlay;
	MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:circle];
	circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.7f];
	circleView.lineWidth = 3;
	return circleView;
}

@end
