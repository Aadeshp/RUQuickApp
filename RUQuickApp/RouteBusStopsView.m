//
//  RouteBusStopsView.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RouteBusStopsView.h"
#import "RUNextBusAPIHelper.h"
#import "BusLocationMapView.h"
#import <CoreLocation/CoreLocation.h>
#import "RouteBusStopsViewCell.h"

#define SECTION_HEIGHT 50.0f

#define HALF_MINUTE 30.0f

@interface RouteBusStopsView() <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSString *currentRoute;

@property (nonatomic) NSMutableArray *busStops;
@property (nonatomic) NSMutableArray *busStopPredictions;

@property (nonatomic) NSMutableDictionary *stops;

@property (nonatomic, strong) UITableView *busStopsTableView;

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation RouteBusStopsView

- (instancetype)initWithFrame:(CGRect)frame
                     andRoute:(NSString *)route
{
    if (self = [super initWithFrame:frame]) {
        _currentRoute = route;
        
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit
{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        [self insertSubview:blurView atIndex:0];
    } else
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.7];
        
    [self retrieveBusStopData];
    
    //Update Bus Predictions Every 30 Seconds
    [NSTimer scheduledTimerWithTimeInterval:HALF_MINUTE
                                     target:self
                                   selector:@selector(updateTableView:)
                                   userInfo:nil
                                    repeats:YES];
}

- (IBAction)updateTableView:(id)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RUNextBusAPIHelper GETWithURL:[RUNextBusAPIHelper GETRoute:_currentRoute]
                            completion:^(id json) {
                                for (NSDictionary *busStop in json) {
                                    NSMutableArray *predictions = [[NSMutableArray alloc] init];
                                    
                                    for (NSDictionary *prediction in busStop[@"predictions"])
                                        [predictions addObject:prediction[@"minutes"]];
                                    
                                    [weakSelf.stops setObject:predictions forKey:busStop[@"title"]];
                                }
                                
                                [weakSelf.busStopsTableView reloadData];
                            }];
    });

}

- (void)retrieveBusStopData
{
    _busStops = [[NSMutableArray alloc] init];
    _stops = [[NSMutableDictionary alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [RUNextBusAPIHelper GETWithURL:[RUNextBusAPIHelper GETRoute:_currentRoute]
                        completion:^(id json) {
                            for (NSDictionary *busStop in json) {
                                NSMutableArray *predictions = [[NSMutableArray alloc] init];
                                
                                for (NSDictionary *prediction in busStop[@"predictions"])
                                    [predictions addObject:prediction[@"minutes"]];
                                
                                [weakSelf.stops setObject:predictions forKey:busStop[@"title"]];
                                [weakSelf.busStops addObject:busStop[@"title"]];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf addTableView];
                            });
                        }];
}

- (void)addTableView
{
    _busStopsTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView;
    });
    
    [self addSubview:_busStopsTableView];
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SECTION_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_busStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RouteCell";
    
    RouteBusStopsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
        cell = [[RouteBusStopsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *stop = [_busStops objectAtIndex:indexPath.row];
    cell.stopLabel.text = [_busStops objectAtIndex:indexPath.row];
    [cell setPredictionText:[_stops objectForKey:stop]];
    
    return cell;
}

@end
