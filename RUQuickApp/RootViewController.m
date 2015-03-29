//
//  RootViewController.m
//  RUNextBusApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RootViewController.h"
#import "RUNextBusViewController.h"
#import "RUDiningViewController.h"

@interface RootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic) NSArray *viewControllers;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViewControllers];
    [self addPageViewController];
}

- (void)setUpViewControllers
{
    RUNextBusViewController *busVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RUNextBusVC"];
    RUDiningViewController *diningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RUDiningVC"];
    
    _viewControllers = [[NSArray alloc] initWithObjects:busVC, diningVC, nil];
}

- (void)addPageViewController
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:0]]
direction:UIPageViewControllerNavigationDirectionForward
animated:NO
                                 completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    CGRect bounds = self.view.bounds;
    _pageViewController.view.frame = bounds;
    
    [_pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static NSDictionary *viewControllerIndex;
+ (NSDictionary *)sharedViewControllerIndex
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewControllerIndex = @{
                                [[RUNextBusViewController class] copy] : @0,
                                [[RUDiningViewController class] copy]  : @1
                                };
    });
    
    return viewControllerIndex;
}

#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSNumber *NSIndex = [[RootViewController sharedViewControllerIndex] objectForKey:[viewController class]];
    NSUInteger index = (NSUInteger)[NSIndex integerValue];
    
    if (index == 0)
        return nil;
    
    index--;
    return [_viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSNumber *NSIndex = [[RootViewController sharedViewControllerIndex] objectForKey:[viewController class]];
    NSUInteger index = (NSUInteger)[NSIndex integerValue];
    
    if (index == [_viewControllers count] - 1)
        return nil;
    
    index++;
    return [_viewControllers objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0; //Hide UIPageControl
}

/*- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}*/

@end
