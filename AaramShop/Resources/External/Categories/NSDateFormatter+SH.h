

@interface NSDateFormatter(NSDateFormatterSH)

+(NSDate*)				dateFromWSString		:(NSString*)				inDateStr;
+(NSDateFormatter*)		RRWSDateFormatter;
+(NSDateFormatter*)		RRWSDate2Formatter;
+(NSDateFormatter*)		RRUIDateFormatter;

+(NSDateFormatter*)		RRUIArticleCellDateFormatter;
+(NSDateFormatter*)		RRUIArticleCellBigDateFormatter;
+(NSDateFormatter*)		RRUIArticleSmallCellNormalDateFormatter;
@end
