//
//  XMCalendarView.m
//  日历
//
//  Created by RenXiangDong on 17/3/27.
//  Copyright © 2017年 RenXiangDong. All rights reserved.
//


#import "XMCalendarView.h"
#import "XMCalendarCell.h"
#import "XMCalendarDataSource.h"
#import "XMCalendarManager.h"

@interface XMCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) XMCalendarManager *calendarManager;
@end
@implementation XMCalendarView

-(instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XMCalendarView" owner:self options:nil] lastObject];
        self.frame = frame;
        self.dataSourceModel = [self.calendarManager currentMonth];
        [self.collectionView registerNib:[UINib nibWithNibName:@"XMCalendarCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XMCalendarCell"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.collectionViewLayout = self.layout;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        NSIndexPath *todayIndexPath = [self.calendarManager currentDayIndexPath];
        [self.collectionView selectItemAtIndexPath:todayIndexPath animated:YES scrollPosition:(UICollectionViewScrollPositionTop)];
        [self.collectionView scrollToItemAtIndexPath:todayIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        self.collectionView.contentSize = CGSizeMake(self.dataSourceModel.dataSource.count * (self.bounds.size.width/7.0), 0);
        for (XMCalendarModel *model in self.dataSourceModel.dataSource) {
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            int year1 = (int)[dateComponent year];
            int month1 = (int)[dateComponent month];
            int day1 = (int)[dateComponent day];
            
            NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:model.date];
            int year2 = (int)[dateComponent1 year];
            if (day1 == model.dateNumber && month1 == model.month && year1 == year2) {
                [self.collectionView setContentOffset:CGPointMake((self.bounds.size.width/7.0) * (todayIndexPath.item - (model.weakNumber - 1)), 0) animated:NO];
                model.isCurrent = YES;
            } else {
                model.isCurrent = NO;
            }
        }
        
    }
    return self;
}

#pragma mark - CollectionView的代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceModel.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMCalendarModel *model = self.dataSourceModel.dataSource[indexPath.row];
    XMCalendarCell *cell = [XMCalendarCell cellWithCalendarModel:model collectionView:collectionView indexpath:indexPath];
    self.topTitleLabel.text = self.dataSourceModel.topTitle;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMCalendarModel *model = self.dataSourceModel.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(xmCalendarSelectDate:dateSource:)]) {
        [self.delegate xmCalendarSelectDate:model.date dateSource:self.dataSourceModel.dataSource];
    }
}

- (void)setRefreshData {
    [self.collectionView reloadData];
}

- (IBAction)preYear:(UIButton *)sender {
    self.dataSourceModel = [self.calendarManager preYear];
    [self.collectionView reloadData];
    self.topTitleLabel.text = self.dataSourceModel.topTitle;
    if (self.selectYearBlock) {
        self.selectYearBlock(self.dataSourceModel);
    }
}
- (IBAction)preMonth:(UIButton *)sender {
    self.dataSourceModel = [self.calendarManager preMonth];
    [self.collectionView reloadData];
    self.topTitleLabel.text = self.dataSourceModel.topTitle;
    if (self.selectYearBlock) {
        self.selectYearBlock(self.dataSourceModel);
    }
}
- (IBAction)nextMonth:(id)sender {
    self.dataSourceModel = [self.calendarManager nextMonth];
    [self.collectionView reloadData];
    self.topTitleLabel.text = self.dataSourceModel.topTitle;
    if (self.selectYearBlock) {
        self.selectYearBlock(self.dataSourceModel);
    }
}
- (IBAction)nextYear:(id)sender {
    self.dataSourceModel = [self.calendarManager nextYear];
    [self.collectionView reloadData];
    self.topTitleLabel.text = self.dataSourceModel.topTitle;
    if (self.selectYearBlock) {
        self.selectYearBlock(self.dataSourceModel);
    }
}

#pragma mark - getter & setter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(self.bounds.size.width/7.0, 60);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (XMCalendarManager *)calendarManager {
    if (!_calendarManager) {
        _calendarManager = [[XMCalendarManager alloc] init];
    }
    return _calendarManager;
}


@end
