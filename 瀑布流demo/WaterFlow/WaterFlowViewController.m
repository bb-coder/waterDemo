//
//  WaterFlowViewController.m
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import "WaterFlowViewController.h"

@interface WaterFlowViewController ()

@end

@implementation WaterFlowViewController

-(void)loadView
{
    _waterFlowView = [[WaterFlowView alloc]initWithFrame:CGRectZero];
    [_waterFlowView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    _waterFlowView.dataSource = self;
    _waterFlowView.delegate = self;
    self.view = _waterFlowView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.waterFlowView reloadData];
}
#pragma mark 数据源方法
-(NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColmns:(NSInteger)colmns
{
    return 0;
}
-(WaterFlowCellView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
