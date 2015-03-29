//
//  RUDiningAPIHelper.h
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUDiningAPIHelper : NSObject

+ (NSURL *)GETDiningMenu;

+ (void)GETWithURL:(NSURL *)url
        completion:(void(^)(id))completion;

@end
