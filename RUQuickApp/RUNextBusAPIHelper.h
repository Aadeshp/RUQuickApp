//
//  RUNextBusAPIHelper.h
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUNextBusAPIHelper : NSObject

+ (NSURL *)GETRoute:(NSString *)route;
+ (NSURL *)GETStop:(NSString *)stop;
+ (NSURL *)GETActiveRoutes;
+ (NSURL *)GETBusLocations;

+ (void)GETWithURL:(NSURL *)url
        completion:(void(^)(id))completion;

@end
