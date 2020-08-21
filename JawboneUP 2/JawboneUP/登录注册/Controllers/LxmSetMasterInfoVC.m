//
//  LxmSetMasterInfoVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/24.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSetMasterInfoVC.h"
#import "UIViewController+OpenImagePicker.h"
#import "LxmTextTFView.h"
#import "LxmTextBtnImgView.h"
#import "LxmStyleSelectView.h"
#import "TabBarController.h"
#import "LxmBangDingSuccessVC.h"
#import "LxmBLEManager.h"
#import "UIImage+GIF.h"
#import "UIViewController+TopVC.h"
#import "LxmBLEManager.h"


@interface LxmSetMasterInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,LxmStyleSelectView>
{
    UIImageView * _headerImgView;
    LxmTextTFView * _jixingView;
    LxmTextTFView * _nickNameView;
    LxmTextBtnImgView * _styleView;
    LxmStyleSelectView * _selectView;
    UIImageView * _typeImgView;
    NSInteger _alertType;
    UIImageView * _gifImgView;
}
@end

@implementation LxmSetMasterInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加信息";
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    
    _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-50, 25, 100, 100)];
    _headerImgView.image = [UIImage imageNamed:@"pic_1"];
    _headerImgView.tag = 111;
    _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgView.layer.cornerRadius = 50;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touxiangBtnClick)];
    [_headerImgView addGestureRecognizer:tapGesturRecognizer];
    [headerView addSubview:_headerImgView];
    headerView.frame = CGRectMake(0, 0, ScreenW, 145+101+20);
    
    _jixingView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 145, ScreenW, 50)];
    _jixingView.backgroundColor = [UIColor whiteColor];
    _jixingView.leftLab.text = @"机型";
    _jixingView.rightTF.text = @"主机";
    _jixingView.rightTF.enabled = NO;
    [headerView addSubview:_jixingView];
    
    
    _nickNameView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 145+50.5, ScreenW, 50)];
    _nickNameView.backgroundColor = [UIColor whiteColor];
    _nickNameView.leftLab.text = @"昵称";
    _nickNameView.rightTF.placeholder = @"请输入您绑定的设备名称";
    [headerView addSubview:_nickNameView];
    
//    _styleView = [[LxmTextBtnImgView alloc] initWithFrame:CGRectMake(0, 145+101, ScreenW, 50)];
//    _styleView.backgroundColor = [UIColor whiteColor];
//    _styleView.leftLab.text = @"震动方式";
//    _styleView.rightLab.text = @"请选择报警方式";
//    _styleView.rightBtn.tag = 99;
//    [_styleView.rightBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:_styleView];
    
//    UIImageView * typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_styleView.rightBtn.frame.size.width-40, 0, 40, 40)];
//    _typeImgView = typeImgView;
//    typeImgView.image = [UIImage imageNamed:@"ico_9_xia"];
//    [_styleView.rightBtn addSubview:typeImgView];
    
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 145+121, ScreenW, 56)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton * addSubBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, ScreenW-30, 40)];
    addSubBtn.tag = 100;
    [addSubBtn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    [addSubBtn setTitle:@"完成" forState:UIControlStateNormal];
    [addSubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addSubBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addSubBtn.layer.cornerRadius = 10;
    addSubBtn.layer.masksToBounds = YES;
    [footerView addSubview:addSubBtn];
    
    _selectView = [[LxmStyleSelectView alloc] initWithFrame:self.view.bounds];
    _selectView.str = @"2";
    _selectView.delegate = self;
    
    
    _gifImgView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenW *0.5-50, ScreenH*0.5-50-64 , 100, 100)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gifTest" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    _gifImgView.image = image;
    _gifImgView.hidden = YES;
    [self.tableView addSubview:_gifImgView];
    
}
-(void)LxmStyleSelectViewWillDismiss:(LxmStyleSelectView *)view
{
    _typeImgView.transform = CGAffineTransformIdentity;
    _styleView.rightBtn.selected = NO;
    [view dismiss];
}

-(void)LxmStyleSelectView:(LxmStyleSelectView *)view text:(NSString *)text index:(NSInteger)index
{
    //报警方式选择的代理
    _typeImgView.transform = CGAffineTransformIdentity;
     _styleView.rightBtn.selected = NO;
    [_selectView dismiss];
    _alertType = index;
    _styleView.rightLab.text = text;
}

- (void)addBtnClick:(UIButton *)btn {
    //LxmBLEManager.shareManager.masterTongXinId = p.tongxinId;
    if (btn.tag == 99) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            _typeImgView.transform = CGAffineTransformMakeRotation(M_PI);
            _selectView.contentView.frame = CGRectMake(110, 145+151-self.tableView.bounds.origin.y, ScreenW-110-10, 44*7);
           [_selectView show];
        }
        else{
            _typeImgView.transform = CGAffineTransformIdentity;
            [_selectView dismiss];
            _styleView.rightBtn.selected = NO;
        }
    } else {
        
        if (_headerImgView.tag == 111) {
            [SVProgressHUD showErrorWithStatus:@"请先上传设备头像"];
            return;
        }
        if (_nickNameView.rightTF.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入设备名称"];
            return;
        }
        if (!self.isConnectWork) {
          [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
          return;
        }
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:LxmTool.ShareTool.session_token forKey:@"token"];
        [dict setValue:_nickNameView.rightTF.text forKey:@"realname"];
        [dict setValue:self.p.hVersion forKey:@"hVersion"];
        [dict setValue:self.p.fVersion forKey:@"fVersion"];
        [dict setValue:_nickNameView.rightTF.text forKey:@"nickname"];
        [dict setValue:@"0" forKey:@"identityId"];
        WeakObj(self);
        if (!self.isConnectWork) {
          [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
          return;
        }
        [[LxmBLEManager shareManager] connectPeripheral:self.p completed:^(BOOL success, CBPeripheral *per) {
            if (success) {
                    LxmBLEManager.shareManager.masterTongXinId = selfWeak.p.tongxinId;
                
                   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                   dic[@"communication"] = selfWeak.p.tongxinId;
                   dic[@"identifier"] = selfWeak.p.tongxinId;
                
                   _gifImgView.hidden = NO;
                   [LxmNetworking NetWorkingUpLoad:[LxmURLDefine getInfoURL] image:_headerImgView.image image1:_headerImgView.image parameters:dic name:@"headimg" name1:@"equHead" success:^(NSURLSessionDataTask *task, id responseObject) {
                       _gifImgView.hidden = YES;
    
                       if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                       [LxmTool ShareTool].hasPerfect = @"1";
                       LxmBangDingSuccessVC * vc = [[LxmBangDingSuccessVC alloc] init];
                       vc.parentId = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"parentId"]];
                       vc.deviceType = @"母机";
                       [selfWeak.navigationController pushViewController:vc animated:YES];
                       } else {
                            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                      }
                    
                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       _gifImgView.hidden = YES;
                   }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"当前主设备已经断连,请检查!"];
                return ;
            };
        }];
        
    }
}


-(void)touxiangBtnClick
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_xiangce completed:^(UIImage *image, NSString *filePath) {
            
            _headerImgView.image = image;
            _headerImgView.tag = 112;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_paizhao completed:^(UIImage *image, NSString *filePath) {
            _headerImgView.image = image;
            _headerImgView.tag = 112;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
