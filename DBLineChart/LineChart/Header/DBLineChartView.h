//
//  DBLineChart.h
//  DBLineChart
//
//  Created by bob on 2019/3/21.
//

#import <UIKit/UIKit.h>

@class DBPlot;

typedef NS_ENUM(NSInteger, DBLineChartLengendViewStyle) {
    DBLengendViewStyleCirclePointWithLine,
    DBLengendViewStyleSquareWithoutLine,
};

NS_ASSUME_NONNULL_BEGIN

@interface DBLineChartView : UIView

#pragma mark - Line Chart

/**
 The line chart Axis top margin. Default and min is '20.0f'.
 */
@property (nonatomic, assign) CGFloat axisMarginTop;

/**
 The line chart Axis right margin. Default and min is '20.0f'.
 */
@property (nonatomic, assign) CGFloat axisMarginRight;

/**
 The line chart x Axis bottom height. Default and min is the height to hold x Axis labels.
 */
@property (nonatomic, assign) CGFloat  axisMarginBottom;

/**
 The line chart y Axis left width. Default and min is the width to hold y Axis labels.
 */
@property (nonatomic, assign) CGFloat  axisMarginLeft;

/**
 The line chart axis color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor*  axisColor;

/**
 The line chart Axis line width. Default and min is '1.0'.
 */
@property (nonatomic, assign) CGFloat  axisLineWidth;

#pragma mark - legend View

/**
 The legend font color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *legendFontColor;

/**
 The legend font. Default is `[UIFont systemFontOfSize:12.0]`.
 */
@property (nonatomic, strong) UIFont *legendFont;

/**
 The legend view style. Default is `DBLengendViewStyleCirclePointWithLine`
 */
@property (nonatomic, assign) DBLineChartLengendViewStyle legendStyle;

#pragma mark - xAxis

/**
 The line chart x Axis labels. Default is 0, 1, 2, 3... .
 Empty string to skip the index like @[@"0", @"1", @"", @"3"] to skip @"2"
 */
@property (nonatomic, copy) NSArray<NSString *> *xAxisLabels;

/**
 The line chart x Axis label font. Default is `[UIFont systemFontOfSize:12.0]`.
 */
@property (nonatomic, strong) UIFont * xAxisLabelFont;

/**
 The line chart x Axis label color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor*  xAxisLabelColor;

#pragma mark - yAxis

/**
 The line chart y Axis value max. Default is max of all point values.
 */
@property (nonatomic, assign) CGFloat  yMax;

/**
 The line chart y Axis value min. Default is min of all point values.
 */
@property (nonatomic, assign) CGFloat  yMin;

/**
 The line chart y Axis values that will show y Axis label. Should be between yMin and yMax. Default is the values of  y grid line
 */
@property (nonatomic, copy) NSArray<NSNumber *>* yAxisValues;

/**
 The line chart y Axis label format. Default is `%.1f`.
 */
@property (nonatomic, copy) NSString*  yAxisLabelFormat;

/**
 The line chart y Axis label font. Default is `[UIFont systemFontOfSize:12.0]`.
 */
@property (nonatomic, strong) UIFont * yAxisLabelFont;

/**
 The line chart y Axis label color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor*  yAxisLabelColor;

/**
 The line chart y Axis value default is what you set, but you can cast it to int. Default is `NO`
 */
@property (nonatomic, assign) BOOL  yAxisValuesCastToInt;

#pragma mark - Grid Line

/**
 Enable or disable y grid line. Default is `YES`.
 */
@property (nonatomic, assign) BOOL showYGridLine;

/**
 Enable or disable x grid line. Default is `YES`.
 */
@property (nonatomic, assign) BOOL showXGridLine;

/**
 The line chart y grid line count. Default is `5` and min is '1'.
 */
@property (nonatomic, assign) NSInteger yGridLineCount;

/**
 The line chart x grid line count. Default is the `xAxisLabels.count - 1` and min is '1'.
 */
@property (nonatomic, assign) NSInteger xGridLineCount;

/**
 The line chart y grid line color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *yGridLineColor;

/**
 The line chart x grid line color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *xGridLineColor;

/**
 The line chart y grid line width. Default and min is '1.0'.
 */
@property (nonatomic, assign) CGFloat  yGridLineWidth;

/**
 The line chart x grid line width. Default and min is '1.0'.
 */
@property (nonatomic, assign) CGFloat  xGridLineWidth;

/**
 The line chart plots. Default is '@[]'. If set with some value, it will remove all the plots already added to the line chart

 @see `addPlot` to add plot one by one and it won't remove plots that already added.
 */
@property (nonatomic, copy) NSArray<DBPlot *> *plots;

/**
 Creates a new instance of `DBLineChartView` with all the default values set.
 */
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/**
 @warning Only the designated initializer should be used to create
 an instance of `DBLineChartView`.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 @warning Only the designated initializer should be used to create an instance of `DBLineChartView`.
 */
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 @warning Only the designated initializer should be used to create an instance of `DBLineChartView`.
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 this method will add a Plot to the graph.

 @param plot the Plot that you want to draw on the Graph.

  @see 'plots' to replace all the plots added.
 */
- (void)addPlot:(DBPlot *)plot;

/**
 this method will draw the graph.
 */
- (void)drawLineChart;

/**
 Return the legend view with row count of plots.

 @param row The legend view with row count.

 @return UIView The legend view.
 */
- (UIView *)legendViewWithRowCount:(NSUInteger)row;

@end

NS_ASSUME_NONNULL_END
