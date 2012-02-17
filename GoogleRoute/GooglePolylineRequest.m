//
//  GooglePolylineRequest.m
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import "GooglePolylineRequest.h"
#import "SBJson.h"
#import "GoogleRoute.h"
#import "NSString+GooglePolyline.h"

@implementation GooglePolylineRequest

@synthesize delegate;

- (BOOL)requestPolylineFromPoint:(CLLocation *)fromPoint toPoint:(CLLocation *)toPoint
{
    if (!fromPoint || !toPoint) return FALSE;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%0.06f,%0.06f&destination=%0.06f,%0.06f&sensor=true", fromPoint.coordinate.latitude, fromPoint.coordinate.longitude, toPoint.coordinate.latitude, toPoint.coordinate.longitude];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] 
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                 timeoutInterval:15.0];
    
    NSURLConnection *connction = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    return connction != nil;
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _responseData = nil;
    if ([delegate respondsToSelector:@selector(googlePolylineRequest:didFailWithError:)])
    {
        [delegate googlePolylineRequest:self didFailWithError:error];
    }
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *stringResponse = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    _responseData = nil;
    
    NSDictionary *response = [stringResponse JSONValue];
    
    if (![[response valueForKey:@"status"] isEqualToString:@"OK"])
    {
        if ([delegate respondsToSelector:@selector(googlePolylineRequest:didFailWithError:)])
        {
            [delegate googlePolylineRequest:self 
                           didFailWithError:[NSError errorWithDomain:@"GooglePolylineRequest" 
                                                                code:1 
                                                            userInfo:[NSDictionary dictionaryWithObject:[response valueForKey:@"status"] 
                                                                                                 forKey:NSLocalizedDescriptionKey]]];
        }
        return;
    }
    
    NSArray *routes = [response valueForKey:@"routes"];
    NSMutableArray *groutes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *route in routes)
    {
        GoogleRoute *groute = [[GoogleRoute alloc] init];
        
        NSDictionary *bounds = [route valueForKey:@"bounds"];
        groute.boundsNortheast = [[CLLocation alloc] initWithLatitude:[[[bounds valueForKey:@"northeast"] valueForKey:@"lat"] doubleValue]
                                                            longitude:[[[bounds valueForKey:@"northeast"] valueForKey:@"lng"] doubleValue]];
        groute.boundsSouthwest = [[CLLocation alloc] initWithLatitude:[[[bounds valueForKey:@"southwest"] valueForKey:@"lat"] doubleValue]
                                                            longitude:[[[bounds valueForKey:@"southwest"] valueForKey:@"lng"] doubleValue]];
        
        groute.copyrights = [route valueForKey:@"copyrights"];
        groute.summary = [route valueForKey:@"summary"];
        groute.overviewPolyline = [[[route valueForKey:@"overview_polyline"] valueForKey:@"points"] googleWaypoints];
        
        NSArray *legs = [route valueForKey:@"legs"];
        NSMutableArray *glegs = [[NSMutableArray alloc] init];
        for (NSDictionary *leg in legs)
        {
            Leg *gleg = [[Leg alloc] init];
            gleg.distanceText = [[leg valueForKey:@"distance"] valueForKey:@"text"];
            gleg.distanceValue = [[[leg valueForKey:@"distance"] valueForKey:@"value"] integerValue];
            gleg.durationText = [[leg valueForKey:@"duration"] valueForKey:@"text"];
            gleg.durationValue = [[[leg valueForKey:@"duration"] valueForKey:@"value"] integerValue];
            gleg.startAddress = [leg valueForKey:@"start_address"];
            gleg.endAddress = [leg valueForKey:@"end_address"];
            gleg.startLocation = [[CLLocation alloc] initWithLatitude:[[[leg valueForKey:@"start_location"] valueForKey:@"lat"] doubleValue]
                                                            longitude:[[[leg valueForKey:@"start_location"] valueForKey:@"lng"] doubleValue]];
            gleg.endLocation = [[CLLocation alloc] initWithLatitude:[[[leg valueForKey:@"end_location"] valueForKey:@"lat"] doubleValue]
                                                          longitude:[[[leg valueForKey:@"end_location"] valueForKey:@"lng"] doubleValue]];
            
            NSArray *steps = [leg valueForKey:@"steps"];
            NSMutableArray *gsteps = [[NSMutableArray alloc] init];
            for (NSDictionary *step in steps)
            {
                Step *gstep = [[Step alloc] init];
                gstep.distanceText = [[step valueForKey:@"distance"] valueForKey:@"text"];
                gstep.distanceValue = [[[step valueForKey:@"distance"] valueForKey:@"value"] integerValue];
                gstep.durationText = [[step valueForKey:@"duration"] valueForKey:@"text"];
                gstep.durationValue = [[[step valueForKey:@"duration"] valueForKey:@"value"] integerValue];
                gstep.startLocation = [[CLLocation alloc] initWithLatitude:[[[step valueForKey:@"start_location"] valueForKey:@"lat"] doubleValue]
                                                                 longitude:[[[step valueForKey:@"start_location"] valueForKey:@"lng"] doubleValue]];
                gstep.endLocation = [[CLLocation alloc] initWithLatitude:[[[step valueForKey:@"end_location"] valueForKey:@"lat"] doubleValue]
                                                               longitude:[[[step valueForKey:@"end_location"] valueForKey:@"lng"] doubleValue]];
                gstep.htmlInstructions = [step valueForKey:@"html_instructions"];
                gstep.travelMode = [step valueForKey:@"travel_mode"];
                gstep.polyline = [[[step valueForKey:@"polyline"] valueForKey:@"points"] googleWaypoints];
                [gsteps addObject:gstep];
            }
            gleg.steps = gsteps;
            [glegs addObject:gleg];
        }
        groute.legs = glegs;
        [groutes addObject:groute];
    }
    if ([delegate respondsToSelector:@selector(googlePolylineRequest:didFindRoutes:)])
    {
        [delegate googlePolylineRequest:self didFindRoutes:groutes];
    }
}

@end
