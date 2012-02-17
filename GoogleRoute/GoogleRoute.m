//
//  GoogleRoute.m
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import "GoogleRoute.h"

@implementation BaseStepLeg
@synthesize distanceText;
@synthesize distanceValue;
@synthesize durationText;
@synthesize durationValue;
@synthesize startLocation;
@synthesize endLocation;
@end


@implementation Step
@synthesize htmlInstructions;
@synthesize polyline;
@synthesize travelMode;
@end


@implementation Leg
@synthesize startAddress;
@synthesize endAddress;
@synthesize steps;
@end


@implementation GoogleRoute
@synthesize boundsNortheast;
@synthesize boundsSouthwest;
@synthesize copyrights;
@synthesize summary;
@synthesize overviewPolyline;
@synthesize legs;

- (MKCoordinateRegion)region
{
    CLLocationCoordinate2D centerCoordinate = 
        CLLocationCoordinate2DMake((self.boundsNortheast.coordinate.latitude + self.boundsSouthwest.coordinate.latitude) / 2.0, 
                                   (self.boundsNortheast.coordinate.longitude + self.boundsSouthwest.coordinate.longitude) / 2.0);

    MKCoordinateSpan span =
        MKCoordinateSpanMake(fabs((self.boundsNortheast.coordinate.latitude - self.boundsSouthwest.coordinate.latitude)),
                             fabs((self.boundsNortheast.coordinate.longitude - self.boundsSouthwest.coordinate.longitude)));
    
    return MKCoordinateRegionMake(centerCoordinate, span);
}

@end
