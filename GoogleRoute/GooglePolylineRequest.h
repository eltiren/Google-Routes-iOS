//
//  GooglePolylineRequest.h
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GooglePolylineRequest;

@protocol GooglePolylineRequestDelegate <NSObject>

- (void)googlePolylineRequest:(GooglePolylineRequest*)request didFailWithError:(NSError*)error;
- (void)googlePolylineRequest:(GooglePolylineRequest*)request didFindRoutes:(NSArray*)routes;

@end

@interface GooglePolylineRequest : NSObject
{
    @private
    NSMutableData *_responseData;
}

@property (nonatomic, unsafe_unretained) id<GooglePolylineRequestDelegate> delegate;

- (BOOL)requestPolylineFromPoint:(CLLocation *)fromPoint toPoint:(CLLocation *)toPoint;

@end
