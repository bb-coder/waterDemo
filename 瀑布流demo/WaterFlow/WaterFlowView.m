//
//  WaterFlowView.m
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import "WaterFlowView.h"
#import "WaterFlowCellView.h"
@interface WaterFlowView()
@property (nonatomic, strong) NSMutableArray * indexPaths;
@property (nonatomic, assign) NSInteger colmnNumbers;
@property (nonatomic, assign) NSInteger rowNumbers;
//瀑布流视图缓存属性
@property (nonatomic, strong) NSMutableArray * cellFramesArray;
//缓冲池集合
@property (nonatomic, strong) NSMutableSet * reusableCellSet;
//屏幕单元格字典
@property (nonatomic, strong) NSMutableDictionary * screenCellsDict;
@end

@implementation WaterFlowView
#pragma mark 使用uiviewdeframe的setter方法
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reloadData];
}
#pragma mark 加载数据
- (void) reloadData
{
//    NSLog(@"%ld", (long)[self.dataSource waterFlowView:self numberOfRowsInColmns:0]);
    if (self.rowNumbers <= 0) {
        return;
    }
    
    [self resetView];
}
#pragma mark 获取列数
- (NSInteger) colmnNumbers
{
    NSInteger number = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfColmnsInWaterFlowView:)]) {
        number = [self.dataSource numberOfColmnsInWaterFlowView:self];
    }
    _colmnNumbers = number;
    return _colmnNumbers;
}

#pragma mark 获取行数
- (NSInteger) rowNumbers
{
    _rowNumbers = [self.dataSource waterFlowView:self numberOfRowsInColmns:0];
    return _rowNumbers;
}

#pragma mark 生成缓存数据
- (void) generateCaCheData
{
    NSInteger count = [self rowNumbers];
    if (self.indexPaths == nil) {
        self.indexPaths = [NSMutableArray arrayWithCapacity:count];
    }
    else
    {
        [self.indexPaths removeAllObjects];
    }
    
    for (int i = 0; i < count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.indexPaths addObject:indexPath];
    }
    if (self.cellFramesArray == nil) {
        self.cellFramesArray = [NSMutableArray arrayWithCapacity:count];
    }
    else
    {
        [self.cellFramesArray removeAllObjects];
    }
    if (self.reusableCellSet == nil) {
        self.reusableCellSet = [NSMutableSet set];
    }
    else
    {
        [self.reusableCellSet removeAllObjects];
    }
    if (self.screenCellsDict == nil) {
        self.screenCellsDict = [NSMutableDictionary dictionary];
    }
    else
    {
        [self.screenCellsDict removeAllObjects];
    }

}

#pragma mark 点击事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    
    NSArray * keyArray = self.screenCellsDict.allKeys;
    
    for (NSIndexPath * indexPath in keyArray) {
        WaterFlowCellView * cell = self.screenCellsDict[indexPath];
        if (CGRectContainsPoint(cell.frame, location)) {
            [self.delegate waterFlowView:self didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark -重新调整视图布局

#pragma mark 判断frame是否在屏幕之内
- (BOOL) isInSreenWithFrame:(CGRect) frame
{
    return (frame.origin.y + frame.size.height) > self.contentOffset.y &&
           frame.origin.y <(self.contentOffset.y + self.bounds.size.height);
}

#pragma mark 重新调整视图布局
- (void)layoutSubviews
{
    NSInteger index = 0;
    for (NSIndexPath *indexPath in self.indexPaths) {
        WaterFlowCellView * cell = [self.screenCellsDict objectForKey:indexPath];
        if (cell == nil) {
            cell = [self.dataSource waterFlowView:self cellForRowAtIndexPath:indexPath];
            CGRect frame = [self.cellFramesArray[index]CGRectValue];
            if ([self isInSreenWithFrame:frame]) {
                [cell setFrame:frame];
                [self addSubview:cell];
                [self.screenCellsDict setObject:cell forKey:indexPath];
            }
        }
        else
        {
            if (![self isInSreenWithFrame:cell.frame]) {
                [cell removeFromSuperview];
                [self.reusableCellSet addObject:cell];
                [self.screenCellsDict removeObjectForKey:indexPath];
            }
        }
        index ++;
    }
    
    if (self.contentOffset.y + self.bounds.size.height > self.contentSize.height) {
        [self.delegate waterFlowViewRefreshData:self];
    }
    
}
#pragma mark 查询可重用单元格
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    WaterFlowCellView * cell = [self.reusableCellSet anyObject];
    if (cell) {
        [self.reusableCellSet removeObject:cell];
    }
    return cell;
}
#pragma mark 重新布局试图
- (void) resetView
{
        NSInteger col = 0;
    CGFloat colW = self.bounds.size.width / self.colmnNumbers;
    CGFloat currentH[_colmnNumbers];
    for (int i = 0; i < _colmnNumbers; i++) {
        currentH[i] = 0.0;
    }
    [self generateCaCheData];
    for (NSIndexPath * indexPath in self.indexPaths) {
//        WaterFlowCellView * cell = [self.dataSource waterFlowView:self cellForRowAtIndexPath:indexPath];
        
        CGFloat h = [self.delegate waterFlowView:self heightForRowAtIndexPath:indexPath];
//        CGFloat h = colW * 280 / 220;
        CGFloat x = col * colW;
        CGFloat y = currentH[col];
        currentH[col] += h;
        
        NSInteger nextCol = (col+1) % _colmnNumbers;
        
        if (currentH[col] > currentH[nextCol]) {
            col = nextCol;
        }
        
        [self.cellFramesArray addObject:[NSValue valueWithCGRect:CGRectMake(x , y , colW , h )]];
//        [cell setFrame:CGRectMake(x , y , colW , h )];
        
//        [self addSubview:cell];
        
        CGFloat maxH = 0;
        for (NSInteger i = 0; i < _colmnNumbers; i++) {
            if (currentH[i] > maxH) {
                maxH = currentH[i];
            }
        }
        [self setContentSize:CGSizeMake(self.bounds.size.width, maxH)];

    }
    
}
@end
