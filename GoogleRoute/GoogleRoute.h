//
//  GoogleRoute.h
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BaseStepLeg : NSObject
@property (nonatomic, strong) NSString *distanceText;
@property (nonatomic, assign) NSInteger distanceValue;
@property (nonatomic, strong) NSString *durationText;
@property (nonatomic, assign) NSInteger durationValue;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;
@end


@interface Step : BaseStepLeg
@property (nonatomic, strong) NSString *htmlInstructions;
@property (nonatomic, strong) NSString *travelMode;
@property (nonatomic, strong) NSArray *polyline; //array of CLLocation obects
@end


@interface Leg : BaseStepLeg 
@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) NSArray *steps; //Array of Step objects
@end


@interface GoogleRoute : NSObject
@property (nonatomic, strong) CLLocation *boundsNortheast;
@property (nonatomic, strong) CLLocation *boundsSouthwest;
@property (nonatomic, strong) NSString *copyrights;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSArray *overviewPolyline; //array of CLLocation obects
@property (nonatomic, strong) NSArray *legs; //Array of Leg objects
- (MKCoordinateRegion)region;
@end
