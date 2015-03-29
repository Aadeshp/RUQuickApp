//
//  RUNextBusViewController.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RUNextBusViewController.h"
#import "RUNextBusAPIHelper.h"
#import "RouteBusStopsView.h"

#define SECTION_HEIGHT 70.0f

#define ANIMATION_DURATION 0.5f

@interface RUNextBusViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *busTableView;

@property (nonatomic) __block NSMutableDictionary *activeRoutes;

@end

@implementation RUNextBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _activeRoutes = [[NSMutableDictionary alloc] init];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    [RUNextBusAPIHelper GETWithURL:[RUNextBusAPIHelper GETActiveRoutes]
                        completion:^(id json) {
                            for (NSDictionary *route in json[@"routes"]) {
                                [weakSelf.activeRoutes setObject:route[@"tag"]
                                                          forKey:route[@"title"]];
                            }
                        
                            dispatch_semaphore_signal(semaphore);
                        }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"New Brunswick - Active Routes";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedRoute = [_activeRoutes objectForKey:[[_activeRoutes allKeys] objectAtIndex:indexPath.row]];
    RouteBusStopsView *view = [[RouteBusStopsView alloc] initWithFrame:self.view.bounds andRoute:selectedRoute];
    view.alpha = 0.0f;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        view.alpha = 1.0f;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_activeRoutes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BusCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [[_activeRoutes allKeys] objectAtIndex:indexPath.row];
    
    return cell;
}

@end
