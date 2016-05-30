//
//  AllSearchDisplayVC.m
//  Coding_iOS
//
//  Created by jwill on 15/11/19.
//  Copyright © 2015年 Coding. All rights reserved.
//

#import "AllSearchDisplayVC.h"
#import "Coding_NetAPIManager.h"
#import "SVPullToRefresh.h"
#import "CSSearchModel.h"
#import "PublicSearchModel.h"
#import "NSString+Attribute.h"

// cell--------------
#import "ProjectAboutMeListCell.h"

@interface AllSearchDisplayVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *dateSource;
@property (nonatomic, assign) BOOL      isLoading;
@property (nonatomic, strong) UILabel   *headerLabel;
@property (nonatomic, strong) PublicSearchModel *searchPros;
@property (nonatomic, strong) UIScrollView  *searchHistoryView;
@property (nonatomic, assign) double historyHeight;
- (void)initSearchResultsTableView;
- (void)initSearchHistoryView;
- (void)didCLickedCleanSearchHistory:(id)sender;
- (void)didClickedContentView:(UIGestureRecognizer *)sender;
- (void)didClickedHistory:(UIGestureRecognizer *)sender;

@end

@implementation AllSearchDisplayVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchHistoryView.delegate = nil;
}


- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    
    if(!visible) {
        
        [_searchTableView removeFromSuperview];
        [_contentView removeFromSuperview];
        
        _searchTableView = nil;
        _contentView = nil;
        _searchHistoryView = nil;
        
        [super setActive:visible animated:animated];
    }else {
        
        [super setActive:visible animated:animated];
        
        if(!_contentView) {
            
            _contentView = ({
                
                UIView *view = [[UIView alloc] init];
                view.frame = CGRectMake(0.0f, 0, kScreen_Width, kScreen_Height - 60.0f);
                view.backgroundColor = [UIColor clearColor];
                view.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedContentView:)];
                [view addGestureRecognizer:tapGestureRecognizer];
                
                view;
            });
            
            [self initSearchHistoryView];
        }
        
        
        [self.parentVC.view addSubview:_contentView];
        [self.parentVC.view bringSubviewToFront:_contentView];
        self.searchBar.delegate = self;
    }
}

#pragma mark - UI

- (void)initSearchResultsTableView {
    
    _dateSource = [[NSMutableArray alloc] init];
    
    if(!_searchTableView) {
        _searchTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:_contentView.frame style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[ProjectAboutMeListCell class] forCellReuseIdentifier:@"ProjectAboutMeListCell"];

            tableView.dataSource = self;
            tableView.delegate = self;
            
            [self.parentVC.view addSubview:tableView];
            
            self.headerLabel = ({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, kScreen_Width, 44)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor colorWithHexString:@"0x999999"];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label;
            });
            
            UIView *headview = ({
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
                v.backgroundColor = [UIColor whiteColor];
                [v addSubview:self.headerLabel];
                v;
            });
            tableView.tableHeaderView = headview;
            
            tableView;
        });
    }
    [_searchTableView.superview bringSubviewToFront:_searchTableView];

    [_searchTableView reloadData];
    [self refresh];
}

