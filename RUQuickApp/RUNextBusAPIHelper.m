//
//  RUNextBusAPIHelper.m
//  RUNextBusApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RUNextBusAPIHelper.h"

static NSString *const kRUNextBusBaseURL = @"http://runextbus.heroku.com/";

@implementation RUNextBusAPIHelper

+ (NSURL *)GETRoute:(NSString *)route
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@route/%@", kRUNextBusBaseURL, route]];
}

+ (NSURL *)GETStop:(NSString *)stop
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@stop/%@", kRUNextBusBaseURL, stop]];
}

+ (NSURL *)GETActiveRoutes
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@active", kRUNextBusBaseURL]];
}

+ (NSURL *)GETBusLocations
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@locations", kRUNextBusBaseURL]];
}

+ (void)GETWithURL:(NSURL *)url
        completion:(void(^)(id))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error)
                                                    NSLog(@"Connection Error: %@", error.description);
                                                else {
                                                    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                    
                                                    completion(json);
                                                }
                                            }];
    [task resume];
}

@end
