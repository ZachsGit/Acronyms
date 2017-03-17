//
//  ViewController.m
//  Acronyms
//
//  Created by Zhang Xu on 3/16/17.
//  Copyright © 2017 Zhang Xu. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "MainTableViewCell.h"
#import "dataModel.h"

@interface ViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *dataArray;
    NSMutableArray *mutableDataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mutableDataArray = [[NSMutableArray alloc]init];
    
    self.theSearchBar.delegate = self;
    
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
    self.theTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    mutableDataArray = [[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getAcrombieDataWithSf:self.theSearchBar.text];
    [searchBar resignFirstResponder];
}

-(void)getAcrombieDataWithSf:(NSString *)sfString{
    
    //NSDictionary *parameters = @{@"sf": sfString};
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@",sfString];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (jsonArray.count > 0) {
            
            dataArray = [[jsonArray objectAtIndex:0]objectForKey:@"lfs"];
            
        }else{
            
            dataArray = [NSArray new];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
                [self.theTableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
        
        if (dataArray.count > 0) {
            
            for (NSDictionary *dataDictionary in dataArray){
                
                DataModel *data = [DataModel new];
                [data initWithDictionary:dataDictionary];
                
                [mutableDataArray addObject:data];
            }
            

            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
                [self.theTableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            });
        }
        
    }];
    
    [sessionDataTask resume];

}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return mutableDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    DataModel *data = mutableDataArray[section];
    
    return data.vars.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 50)];
    
    DataModel *data = mutableDataArray[section];
    NSString *sectionString = [NSString stringWithFormat:@"Frequency: %tu, lf: %@, since: %tu",data.frequency,data.lf,data.since];
    
    label.numberOfLines = 0;
    [label setText:sectionString];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    DataModel *sectionData = mutableDataArray[indexPath.section];
    DataModel *rowData = sectionData.vars[indexPath.row];
    
    cell.label.text = [NSString stringWithFormat:@"Frequency: %tu, lf: %@, since: %tu",rowData.frequency,rowData.lf,rowData.since];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
