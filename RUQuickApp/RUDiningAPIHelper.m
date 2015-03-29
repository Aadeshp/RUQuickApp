//
//  RUDiningAPIHelper.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RUDiningAPIHelper.h"

static NSString *const kRUDiningBaseURl = @"https://rumobile.rutgers.edu/";

@implementation RUDiningAPIHelper

+ (NSURL *)GETDiningMenu
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@1/rutgers-dining.txt", kRUDiningBaseURl]];
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
