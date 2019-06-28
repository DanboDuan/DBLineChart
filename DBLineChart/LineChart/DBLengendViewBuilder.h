//
//  DBLengendViewBuilder.h
//  DBLineChart
//
//  Created by bob on 2019/6/28.
//

#import <UIKit/UIKit.h>
#import "DBLineChartView.h"

@class DBPlot;

NS_ASSUME_NONNULL_BEGIN

@interface DBLengendViewBuilder : NSObject

@property (nonatomic, strong) NSArray<DBPlot *> *plots;
@property (nonatomic, assign) DBLineChartLengendViewStyle style;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, strong) UIFont *legendFont;
@property (nonatomic, strong) UIColor *legendFontColor;

@property (nonatomic, assign) CGFloat plotHeight;// default 30
@property (nonatomic, assign) CGFloat textAndPointGap;// default 5
@property (nonatomic, assign) CGFloat plotGap;  // default 10

@property (nonatomic, assign) CGFloat circleUnitWidth;// default 50
@property (nonatomic, assign) CGFloat squareWidth;// default 10

- (UIView *)buildLengendView;

@end

NS_ASSUME_NONNULL_END
