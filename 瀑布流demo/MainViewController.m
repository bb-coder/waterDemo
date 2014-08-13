//
//  MainViewController.m
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import "MainViewController.h"
#import "WaterFlowCellView.h"
#import "YYBData.h"
#import "UIImageView+WebCache.h"
#define kBasePath @"http://www.yi18.net/"
#define kBookListPath @"http://api.yi18.net/book/list"
@interface MainViewController ()
@property (nonatomic,strong) NSMutableArray * dataList;
@property (nonatomic,assign) NSInteger currentColmns;
@property (nonatomic,assign) BOOL isLoadingData;
@property (nonatomic,assign) NSInteger index;
@end

@implementation MainViewController

- (void) loadData
{
    self.isLoadingData = YES;
    NSURL * url = [NSURL URLWithString:kBookListPath];
    NSData * data = [NSData dataWithContentsOfURL:url];
  //  NSURLRequest * request = [NSURLRequest requestWithURL:url];
  //  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = dict[@"yi18"];
    if (self.dataList == nil) {
        self.dataList = [NSMutableArray array];
    }
    for (NSDictionary * dict in array) {
        YYBData * data = [[YYBData alloc]init];
        NSString * str = kBasePath;
        [data setValue:[str stringByAppendingString:dict[@"img"]] forKey:@"img"];
        [data setValue:dict[@"name"] forKey:@"name"];
        [self.dataList addObject:data];
    }
   // }];
    self.isLoadingData = NO;
    [self.waterFlowView reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

-(NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColmns:(NSInteger)colmns
{
    return self.dataList.count;
}

-(NSInteger)numberOfColmnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
   if( [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight ||
      [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
   {
       _currentColmns = 4;
   }
    else
    {
        _currentColmns = 3;
    }
    return _currentColmns;
}
//监听单元格点击时间
-(void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"这个方法被调用了!%@", indexPath);
}

-(WaterFlowCellView *) waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reCell = @"cell";
    WaterFlowCellView * cell = [waterFlowView dequeueReusableCellWithIdentifier:reCell];
    
    if (cell == nil) {
        cell = [[WaterFlowCellView alloc]initWithReuseIdentifier:reCell];
    }
    YYBData * data = _dataList[indexPath.row];
    cell.textLabel.text = data.name;
    
    //异步加载图像
//    [cell.imageView setImageWithURL:data.img];
        [[SDWebImageManager sharedManager] downloadWithURL:data.img options:SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
//            NSLog(@"%lu %lld",(unsigned long)receivedSize,expectedSize);
        } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            cell.imageView.image = aImage;
            [_dataList[indexPath.row] setW:cell.imageView.image.size.width];
            [_dataList[indexPath.row] setH:cell.imageView.image.size.height];
//            NSLog(@"%@ %f %f",cell.textLabel.text,cell.imageView.image.size.width,
//                  cell.imageView.image.size.height);

        }];
    return cell;
}
#pragma mark 设备旋转
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.isLoadingData) {
        return;
    }
    [self.waterFlowView reloadData];
}

-(CGFloat) waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYBData * data = self.dataList[indexPath.row];
    
    CGFloat colWidth = self.view.bounds.size.width / 3.0;
    if (data.w <= 0) return 150.0;
    return colWidth * data.h / data.w;
}

#pragma mark 刷新网络数据
-(void)waterFlowViewRefreshData:(WaterFlowView *)waterFlowView
{
    
}
@end
