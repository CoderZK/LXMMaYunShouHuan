//
//  LxmWeiTuoJieshouVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoJieshouVC.h"


@interface LxmWeiTuoJieshouVC ()
{
    LxmWeiTuoJieshouVC_type _type;
}
@end

@implementation LxmWeiTuoJieshouVC

-(instancetype)initWithType:(LxmWeiTuoJieshouVC_type)type
{
    if (self=[super init])
    {
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == LxmWeiTuoJieshouVC_type_jieshou) {
        self.navigationItem.title = @"委托成功";
    }else{
        self.navigationItem.title = @"委托失败";
    }
    
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 220)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:headerView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-30, 20, 60, 60)];
    imgView.layer.cornerRadius = 30;
    imgView.layer.masksToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:self.model.otherUserHead]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
    [headerView addSubview:imgView];
    
    
    UILabel * infoLab  = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, ScreenW - 30, 40)];
    infoLab.numberOfLines = 2;
   
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:infoLab];
    
    if (_type == LxmWeiTuoJieshouVC_type_jieshou){
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-130)*0.5, 160, 130, 40)];
        [btn setTitle:@"返回委托首页" forState:UIControlStateNormal];
        infoLab.text = [NSString stringWithFormat:@"您已经将子机%@委托给%@",self.model.nickname,self.model.otherUserName];
        btn.tag = 10;
        [btn setBackgroundImage:[UIImage imageNamed:@"weituo_3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        
    }else{
        infoLab.text = [NSString stringWithFormat:@"您的子机%@委托给%@失败",self.model.nickname,self.model.otherUserName];
        
        UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-140, 160, 120, 36)];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_bujies"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitle:@"放弃" forState:UIControlStateNormal];
        leftBtn.tag = 11;
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:leftBtn];
        
        UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5+20, 160, 120, 36)];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"重新委托" forState:UIControlStateNormal];
        rightBtn.tag = 12;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:rightBtn];
        
    }
}

- (void)btnclick:(UIButton *)btn {
    if (btn.tag == 11||btn.tag == 10) {
        //放弃 委托成功
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated: YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
