//
//  NSString+GooglePolyline.m
//  GoogleRoute
//
//  Created by Vitaly Evtushenko on 17.02.12.
//  Copyright (c) 2012 AshberrySoft LLC. All rights reserved.
//

#import "NSString+GooglePolyline.h"

#import <CoreLocation/CoreLocation.h>

@implementation NSString (GooglePolyline)

- (NSArray*)googleWaypoints
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[self length]];  
    [encoded appendString:self];  
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"  
                                options:NSLiteralSearch  
                                  range:NSMakeRange(0, [encoded length])];  
    NSInteger len = [encoded length];  
    NSInteger index = 0;  
    NSMutableArray *array = [[NSMutableArray alloc] init];  
    NSInteger lat=0;  
    NSInteger lng=0;  
    while (index < len) {  
        NSInteger b;  
        NSInteger shift = 0;  
        NSInteger result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lat += dlat;  
        shift = 0;  
        result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lng += dlng;  
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];  
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];  
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];  
        [array addObject:loc];  
    }   
    return array;  
}

@end
