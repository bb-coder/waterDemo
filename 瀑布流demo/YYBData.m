//
//  YYBData.m
//  瀑布流demo
//
//  Created by 毕洪博 on 14-8-11.
//  Copyright (c) 2014年 bb_coder. All rights reserved.
//

#import "YYBData.h"

@implementation YYBData

-(NSString *)description
{
    NSString * str = [NSString stringWithFormat:@"%p %@ %@",self,self.name,self.img];
    return str;
}
@end
