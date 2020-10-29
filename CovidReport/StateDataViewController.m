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


@end
