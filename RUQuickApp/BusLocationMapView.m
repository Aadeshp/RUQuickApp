//
//  BusLocationMapView.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "BusLocationMapView.h"
#import <MapKit/MapKit.h>

@implementation BusLocationMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self baseInit];
    
    return self;
}

- (void)baseInit
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    mapView.showsUserLocation = YES;
    
    [self addSubview:mapView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
