//
//  LineChartViewController.m
//  Demo
//
//  Created by bob on 2019/3/21.
//  Copyright © 2019 bob. All rights reserved.
//

#import "LineChartViewController.h"
#import <DBLineChart/DBLineChartView.h>
#import <DBLineChart/DBPlot.h>


@interface LineChartViewController ()

@property (nonatomic, strong) DBLineChartView *lineChart;

@end

@implementation LineChartViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DBLineChartView *lineChart = [[DBLineChartView alloc] initWithFrame:CGRectMake(20, 300, 300, 300)];
    self.lineChart = lineChart;
    NSArray* plottingDataValues1 =@[@22, @33, @12, @23,@43, @32,@53, @33, @54,@55, @43];
    NSArray* plottingDataValues2 =@[@24, @23, @22, @20,@53, @22,@33, @36, @51,@58, @41];
    NSArray* plottingDataValues3 =@[@25, @26, @21, @15,@43, @32,@43, @26, @31,@28, @31];
    DBPlot *plot1 = [DBPlot new];
    plot1.plotValues = plottingDataValues1;
    plot1.plotTitle = @"测试一下长度";
    plot1.lineColor = [UIColor redColor];

    DBPlot *plot2 = [DBPlot new];
    plot2.plotTitle = @"test2";
    plot2.plotValues = plottingDataValues2;
    plot2.lineColor = [UIColor blueColor];
    plot2.showPointLabel = YES;

    DBPlot *plot3 = [DBPlot new];
    plot3.plotTitle = @"testttt";
    plot3.plotValues = plottingDataValues3;
    plot3.lineColor = [UIColor greenColor];
    plot3.showCirclePoint = NO;

    [lineChart addPlot:plot1];
    [lineChart addPlot:plot2];
    [lineChart addPlot:plot3];
    [lineChart setXAxisLabels:@[@"1d",@"2d",@"",@"4d",@"",@"",@"7d",@"",@"",@"",@"11D"]];
    [lineChart setXAxisLabels:@[@"0D",@"2d",@"4D",@"6d",@"8D",@"10D"]];
    lineChart.xGridLineCount = 5;
    lineChart.yAxisValuesCastToInt = YES;
    [lineChart drawLineChart];

    UIView *legend = [lineChart legendViewWithRowCount:2];
    if (legend) {
        legend.backgroundColor = [UIColor whiteColor];
        legend.frame = CGRectMake(20, 700, legend.bounds.size.width, legend.bounds.size.height);
        [self.view addSubview:legend];
    }
    [self.view addSubview:lineChart];
}

@end
