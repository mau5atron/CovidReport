//
//  StateDataViewController.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/23/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Graphics/DrawPieChart.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StateDataViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *stateDataDict;
@property (weak, nonatomic) IBOutlet UIView *stateDataContainer;
@property (weak, nonatomic) IBOutlet DrawPieChart *pieChartContainer;
@property (weak, nonatomic) IBOutlet UILabel *stateName;
@property (weak, nonatomic) IBOutlet UILabel *dateUpdated;
@property (weak, nonatomic) IBOutlet UILabel *positive;
@property (weak, nonatomic) IBOutlet UILabel *recovered;
@property (weak, nonatomic) IBOutlet UILabel *deaths;
@property (weak, nonatomic) IBOutlet MKMapView *stateMapView;

- (void)setStateData;
- (void)setContainerProperties;
- (void)setPieChartData;

@end

NS_ASSUME_NONNULL_END
