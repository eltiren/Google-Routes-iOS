//
//  ViewController.m
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import "ViewController.h"
#import "GoogleRoute.h"
#import "RouteAnnotation.h"
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CLLocation *from = [[CLLocation alloc] initWithLatitude:47.831474 longitude:35.164091];
    CLLocation *to = [[CLLocation alloc] initWithLatitude:54.989174 longitude:73.367127];
    
    GooglePolylineRequest *gpl = [[GooglePolylineRequest alloc] init];
    gpl.delegate = self;
    [gpl requestPolylineFromPoint:from toPoint:to];
}

- (void)viewDidUnload
{
    mapView = nil;
    barButton = nil;
    barButton2 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)googlePolylineRequest:(GooglePolylineRequest*)request didFailWithError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                               message:@"Нет данных от Google"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)googlePolylineRequest:(GooglePolylineRequest*)request didFindRoutes:(NSArray*)routes
{
    GoogleRoute *route = [routes lastObject];
    
    [mapView setRegion:[route region] animated:YES];
    
    NSMutableArray *polylines = [[NSMutableArray alloc] init];
    
    Leg *leg = [route.legs lastObject];
    
    for (Step *step in [leg steps])
    {
        RouteAnnotation *ann = [[RouteAnnotation alloc] initWithCoordinate:step.startLocation.coordinate
                                                                  andTitle:step.htmlInstructions];
        [mapView addAnnotation:ann];
        [polylines addObjectsFromArray:step.polyline];
    }
    
    /*
    NSArray *points = route.overviewPolyline;
    int pointsCount = [points count];
     */

    NSArray *points = polylines;
    int pointsCount = [polylines count];
    
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * pointsCount);
    
    for (int i=0; i< pointsCount; ++i)
    {
        CLLocation *loc = [points objectAtIndex:i];
        coords[i] = loc.coordinate;
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:pointsCount];
    
    free(coords);
    
    [mapView addOverlay:polyline];
    
    Step *step = [[leg steps] lastObject];
    RouteAnnotation *ann = [[RouteAnnotation alloc] initWithCoordinate:step.endLocation.coordinate
                                                              andTitle:@"End of route"];
    [mapView addAnnotation:ann];
    
    barButton.title = leg.distanceText;
    barButton2.title = leg.durationText;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:overlay];
        view.fillColor = [UIColor blueColor];
        view.strokeColor = [UIColor blueColor];
        view.lineWidth = 3.0f;
        return view;
    }
    
    return nil;
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    view.pinColor = MKPinAnnotationColorGreen;
    view.canShowCallout = YES;
    return view;
}

@end
