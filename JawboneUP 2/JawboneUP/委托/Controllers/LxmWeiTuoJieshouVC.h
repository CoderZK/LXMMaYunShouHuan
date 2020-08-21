//
//  LxmWeiTuoJieshouVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"

typedef enum{
    LxmWeiTuoJieshouVC_type_jieshou,
    LxmWeiTuoJieshouVC_type_bujieshou
    
} LxmWeiTuoJieshouVC_type;


@interface LxmWeiTuoJieshouVC : BaseTableViewController
@property (nonatomic,strong) lxmMessageInforModel * model;
-(instancetype)initWithType:(LxmWeiTuoJieshouVC_type)type;
@property(nonatomic,assign)LxmWeiTuoJieshouVC_type type;
@end
