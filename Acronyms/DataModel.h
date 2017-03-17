//
//  DataModel.h
//  Acronyms
//
//  Created by Zhang Xu on 3/16/17.
//  Copyright © 2017 Zhang Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, assign) NSInteger frequency;
@property (nonatomic, strong) NSString *lf;
@property (nonatomic, assign) NSInteger since;
@property (nonatomic, strong) NSMutableArray *vars;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
