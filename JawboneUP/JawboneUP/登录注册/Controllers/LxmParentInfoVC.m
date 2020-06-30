//
//  LxmParentInfoVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmParentInfoVC.h"
#import "LxmSearchDeviceVC.h"
#import "PGDatePicker.h"
#import "UIViewController+OpenImagePicker.h"
#import "LxmJiaZhangModel.h"


@interface LxmParentInfoVC ()<PGDatePickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIImageView *_headerImgView;
    UITextField * _nameTF;
    UITextField * _phoneTF;
    UITextField * _addressTF;
    UILabel * _birthLab;
    UILabel * _sexLab;
    
    UIView *_headerView;
}
@end

@implementation LxmParentInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 385 + 64 )];
    self.tableView.tableHeaderView = _headerView;
    
    UIView * firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenW, 44)];
    firstView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:firstView];
    UILabel * firstlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 20)];
    firstlab.text = @"个人信息";
    firstlab.font = [UIFont systemFontOfSize:15];
    firstlab.textColor = CharacterDarkColor;
    [firstView addSubview:firstlab];
    
    UIView * touxiangView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44+0.5, ScreenW, 50)];
    touxiangView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:touxiangView];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    lab.text = @"头像";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = CharacterDarkColor;
    [touxiangView addSubview:lab];
    
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-20-15, 30)];
    headerBtn.tag = 101;
    [headerBtn addTarget:self action:@selector(infoBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    [touxiangView addSubview:headerBtn];
    
    UIImageView * headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 5, 40, 40)];
    _headerImgView = headerImgView;
    _headerImgView.tag = 123;
    _headerImgView.image = [UIImage imageNamed:@"pic_1"];
    headerImgView.layer.cornerRadius = 20;
    headerImgView.layer.masksToBounds = YES;
    [touxiangView addSubview:headerImgView];
    
    UIImageView * aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 20, 20, 20)];
    aImgView.image = [UIImage imageNamed:@"ico_9"];
    [touxiangView addSubview:aImgView];
    
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44+1+50, ScreenW, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:nameView];
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    lab1.text = @"姓名";
    lab1.font = [UIFont systemFontOfSize:16];
    [nameView addSubview:lab1];
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-15, 30)];
    _nameTF.placeholder = @"请输入您的姓名";
    _nameTF.textColor = CharacterDarkColor;
    _nameTF.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:_nameTF];
    
//    UIView * sexView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44+1+50+50.5, ScreenW, 50)];
//    sexView.backgroundColor = [UIColor whiteColor];
//    [self.tableView addSubview:sexView];
//    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
//    lab2.text = @"姓别";
//    lab2.font = [UIFont systemFontOfSize:16];
//    [sexView addSubview:lab2];
//    UIButton * sexBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-20-15, 30)];
//    sexBtn.tag = 102;
//    [sexBtn addTarget:self action:@selector(infoBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
//    [sexView addSubview:sexBtn];
//    UILabel * sexLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-20-15, 30)];
//    sexLab.text = @"请选择性别";
//    sexLab.textColor = CharacterDarkColor;
//    sexLab.font = [UIFont systemFontOfSize:15];
//    _sexLab = sexLab;
//    [sexView addSubview:sexLab];
//    UIImageView * aImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 20, 20, 20)];
//    aImgView1.image = [UIImage imageNamed:@"ico_9"];
//    [sexView addSubview:aImgView1];
//
//    UIView * birthView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44+1+50+51+50, ScreenW, 50)];
//    birthView.backgroundColor = [UIColor whiteColor];
//    [_headerView addSubview:birthView];
//    UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
//    lab3.text = @"出生年月";
//    lab3.font = [UIFont systemFontOfSize:16];
//    [birthView addSubview:lab3];
//    UIButton * birthBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-20-15, 30)];
//    birthBtn.tag = 103;
//    [birthBtn addTarget:self action:@selector(infoBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
//    [birthView addSubview:birthBtn];
//
//    UILabel * birthLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-20-15, 30)];
//    _birthLab = birthLab;
//    birthLab.text = @"请选择出生日期";
//    birthLab.textColor = CharacterDarkColor;
//    birthLab.font = [UIFont systemFontOfSize:15];
//    [birthView addSubview:birthLab];
//    UIImageView * aImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 20, 20, 20)];
//    aImgView2.image = [UIImage imageNamed:@"ico_9"];
//    [birthView addSubview:aImgView2];
//
//    UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+44+1+50+51+50+50.5, ScreenW, 50)];
//    phoneView.backgroundColor = [UIColor whiteColor];
//    [_headerView addSubview:phoneView];
//    UILabel * lab4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
//    lab4.text = @"手机号码";
//    lab4.font = [UIFont systemFontOfSize:16];
//    [phoneView addSubview:lab4];
//    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-15, 30)];
//    _phoneTF.placeholder = @"请输入正确的手机号码";
//    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
//    _phoneTF.textColor = CharacterDarkColor;
//    _phoneTF.font = [UIFont systemFontOfSize:15];
//    [phoneView addSubview:_phoneTF];
//
//    UIView * adressView = [[UIView alloc] initWithFrame:CGRectMake(0, 110+201, ScreenW, 50)];
//    adressView.backgroundColor = [UIColor whiteColor];
//    [_headerView addSubview:adressView];
//    UILabel * lab5 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
//    lab5.text = @"地址";
//    lab5.font = [UIFont systemFontOfSize:16];
//    [adressView addSubview:lab5];
//    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 10, ScreenW-115-15, 30)];
//    _addressTF.placeholder = @"请输入正确的地址";
//    _addressTF.delegate = self;
//    _addressTF.font = [UIFont systemFontOfSize:15];
//    _addressTF.textColor = CharacterDarkColor;
//    [adressView addSubview:_addressTF];
    
    
    if (_isModify) {
        self.navigationItem.title = @"修改资料";
        
        UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        [rightbtn addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
        rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        [self loadData];
        
    }else{
        self.navigationItem.title = @"家长填写信息";
        UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, ScreenW, 64)];
        bgView1.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:bgView1] ;
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
        [btn setTitle:@"去绑定设备" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:btn];
    }
}

