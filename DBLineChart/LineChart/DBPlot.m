//
//  DBPlot.m
//  DBLineChart
//
//  Created by bob on 2019/3/21.
//

#import "DBPlot.h"
#import "DBPlot+Calculate.h"


@implementation DBPlot

- (instancetype)init {
    self = [super init];
    if (self) {
        self.plotTitle = @"";
        self.showPointLabel = NO;
        self.pointLabelFormat = @"%.1f";
        self.pointLabelColor = [UIColor blackColor];
        self.pointLabelFont = [UIFont systemFontOfSize:9];
        self.pointRadius = 4.0f;
        self.pointColor = [UIColor blackColor];
        self.lineColor = [UIColor blackColor];
        self.lineWidth = 1.0f;
    }
    return self;
}

- (CGFloat)pointRadius {
    return MAX(_pointRadius, 6.0f);
}

- (CGFloat)lineWidth {
    return MAX(_lineWidth, 1.0f);
}

- (void)setPlotValues:(NSArray<NSNumber *> *)plotValues {
    _plotValues = plotValues;
    [self calculateMaxAndMin];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.pointColor = lineColor;
}

@end
