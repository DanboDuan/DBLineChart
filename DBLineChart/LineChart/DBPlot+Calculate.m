//
//  DBPlot+Calculate.m
//  DBLineChart
//
//  Created by bob on 2019/3/26.
//

#import "DBPlot+Calculate.h"
#import <objc/runtime.h>

@implementation DBPlot (Calculate)

- (void)calculateMaxAndMin {
    if (self.plotValues.count) {
        NSNumber *max = self.plotValues.firstObject;
        NSNumber *min = self.plotValues.firstObject;
        for (NSNumber *value in self.plotValues) {
            if (max.doubleValue < value.doubleValue) {
                max = value;
            }
            if (min.doubleValue > value.doubleValue) {
                min = value;
            }
        }
        objc_setAssociatedObject(self, @selector(maxPlotValue), max, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, @selector(minPlotValue), min, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (CGFloat)maxPlotValue {
    return [objc_getAssociatedObject(self, @selector(maxPlotValue)) doubleValue];
}

- (CGFloat)minPlotValue {
    return [objc_getAssociatedObject(self, @selector(minPlotValue)) doubleValue];
}

@end
