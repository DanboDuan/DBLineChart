//
//  DBPlot.h
//  DBLineChart
//
//  Created by bob on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBPlot : NSObject

/**
 The plot title. should not be nil.
 */
@property (nonatomic, copy) NSString *plotTitle;

/**
 The plot point values. Default is `nil`.
 */
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *plotValues;

/**
Enable or disable point labels. Default is `NO`.
 */
@property (nonatomic, assign) BOOL showPointLabel;

/**
 The plot point label format. Default is `%.1f`.
 */
@property (nonatomic, copy) NSString *pointLabelFormat;

/**
 The plot label color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *pointLabelColor;

/**
 The plot label font. Default is `[UIFont systemFontOfSize:9.0]`.
 */
@property (nonatomic, strong) UIFont *pointLabelFont;

/**
 The plot point radius. Default and min is `6.0`.
 */
@property (nonatomic, assign) CGFloat pointRadius;

/**
 The plot point color. Default is `lineColor`. If you want to set pointColor different from lineColor, you should set pointColor after lineColor set
 @see 'lineColor'
 */
@property (nonatomic, strong) UIColor *pointColor;

/**
 The plot line color. Default is `[UIColor blackColor]`. The pointColor will be set when lineColor set
 @see pointColor
 */
@property (nonatomic, strong) UIColor* lineColor;

/**
 The plot line width. Default and min is `1.0`.
 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
