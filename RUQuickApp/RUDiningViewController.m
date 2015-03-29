//
//  RUDiningViewController.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RUDiningViewController.h"
#import "RUDiningAPIHelper.h"

#define SECTION_HEIGHT 50.0f

@interface RUDiningViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *diningTableView;

@property (nonatomic) NSMutableArray *diningHalls;
@property (nonatomic) NSMutableDictionary *meals;

@end

@implementation RUDiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _diningHalls = [[NSMutableArray alloc] init];
    _meals = [[NSMutableDictionary alloc] init];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    [RUDiningAPIHelper GETWithURL:[RUDiningAPIHelper GETDiningMenu]
                       completion:^(id json) {
                           for (NSDictionary *hall in json) {
                               NSString *location = hall[@"location_name"];
                               
                               [weakSelf.diningHalls addObject:location];
                               
                               NSArray *meals = hall[@"meals"];
                               
                               NSMutableArray *items = [[NSMutableArray alloc] init];
                               for (NSDictionary *meal in meals) {
                                   if (meal[@"genres"]) {
                                       NSArray *genres = meal[@"genres"];
                                       
                                       for (NSDictionary *genre in genres) {
                                           for (NSString *item in genre[@"items"]) {
                                               [items addObject:item];
                                           }
                                       }
                                   }
                               }
                               
                               [weakSelf.meals setObject:items forKey:location];
                           }
                           
                           dispatch_semaphore_signal(semaphore);
                       }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [_diningHalls objectAtIndex:section];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_diningHalls count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_meals objectForKey:[_diningHalls objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DiningCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [[_meals objectForKey:[_diningHalls objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    return cell;
}


@end
