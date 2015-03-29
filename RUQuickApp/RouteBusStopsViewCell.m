//
//  RouteBusStopsViewCell.m
//  RUQuickApp
//
//  Created by Aadesh Patel on 3/28/15.
//  Copyright (c) 2015 Aadesh Patel. All rights reserved.
//

#import "RouteBusStopsViewCell.h"

#define STOP_LABEL_FONT_SIZE 22.0f
#define PREDICTION_LABEL_FONT_SIZE 15.0f

#define X_OFFSET 10.0f
#define Y_OFFSET 3.0f
#define HEIGHT_ADDITION 5.0f

#define LIMIT_RED 2
#define LIMIT_ORANGE 5

static NSString *const kDefaultFont = @".HelveticaNeueInterface-Regular";

@implementation RouteBusStopsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addStopLabel];
        [self addPredictionLabel];
    }
    
    return self;
}

- (void)addStopLabel
{
    self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET, Y_OFFSET, self.frame.size.width, self.frame.size.height / 2 + HEIGHT_ADDITION)];
    self.stopLabel.font = [UIFont fontWithName:kDefaultFont
                                          size:STOP_LABEL_FONT_SIZE];
    self.stopLabel.textColor = [UIColor blackColor];
    
    [self addSubview:self.stopLabel];
}

- (void)addPredictionLabel
{
    self.predictionLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET, self.frame.size.height / 2 + HEIGHT_ADDITION, self.frame.size.width, self.frame.size.height / 2)];
    self.predictionLabel.font = [UIFont boldSystemFontOfSize:PREDICTION_LABEL_FONT_SIZE];
    self.predictionLabel.textColor = [UIColor blackColor];
    
    [self addSubview:self.predictionLabel];
}

- (void)setPredictionText:(NSMutableArray *)predictions
{
    if ([[predictions objectAtIndex:0] isEqualToString:@"0"])
        [predictions replaceObjectAtIndex:0 withObject:@"<1"];
    
    self.predictionLabel.text  = [predictions componentsJoinedByString:@", "];

    NSInteger nextPrediction = [(NSString *)[predictions objectAtIndex:0] integerValue];
    
    UIColor *textColor;
    
    if (nextPrediction <= LIMIT_RED)
        textColor = [UIColor redColor];
    else if (nextPrediction <= LIMIT_ORANGE)
        textColor = [UIColor orangeColor];
    else
        textColor = [UIColor blueColor];
    
    self.predictionLabel.textColor = textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