- (void)initSearchHistoryView {
    
    if(!_searchHistoryView) {
        
        _searchHistoryView = [[UIScrollView alloc] init];
        _searchHistoryView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_searchHistoryView];
        self.searchBar.delegate=self;
        [self registerForKeyboardNotifications];
    }
    
    [[_searchHistoryView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
        [_searchHistoryView addSubview:view];
    }
    NSArray *array = [CSSearchModel getSearchHistory];
    CGFloat imageLeft = 12.0f;
    CGFloat textLeft = 34.0f;
    CGFloat height = 44.0f;
    
    _historyHeight=height*(array.count+1);
    //set history list
    [_searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(_historyHeight);
    }];
    _searchHistoryView.contentSize = CGSizeMake(kScreen_Width, _historyHeight);

    
    for (int i = 0; i < array.count; i++) {
        
        UILabel *lblHistory = [[UILabel alloc] initWithFrame:CGRectMake(textLeft, i * height, kScreen_Width - textLeft, height)];
        lblHistory.userInteractionEnabled = YES;
        lblHistory.font = [UIFont systemFontOfSize:14];
        lblHistory.textColor = [UIColor colorWithHexString:@"0x222222"];
        lblHistory.text = array[i];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftView.left = 12;
        leftView.centerY = lblHistory.centerY;
        leftView.image = [UIImage imageNamed:@"icon_search_clock"];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        rightImageView.right = kScreen_Width - 12;
        rightImageView.centerY = lblHistory.centerY;
        rightImageView.image = [UIImage imageNamed:@"icon_arrow_searchHistory"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (i + 1) * height, kScreen_Width - imageLeft, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedHistory:)];
        [lblHistory addGestureRecognizer:tapGestureRecognizer];
        
        [_searchHistoryView addSubview:lblHistory];
        [_searchHistoryView addSubview:leftView];
        [_searchHistoryView addSubview:rightImageView];
        [_searchHistoryView addSubview:view];
    }
    
    if(array.count) {
        
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClean.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnClean setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [btnClean setTitleColor:[UIColor colorWithHexString:@"0x1bbf75"] forState:UIControlStateNormal];
        [btnClean setFrame:CGRectMake(0, array.count * height, kScreen_Width, height)];
        [_searchHistoryView addSubview:btnClean];
        [btnClean addTarget:self action:@selector(didCLickedCleanSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (array.count + 1) * height, kScreen_Width - imageLeft, 0.5)];
            view.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
            [_searchHistoryView addSubview:view];
        }
    }
    
}

#pragma mark - event

/**
 *  点击清楚历史的btn
 */
- (void)didCLickedCleanSearchHistory:(id)sender {
    
    [CSSearchModel cleanAllSearchHistory];
    [self initSearchHistoryView];
}

/**
 *  点击空白部分
 */
- (void)didClickedContentView:(UIGestureRecognizer *)sender {
    
    [self.searchBar resignFirstResponder];
}

/**
 *  点击历史记录的btn
 */
