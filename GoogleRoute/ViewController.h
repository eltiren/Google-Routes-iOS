//
//  ViewController.h
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePolylineRequest.h"
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <GooglePolylineRequestDelegate, MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIBarButtonItem *barButton;
    __weak IBOutlet UIBarButtonItem *barButton2;
}

@end
