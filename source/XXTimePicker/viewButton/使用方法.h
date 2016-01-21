

1创建控件
//初始化小科室标签界面
TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, -TagViewH , self.view.width, TagViewH)];
tagView.backgroundColor = [UIColor whiteColor];
tagView.tagDelegate = self;
self.tagView = tagView;
self.tagView.scrollEnabled = YES;
self.tagView.userInteractionEnabled = YES;
self.tagView.contentSize = CGSizeMake(self.view.width, TagViewH);
self.tagView.contentInset = UIEdgeInsetsMake(120, 0,0, 0);//加上tableView之后需要设置顶部为60
[self.view addSubview:tagView];


2实现代理方法
#pragma mark - TagView的代理方法 / 选择某个小科室
- (void)tagView:(TagView *)tagView didClickedLabelButton:(XiaoKeShiButton *)button
{
    SHSLog(@"选择了 ==== >>>>>  %@ 科室 科室id ========== > >  %zd",button.titleLabel.text,button.tag);
    
    self.departmentDetailId = button.tag;
    button.selected = YES;
    
    self.naviTitle = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    self.ksTagTitile = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    
    if ([button.titleLabel.text isEqualToString:@"全部"]) {
        self.title = [NSString stringWithFormat:@"%@",self.naviTitle];
    }else{
        self.title = [NSString stringWithFormat:@"%@",button.titleLabel.text];
    }
    
    [self.keShiBtn setTitle:@"" forState:UIControlStateNormal];
    self.ksImageView.hidden = NO;
    self.ksLabel.hidden = NO;
    
    /** 根据科室id加载问题列表 */
    [self getXiaoKeShiListIsMore:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickedKeShiBtn:self.keShiBtn];
    });
}