- (void)loadData
{
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getUserInfoURL] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSDictionary * dic = [responseObject objectForKey:@"result"];
            LxmJiaZhangModel * model = [LxmJiaZhangModel mj_objectWithKeyValues:dic];
            [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:[[responseObject objectForKey:@"result"] objectForKey:@"headimg"]]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
            _nameTF.text = model.realname;
            if ([model.sex intValue] == 1) {
                _sexLab.text = @"男";
            }else{
                _sexLab.text = @"女";
            }
            _birthLab.text = model.birthday;
            _phoneTF.text = model.tel;
            _addressTF.text = model.address;
  
        }
        else
        {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)infoBtnClcik:(UIButton *)btn
{
    if (btn.tag == 101) {
        //头像
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerWithAction:OpenImagePickerAction_xiangce completed:^(UIImage *image, NSString *filePath) {
                
                _headerImgView.image = image;
                _headerImgView.tag = 321;
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerWithAction:OpenImagePickerAction_paizhao completed:^(UIImage *image, NSString *filePath) {
                _headerImgView.image = image;
                _headerImgView.tag = 321;
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (btn.tag == 102){
        //性别
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLab.text = @"男";
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLab.text = @"女";
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
   }else {
        [self.view endEditing:YES];
     //出生年月
        PGDatePicker * picker = [[PGDatePicker alloc] init];
        picker.delegate = self;
        picker.datePickerMode = PGDatePickerModeDate;
        [picker show];
    }
}
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    _birthLab.text = [NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day];
}

- (void)btnClcik {
    
    if (_isModify) {
        
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[LxmTool ShareTool].session_token forKey:@"token"];
        [dictionary setObject:_nameTF.text forKey:@"realname"];
//        [dictionary setObject:_birthLab.text forKey:@"birthday"];
//        [dictionary setObject:_addressTF.text forKey:@"address"];
//
//        if ([_sexLab.text isEqualToString:@"男"]) {
//            [dictionary setObject:@1 forKey:@"sex"];
//        }else{
//            [dictionary setObject:@2 forKey:@"sex"];
//        }
     
        [SVProgressHUD show];
        
        [LxmNetworking NetWorkingUpLoad:[LxmURLDefine getEditUserInfoURL] image:_headerImgView.image image1:nil parameters:dictionary name:@"headimg" name1:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    }else{
        
        if (_headerImgView.tag == 123) {
            [SVProgressHUD showErrorWithStatus:@"请先上传用户头像"];
            return;
        }
        if (_nameTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的姓名"];
            return;
        }
//        if([_sexLab.text isEqualToString:@"请选择性别"])
//        {
//            [SVProgressHUD showErrorWithStatus:@"请选择性别"];
//            return;
//        }
//        if([_birthLab.text isEqualToString:@"请选择出生日期"])
//        {
//            [SVProgressHUD showErrorWithStatus:@"请选择出生日期"];
//            return;
//        }
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date1 = [dateFormatter dateFromString:_birthLab.text];
//        NSDate * currentDate = [NSString getCurrentTime];
//        if ([currentDate compare:date1] == -1) {
//            [SVProgressHUD showErrorWithStatus:@"选择的日期必须小于当前日期"];
//            return;
//        }
//        if(_phoneTF.text.length == 0)
//        {
//            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
//            return;
//        }
//        if (_addressTF.text.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请输入正确的地址"];
//            return;
//        }
        
 
    
        NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,
                               @"realname":_nameTF.text,
                               @"identityId":self.identityId
                               };
        
        LxmJiaZhangModel * moddel = [LxmJiaZhangModel mj_objectWithKeyValues:dic];
        LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] init];
        vc.isAddSubDevice = NO;
        vc.model = moddel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
