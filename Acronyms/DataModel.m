//
//  DataModel.m
//  Acronyms
//
//  Created by Zhang Xu on 3/16/17.
//  Copyright © 2017 Zhang Xu. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(void)initWithDictionary:(NSDictionary *)dict{
    
    self.vars = [[NSMutableArray alloc]init];
    
    self.lf = [dict objectForKey:@"lf"];
    self.since = [[dict objectForKey:@"since"] integerValue];
    self.frequency = [[dict objectForKey:@"freq"] integerValue];
    
    NSArray *varsArray = [dict objectForKey:@"vars"];
    
    for (NSDictionary *varDictionary in varsArray) {
        
        DataModel *data = [DataModel new];
        [data initWithDictionary:varDictionary];
        [self.vars addObject:data];
    }
}

@end
