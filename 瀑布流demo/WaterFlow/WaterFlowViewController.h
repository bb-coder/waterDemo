//
//  WaterFlowViewController.h
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowView.h"
@interface WaterFlowViewController : UIViewController<WaterFlowViewDelegate,WaterFlowViewDataSource>
@property (nonatomic,strong) WaterFlowView * waterFlowView;
@end
