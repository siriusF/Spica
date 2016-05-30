//
//  Spica_RootViewController.m
//  宅舞
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 beizi. All rights reserved.
//

#import "Spica_RootViewController.h"

@interface Spica_RootViewController ()
@property (nonatomic, strong) NSMutableDictionary *tweetsDict;

@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation Spica_RootViewController

+ (instancetype)newTweetVCWithType:(Spica_RootViewControllerType)type{
    Spica_RootViewController *vc = [Spica_RootViewController new];
    vc.curIndex = type;
    return vc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _curIndex = 0;
        _tweetsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//#pragma mark TabBar
//- (void)tabBarItemClicked{
//    [super tabBarItemClicked];
//
//}
//
//#pragma mark lifeCycle
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    //    _curIndex = 0;
//    
//    //    [self customDownMenuWithTitles:@[[DownMenuTitle title:@"冒泡广场" image:@"nav_tweet_all" badge:nil],
//    //                                     [DownMenuTitle title:@"好友圈" image:@"nav_tweet_friend" badge:nil],
//    //                                     [DownMenuTitle title:@"热门冒泡" image:@"nav_tweet_hot" badge:nil],
//    //                                     [DownMenuTitle title:@"我的冒泡" image:@"nav_tweet_mine" badge:nil]]
//    //                   andDefaultIndex:_curIndex
//    //                          andBlock:^(id titleObj, NSInteger index) {
//    //                              [(DownMenuTitle *)titleObj setBadgeValue:nil];
//    //                              _curIndex = index;
//    //                              [self refreshFirst];
//    //                          }];
//    
//    UIBarButtonItem *leftBarItem =[UIBarButtonItem itemWithIcon:@"hot_topic_Nav" showBadge:NO target:self action:@selector(hotTopicBtnClicked:)];
//    
//    [self.parentViewController.navigationItem setLeftBarButtonItem:leftBarItem animated:NO];
//    
//    _tweetsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
//    
//    //    添加myTableView
////    _myTableView = ({
////        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
////        tableView.backgroundColor = [UIColor clearColor];
////        tableView.dataSource = self;
////        tableView.delegate = self;
////        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////        Class tweetCellClass = [TweetCell class];
////        [tableView registerClass:tweetCellClass forCellReuseIdentifier:kCellIdentifier_Tweet];
////        [self.view addSubview:tableView];
////        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.edges.equalTo(self.view);
////        }];
////        {
////            __weak typeof(self) weakSelf = self;
////            [tableView addInfiniteScrollingWithActionHandler:^{
////                [weakSelf refreshMore];
////            }];
////        }
////        {
////            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.rdv_tabBarController.tabBar.frame), 0);
////            tableView.contentInset = insets;
////        }
////        tableView;
////    });
////    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
////    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
////    
////    //评论
////    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
////    _myMsgInputView.delegate = self;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
////    if (_myMsgInputView) {
////        [_myMsgInputView prepareToDismiss];
////    }
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
////    UIButton *leftItemView = (UIButton *)self.parentViewController.navigationItem.leftBarButtonItem.customView;
////    if ([[FunctionTipsManager shareManager] needToTip:kFunctionTipStr_Search]) {
////        [leftItemView addBadgePoint:4 withPointPosition:CGPointMake(25, 0)];
////    }
//    
//    [self refreshFirst];
//    
////    //    键盘
////    if (_myMsgInputView) {
////        [_myMsgInputView prepareToShow];
////    }
//    [self.parentViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tweetBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)] animated:NO];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//#pragma mark TableM
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *identifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 30;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//
////- (void)analyseLinkStr:(NSString *)linkStr{
////    if (linkStr.length <= 0) {
////        return;
////    }
////    UIViewController *vc = [BaseViewController analyseVCFromLinkStr:linkStr];
////    if (vc) {
////        [self.navigationController pushViewController:vc animated:YES];
////    }else{
////        //网页
////        WebViewController *webVc = [WebViewController webVCWithUrlStr:linkStr];
////        [self.navigationController pushViewController:webVc animated:YES];
////    }
////}
//
//
//#pragma mark ScrollView Delegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (scrollView == _myTableView) {
//        [self.myMsgInputView isAndResignFirstResponder];
//        _oldPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    _oldPanOffsetY = 0;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentSize.height <= CGRectGetHeight(scrollView.bounds)-50) {
//        [self hideToolBar:NO];
//        return;
//    }else if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged){
//        CGFloat nowPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
//        CGFloat diffPanOffsetY = nowPanOffsetY - _oldPanOffsetY;
//        CGFloat contentOffsetY = scrollView.contentOffset.y;
//        if (ABS(diffPanOffsetY) > 50.f) {
//            [self hideToolBar:(diffPanOffsetY < 0.f && contentOffsetY > 0)];
//            _oldPanOffsetY = nowPanOffsetY;
//        }
//    }
//}
//
//- (void)hideToolBar:(BOOL)hide{
//    if (hide != self.rdv_tabBarController.tabBarHidden) {
//        Tweets *curTweets = [self getCurTweets];
//        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (hide? (curTweets.canLoadMore? 60.0: 0.0):CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)), 0.0);
//        self.myTableView.contentInset = contentInsets;
//        [self.rdv_tabBarController setTabBarHidden:hide animated:YES];
//    }
//}
//
//
//- (void)dealloc
//{
//    _myTableView.delegate = nil;
//    _myTableView.dataSource = nil;
//}
//

@end
