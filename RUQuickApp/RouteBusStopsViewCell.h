//
//  RouteBusStopsViewCell.h
//  RUNextBusApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteBusStopsViewCell : UITableViewCell

@property (nonatomic) UILabel *stopLabel;
@property (nonatomic) UILabel *predictionLabel;

- (void)setPredictionText:(NSMutableArray *)predictions;

@end