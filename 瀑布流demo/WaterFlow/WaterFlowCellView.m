//
//  WaterFlowCellView.m
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import "WaterFlowCellView.h"
#import "WaterFlowView.h"
#define kWaterFlowCellMagin 5
#define kWaterFlowLabelFont [UIFont systemFontOfSize:14]
@implementation WaterFlowCellView


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark 懒加载imageView
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark 懒加载label
-(UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        [_textLabel setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel setNumberOfLines:0];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [self insertSubview:_textLabel aboveSubview:self.imageView];
    }
    return _textLabel;
}

#pragma mark 视图重新布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectInset(self.bounds, kWaterFlowCellMagin, kWaterFlowCellMagin)];
    
    NSString * str = self.textLabel.text;
    CGFloat w = self.imageView.bounds.size.width;
    CGSize strSize = CGSizeZero;
    if ([[UIDevice currentDevice].systemVersion compare:@"6.1"] > 0) {
        NSDictionary *dict = @{NSFontAttributeName:kWaterFlowLabelFont};
        strSize = [str boundingRectWithSize:CGSizeMake(w, 20000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    }
    else
    {
        
        strSize = [str sizeWithFont:kWaterFlowLabelFont constrainedToSize:CGSizeMake(w, 20000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGFloat h = strSize.height;

    if (h > self.bounds.size.height / 2.0) {
        h = self.bounds.size.height / 2.0;
    }
    
    CGFloat x = kWaterFlowCellMagin;
    CGFloat y = self.bounds.size.height - (kWaterFlowCellMagin + h);
    
    self.textLabel.frame = CGRectMake(x, y, w, h);
    self.textLabel.text = str;
//    [self sizeToFit];
    
}








@end