- (void)didClickedHistory:(UIGestureRecognizer *)sender {
    
    UILabel *label = (UILabel *)sender.view;
    self.searchBar.text = label.text;
    [CSSearchModel addSearchHistory:self.searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
}


#pragma mark -- goVC
- (void)goToProject:(Project *)project{
    UIViewController *vc = [BaseViewController analyseVCFromLinkStr:project.project_path];
    [self.parentVC.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark -
#pragma mark Search Data Request

- (void)refresh {
    if(_isLoading){
        [_searchTableView.infiniteScrollingView stopAnimating];
        return;
    }
    [self requestAll];
}

//是否显示加载更多
-(BOOL)showTotalPage{
    switch (_curSearchType) {
        case eSearchType_Project:
            return  _searchPros.projects.page<_searchPros.projects.totalPage;
            break;
        case eSearchType_Tweet:
            return  _searchPros.tweets.page<_searchPros.tweets.totalPage;
            break;
        case eSearchType_Document:
            return  _searchPros.files.page<_searchPros.files.totalPage;
            break;
        case eSearchType_User:
            return  _searchPros.friends.page<_searchPros.friends.totalPage;
            break;
        case eSearchType_Task:
            return  _searchPros.tasks.page<_searchPros.tasks.totalPage;
            break;
        case eSearchType_Topic:
            return  _searchPros.project_topics.page<_searchPros.project_topics.totalPage;
            break;
        case eSearchType_Merge:
            return  _searchPros.merge_requests.page<_searchPros.merge_requests.totalPage;
            break;
        case eSearchType_Pull:
            return  _searchPros.pull_requests.page<_searchPros.pull_requests.totalPage;
            break;
        default:
            return NO;
            break;
    }
}

//判断是否空
-(BOOL)noEmptyList{
    switch (_curSearchType) {
        case eSearchType_Project:
            return  [_searchPros.projects.list count];
            break;
        case eSearchType_Tweet:
            return  [_searchPros.tweets.list count];
            break;
        case eSearchType_Document:
            return  [_searchPros.files.list count];
            break;
        case eSearchType_User:
            return  [_searchPros.friends.list count];
            break;
        case eSearchType_Task:
            return  [_searchPros.tasks.list count];
            break;
        case eSearchType_Topic:
            return  [_searchPros.project_topics.list count];
            break;
        case eSearchType_Merge:
            return  [_searchPros.merge_requests.list count];
            break;
        case eSearchType_Pull:
            return  [_searchPros.pull_requests.list count];
            break;
        default:
            return TRUE;
            break;
    }
}


//更新header数量和类型统计
- (void)refreshHeaderTitle{
    NSString *titleStr;
    
    if ([_searchPros.projects.totalRow longValue]==0) {
        titleStr=nil;
    }else{
        titleStr=[NSString stringWithFormat:@"共搜索到 %ld 个与\"%@\"相关的项目", [_searchPros.projects.totalRow longValue],self.searchBar.text];
    }
    self.headerLabel.text=titleStr;
}

-(void)requestAll{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] requestWithSearchString:self.searchBar.text typeStr:@"all" andPage:1 andBlock:^(id data, NSError *error) {
        if(data) {
            [weakSelf.dateSource removeAllObjects];
            weakSelf.searchPros = [NSObject objectOfClass:@"PublicSearchModel" fromJSON:data];
            NSDictionary *dataDic = (NSDictionary *)data;
            
            //topic 处理 content 关键字
            NSArray *resultTopic =[dataDic[@"project_topics"] objectForKey:@"list"] ;
            for (int i=0;i<[_searchPros.project_topics.list count];i++) {
                ProjectTopic *curTopic=[_searchPros.project_topics.list objectAtIndex:i];
                if ([resultTopic count]>i) {
                    curTopic.contentStr= [[[resultTopic objectAtIndex:i] objectForKey:@"content"] firstObject];
                }
            }
            
            //task 处理 description 关键字
            NSArray *resultTask =[dataDic[@"tasks"] objectForKey:@"list"] ;
            for (int i=0;i<[weakSelf.searchPros.tasks.list count];i++) {
                Task *curTask=[weakSelf.searchPros.tasks.list objectAtIndex:i];
                if ([resultTask count]>i) {
                    curTask.descript= [[[resultTask objectAtIndex:i] objectForKey:@"description"] firstObject];
                }
            }
            
            switch (weakSelf.curSearchType) {
                case eSearchType_Project:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.projects.list];
                    break;
                case eSearchType_Tweet:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.tweets.list];
                    break;
                case eSearchType_Document:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.files.list];
                    break;
                case eSearchType_User:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.friends.list];
                    break;
                case eSearchType_Task:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.tasks.list];
                    break;
                case eSearchType_Topic:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.project_topics.list];
                    break;
                case eSearchType_Merge:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.merge_requests.list];
                    break;
                case eSearchType_Pull:
                    [weakSelf.dateSource addObjectsFromArray:weakSelf.searchPros.pull_requests.list];
                    break;
                default:
                    break;
            }
            
            [weakSelf.searchTableView configBlankPage:EaseBlankPageTypeProject_SEARCH hasData:[weakSelf noEmptyList] hasError:(error != nil) reloadButtonBlock:^(id sender) {
            }];
    
            [weakSelf.searchTableView reloadData];
            [weakSelf.searchTableView.infiniteScrollingView stopAnimating];
            weakSelf.searchTableView.showsInfiniteScrolling = [weakSelf showTotalPage];
        }
        weakSelf.isLoading = NO;
        [self refreshHeaderTitle];
    }];
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)keyboardWasShown{
    if (_historyHeight+236>(kScreen_Height-64)) {
        [_searchHistoryView setHeight:kScreen_Height-236-64];
    }
}

-(void)keyboardWillBeHidden{
    if (_historyHeight+236>(kScreen_Height-64)) {
        [_searchHistoryView setHeight:_historyHeight];
    }
}

#pragma mark - UISearchBarDelegate Support

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [CSSearchModel addSearchHistory:searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    
    [self initSearchResultsTableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource Support

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dateSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectAboutMeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectAboutMeListCell" forIndexPath:indexPath];
    cell.openKeywords=TRUE;
    Project *project=_dateSource[indexPath.row];
    [cell setProject:project hasSWButtons:NO hasBadgeTip:YES hasIndicator:NO];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return kProjectAboutMeListCellHeight;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [self setActive:TRUE];
    
    return TRUE;
}






@end
