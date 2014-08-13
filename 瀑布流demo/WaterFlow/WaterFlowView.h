//
//  WaterFlowView.h
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowCellView;
@class WaterFlowView;
#pragma mark waterFlowView数据源方法
@protocol WaterFlowViewDataSource <NSObject>

- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColmns:(NSInteger)colmns;
- (WaterFlowCellView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfColmnsInWaterFlowView:(WaterFlowView *)waterFlowView;
@end

#pragma mark waterFlowView代理方法
@protocol WaterFlowViewDelegate <NSObject,UIScrollViewDelegate>
@optional
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)waterFlowViewRefreshData:(WaterFlowView *) waterFlowView;
@end

@interface WaterFlowView : UIScrollView

@property (nonatomic,weak) id<WaterFlowViewDataSource> dataSource;

@property (nonatomic,weak) id<WaterFlowViewDelegate> delegate;


#pragma mark 刷新数据
- (void) reloadData;
#pragma mark 查询可重用单元格
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
