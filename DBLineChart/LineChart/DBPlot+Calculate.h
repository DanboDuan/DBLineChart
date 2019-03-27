//
//  DBPlot+Calculate.h
//  DBLineChart
//
//  Created by bob on 2019/3/26.
//

#import "DBPlot.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBPlot (Calculate)

@property (nonatomic, assign, readonly) CGFloat maxPlotValue;
@property (nonatomic, assign, readonly) CGFloat minPlotValue;

- (void)calculateMaxAndMin;

@end

NS_ASSUME_NONNULL_END
