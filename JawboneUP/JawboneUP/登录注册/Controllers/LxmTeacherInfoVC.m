//
//  LxmTeacherInfoVCViewController.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTeacherInfoVC.h"
#import "LxmTeacherInfoView.h"
#import "LxmSearchDeviceVC.h"
#import "UIViewController+OpenImagePicker.h"

#import "LxmJiaZhangModel.h"



@interface LxmTeacherInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UIImageView * _headerImgView;
    LxmTeacherInfoView * _infoView;
    
    UIView *_headerView;
}
@end

@implementation LxmTeacherInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenW, 43.5)];
    firstView.backgroundColor = [UIColor whiteColor];
    UILabel * firstlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 20)];
    firstlab.text = @"老师信息";
    firstlab.textColor = CharacterDarkColor;
    [firstView addSubview:firstlab];
    
    _infoView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmTeacherInfoView class]) owner:nil options:nil].firstObject ;
    _headerImgView = _infoView.touxiangImgView;
    _headerImgView.tag = 101;
    _infoView.touxiangImgView.layer.cornerRadius = 20;
    _infoView.touxiangImgView.clipsToBounds = YES;
    [_infoView.touxiangBtn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    _infoView.touxiangBtn.tag = 100;
    _infoView.frame = CGRectMake(0, 59, ScreenW, 200);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 260 + 15 + 70)];
    [_headerView addSubview:firstView];
    [_headerView addSubview:_infoView];
    
    if (_isModify) {
        self.navigationItem.title = @"修改资料";
        UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        [rightbtn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        [self loadData];
        
    }else{
        self.navigationItem.title = @"老师填写信息";
        UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 275, ScreenW, 70)];
        bgView1.backgroundColor = [UIColor whiteColor];
    
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 13, ScreenW-20, 44)];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.clipsToBounds = YES;
        btn.tag = 101;
        [btn setTitle:@"填写，去绑定设备" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:btn];
        [_headerView addSubview:bgView1];
        self.tableView.tableHeaderView = _headerView;
    }
}

- (void)loadData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getUserInfoURL] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSDictionary * dic = [responseObject objectForKey:@"result"];
            LxmJiaZhangModel * model = [LxmJiaZhangModel mj_objectWithKeyValues:dic];
            [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:[[responseObject objectForKey:@"result"] objectForKey:@"headimg"]]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
            _infoView.nameTF.text = model.realname;
            _infoView.phoneTF.text = model.tel;
            _infoView.schoolNameTF.text = model.kindergarten;
            [LxmEventBus sendEvent:@"modifyUserInfoSuccess" data:nil];
        }
        else
        {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)btnClcik:(UIButton *)btn {
    
    if (btn.tag == 100) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerWithAction:OpenImagePickerAction_xiangce completed:^(UIImage *image, NSString *filePath) {
                
                _headerImgView.image = image;
                _headerImgView.tag = 102;
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerWithAction:OpenImagePickerAction_paizhao completed:^(UIImage *image, NSString *filePath) {
                _headerImgView.image = image;
                _headerImgView.tag = 102;
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        if (_isModify) {
            
            NSDictionary * dict = @{
                                    @"token":[LxmTool ShareTool].session_token,
                                    @"realname":_infoView.nameTF.text,
                                    };
            [SVProgressHUD show];
            
            [LxmNetworking NetWorkingUpLoad:[LxmURLDefine getEditUserInfoURL] image:_headerImgView.image image1:nil parameters:dict name:@"headimg" name1:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                    [self.preVC loadData];
                    [LxmEventBus sendEvent:@"modifyUserInfoSuccess" data:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        }
        else
        {
            if (_headerImgView.tag == 101) {
                [SVProgressHUD showErrorWithStatus:@"请上传您的头像"];
                return;
            }
            if (_infoView.nameTF.text.length==0) {
                [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名"];
                return;
            }
            NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,
                                   @"realname":_infoView.nameTF.text
                                   };
            LxmJiaZhangModel * moddel = [LxmJiaZhangModel mj_objectWithKeyValues:dic];
            LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] init];
            vc.isAddSubDevice = NO;
            vc.model = moddel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        }
}

@end
