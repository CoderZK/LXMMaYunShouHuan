//
//  LxmRoleSelectVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmRoleSelectVC.h"
#import "LxmSelectCardView.h"
#import "LxmParentInfoVC.h"
#import "LxmRoleModel.h"

@interface LxmRoleSelectVC ()<LxmSelectCardView>
{
    UIButton *_typeBtn;
    LxmSelectCardView * _view;
    UIImageView * _typeImgView;
    NSMutableArray * _roleArr;
    NSString * _identityId;

}
@end

@implementation LxmRoleSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"家长身份";
    _roleArr = [NSMutableArray array];

    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightbarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenW-30, 20)];
    lab.text = @"我是孩子的";
    [self.tableView addSubview:lab];
    
    UIButton * typeBtn = [[UIButton alloc] initWithFrame: CGRectMake(15, 50, ScreenW-30, 40)];
    _typeBtn = typeBtn;
    [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    typeBtn.layer.borderColor = LineColor.CGColor;
    typeBtn.layer.cornerRadius = 3;
    typeBtn.clipsToBounds = YES;
    typeBtn.layer.borderWidth = 0.5;
    [typeBtn setTitle:@"请选择类型" forState:UIControlStateNormal];
    [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [typeBtn setTitleColor:[CharacterLightGrayColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [typeBtn setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateNormal];
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.tableView addSubview:typeBtn];
    
    UIImageView * typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(typeBtn.frame.size.width-40, 0, 40, 40)];
    _typeImgView = typeImgView;
    typeImgView.image = [UIImage imageNamed:@"ico_9_xia"];
    [typeBtn addSubview:typeImgView];
    [self loadData];
    
}

- (void)loadData
{
    [SVProgressHUD show];
    
    [LxmNetworking networkingGET:[LxmURLDefine getRoleURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD dismiss];
            NSArray * arr = [responseObject objectForKey:@"result"];
            [_roleArr removeAllObjects];
            for (NSDictionary *dict in arr) {
                LxmRoleModel * model = [LxmRoleModel mj_objectWithKeyValues:dict];
                [_roleArr addObject:model];
                
            }
            if (_roleArr.count>0) {
                _view = [[LxmSelectCardView alloc] initWithFrame:self.view.bounds withDataArr:_roleArr];
                _view.delegate = self;
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"暂无角色信息"];
            }
            
            
        }else
        {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"]  message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)rightbarBtnClick
{
    if ([_typeBtn.titleLabel.text isEqualToString:@"请选择类型"]) {
        [SVProgressHUD showErrorWithStatus:@"请先选择类型"];
        return;
    }
    //家长填写身份信息
    LxmParentInfoVC * vc = [[LxmParentInfoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.identityId = _identityId;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)typeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        _typeImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [_view show];
    }
    else{
        _typeImgView.transform = CGAffineTransformIdentity;
        [_view dismiss];
        _typeBtn.selected = NO;
    }
    
}
-(void)LxmSelectCardView:(LxmSelectCardView *)view text:(NSString *)text index:(NSInteger)index
{
    [_view dismiss];
    _typeImgView.transform = CGAffineTransformIdentity;
    _typeBtn.selected = NO;
    LxmRoleModel * model = [_roleArr objectAtIndex:index];
    _identityId = model.ID;
    [_typeBtn setTitle:text forState:UIControlStateNormal];
    [_typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_typeBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    
}
-(void)LxmSelectCardViewWillDismiss:(LxmSelectCardView *)view
{
    _typeBtn.selected = NO;
    _typeImgView.transform = CGAffineTransformIdentity;
    [_view dismiss];
}

@end
