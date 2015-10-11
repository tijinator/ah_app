/*
 Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at
 
 http://aws.amazon.com/apache2.0
 
 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */

#import "AWSCloudWatchResources.h"
#import "AWSLogging.h"

@interface AWSCloudWatchResources ()

@property (nonatomic, strong) NSDictionary *definitionDictionary;

@end

@implementation AWSCloudWatchResources

+ (instancetype)sharedInstance {
    static AWSCloudWatchResources *_sharedResources = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        _sharedResources = [AWSCloudWatchResources new];
    });
    
    return _sharedResources;
}
- (NSDictionary *)JSONObject {
    return self.definitionDictionary;
}

- (instancetype)init {
    if (self = [super init]) {
        //init method
        NSError *error = nil;
        _definitionDictionary = [NSJSONSerialization JSONObjectWithData:[[self definitionString] dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:kNilOptions
                                                                  error:&error];
        if (_definitionDictionary == nil) {
            if (error) {
                AWSLogError(@"Failed to parse JSON service definition: %@",error);
            }
        }
    }
    return self;
}

- (NSString *)definitionString {
    return @" \
    { \
      \"version\":\"2.0\", \
      \"metadata\":{ \
        \"apiVersion\":\"2010-08-01\", \
        \"endpointPrefix\":\"monitoring\", \
        \"serviceAbbreviation\":\"CloudWatch\", \
        \"serviceFullName\":\"Amazon CloudWatch\", \
        \"signatureVersion\":\"v4\", \
        \"xmlNamespace\":\"http://monitoring.amazonaws.com/doc/2010-08-01/\", \
        \"protocol\":\"query\" \
      }, \
      \"documentation\":\"<p>This is the <i>Amazon CloudWatch API Reference</i>. This guide provides detailed information about Amazon CloudWatch actions, data types, parameters, and errors. For detailed information about Amazon CloudWatch features and their associated API calls, go to the <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide\\\">Amazon CloudWatch Developer Guide</a>. </p> <p>Amazon CloudWatch is a web service that enables you to publish, monitor, and manage various metrics, as well as configure alarm actions based on data from metrics. For more information about this product go to <a href=\\\"http://aws.amazon.com/cloudwatch\\\">http://aws.amazon.com/cloudwatch</a>. </p> <p> For information about the namespace, metric names, and dimensions that other Amazon Web Services products use to send metrics to Cloudwatch, go to <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html\\\">Amazon CloudWatch Metrics, Namespaces, and Dimensions Reference</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p> <p>Use the following links to get started using the <i>Amazon CloudWatch API Reference</i>:</p> <ul> <li> <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_Operations.html\\\">Actions</a>: An alphabetical list of all Amazon CloudWatch actions.</li> <li> <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_Types.html\\\">Data Types</a>: An alphabetical list of all Amazon CloudWatch data types.</li> <li> <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CommonParameters.html\\\">Common Parameters</a>: Parameters that all Query actions can use.</li> <li> <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CommonErrors.html\\\">Common Errors</a>: Client and server errors that all actions can return.</li> <li> <a href=\\\"http://docs.aws.amazon.com/general/latest/gr/index.html?rande.html\\\">Regions and Endpoints</a>: Itemized regions and endpoints for all AWS products.</li> <li> <a href=\\\"http://monitoring.amazonaws.com/doc/2010-08-01/CloudWatch.wsdl\\\">WSDL Location</a>: http://monitoring.amazonaws.com/doc/2010-08-01/CloudWatch.wsdl</li> </ul> <p>In addition to using the Amazon CloudWatch API, you can also use the following SDKs and third-party libraries to access Amazon CloudWatch programmatically.</p> <ul> <li><a href=\\\"http://aws.amazon.com/documentation/sdkforjava/\\\">AWS SDK for Java Documentation</a></li> <li><a href=\\\"http://aws.amazon.com/documentation/sdkfornet/\\\">AWS SDK for .NET Documentation</a></li> <li><a href=\\\"http://aws.amazon.com/documentation/sdkforphp/\\\">AWS SDK for PHP Documentation</a></li> <li><a href=\\\"http://aws.amazon.com/documentation/sdkforruby/\\\">AWS SDK for Ruby Documentation</a></li> </ul> <p>Developers in the AWS developer community also provide their own libraries, which you can find at the following AWS developer centers:</p> <ul> <li><a href=\\\"http://aws.amazon.com/java/\\\">AWS Java Developer Center</a></li> <li><a href=\\\"http://aws.amazon.com/php/\\\">AWS PHP Developer Center</a></li> <li><a href=\\\"http://aws.amazon.com/python/\\\">AWS Python Developer Center</a></li> <li><a href=\\\"http://aws.amazon.com/ruby/\\\">AWS Ruby Developer Center</a></li> <li><a href=\\\"http://aws.amazon.com/net/\\\">AWS Windows and .NET Developer Center</a></li> </ul>\", \
      \"operations\":{ \
        \"DeleteAlarms\":{ \
          \"name\":\"DeleteAlarms\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"DeleteAlarmsInput\"}, \
          \"errors\":[ \
            { \
              \"shape\":\"ResourceNotFound\", \
              \"error\":{ \
                \"code\":\"ResourceNotFound\", \
                \"httpStatusCode\":404, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> The named resource does not exist. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Deletes all specified alarms. In the event of an error, no alarms are deleted. </p>\" \
        }, \
        \"DescribeAlarmHistory\":{ \
          \"name\":\"DescribeAlarmHistory\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"DescribeAlarmHistoryInput\"}, \
          \"output\":{ \
            \"shape\":\"DescribeAlarmHistoryOutput\", \
            \"documentation\":\"<p> The output for the <a>DescribeAlarmHistory</a> action. </p>\", \
            \"resultWrapper\":\"DescribeAlarmHistoryResult\" \
          }, \
          \"errors\":[ \
            { \
              \"shape\":\"InvalidNextToken\", \
              \"error\":{ \
                \"code\":\"InvalidNextToken\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> The next token specified is invalid. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Retrieves history for the specified alarm. Filter alarms by date range or item type. If an alarm name is not specified, Amazon CloudWatch returns histories for all of the owner's alarms. </p> <note> Amazon CloudWatch retains the history of an alarm for two weeks, whether or not you delete the alarm. </note>\" \
        }, \
        \"DescribeAlarms\":{ \
          \"name\":\"DescribeAlarms\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"DescribeAlarmsInput\"}, \
          \"output\":{ \
            \"shape\":\"DescribeAlarmsOutput\", \
            \"documentation\":\"<p> The output for the <a>DescribeAlarms</a> action. </p>\", \
            \"resultWrapper\":\"DescribeAlarmsResult\" \
          }, \
          \"errors\":[ \
            { \
              \"shape\":\"InvalidNextToken\", \
              \"error\":{ \
                \"code\":\"InvalidNextToken\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> The next token specified is invalid. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Retrieves alarms with the specified names. If no name is specified, all alarms for the user are returned. Alarms can be retrieved by using only a prefix for the alarm name, the alarm state, or a prefix for any action. </p>\" \
        }, \
        \"DescribeAlarmsForMetric\":{ \
          \"name\":\"DescribeAlarmsForMetric\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"DescribeAlarmsForMetricInput\"}, \
          \"output\":{ \
            \"shape\":\"DescribeAlarmsForMetricOutput\", \
            \"documentation\":\"<p> The output for the <a>DescribeAlarmsForMetric</a> action. </p>\", \
            \"resultWrapper\":\"DescribeAlarmsForMetricResult\" \
          }, \
          \"documentation\":\"<p> Retrieves all alarms for a single metric. Specify a statistic, period, or unit to filter the set of alarms further. </p>\" \
        }, \
        \"DisableAlarmActions\":{ \
          \"name\":\"DisableAlarmActions\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{ \
            \"shape\":\"DisableAlarmActionsInput\", \
            \"documentation\":\"<p> </p>\" \
          }, \
          \"documentation\":\"<p> Disables actions for the specified alarms. When an alarm's actions are disabled the alarm's state may change, but none of the alarm's actions will execute. </p>\" \
        }, \
        \"EnableAlarmActions\":{ \
          \"name\":\"EnableAlarmActions\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"EnableAlarmActionsInput\"}, \
          \"documentation\":\"<p> Enables actions for the specified alarms. </p>\" \
        }, \
        \"GetMetricStatistics\":{ \
          \"name\":\"GetMetricStatistics\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"GetMetricStatisticsInput\"}, \
          \"output\":{ \
            \"shape\":\"GetMetricStatisticsOutput\", \
            \"documentation\":\"<p> The output for the <a>GetMetricStatistics</a> action. </p>\", \
            \"resultWrapper\":\"GetMetricStatisticsResult\" \
          }, \
          \"errors\":[ \
            { \
              \"shape\":\"InvalidParameterValueException\", \
              \"error\":{ \
                \"code\":\"InvalidParameterValue\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Bad or out-of-range value was supplied for the input parameter. </p>\" \
            }, \
            { \
              \"shape\":\"MissingRequiredParameterException\", \
              \"error\":{ \
                \"code\":\"MissingParameter\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> An input parameter that is mandatory for processing the request is not supplied. </p>\" \
            }, \
            { \
              \"shape\":\"InvalidParameterCombinationException\", \
              \"error\":{ \
                \"code\":\"InvalidParameterCombination\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Parameters that must not be used together were used together. </p>\" \
            }, \
            { \
              \"shape\":\"InternalServiceFault\", \
              \"error\":{ \
                \"code\":\"InternalServiceError\", \
                \"httpStatusCode\":500 \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Indicates that the request processing has failed due to some unknown error, exception, or failure. </p>\", \
              \"xmlOrder\":[\"Message\"] \
            } \
          ], \
          \"documentation\":\"<p> Gets statistics for the specified metric. </p> <p> The maximum number of data points returned from a single <code>GetMetricStatistics</code> request is 1,440, wereas the maximum number of data points that can be queried is 50,850. If you make a request that generates more than 1,440 data points, Amazon CloudWatch returns an error. In such a case, you can alter the request by narrowing the specified time range or increasing the specified period. Alternatively, you can make multiple requests across adjacent time ranges. </p> <p> Amazon CloudWatch aggregates data points based on the length of the <code>period</code> that you specify. For example, if you request statistics with a one-minute granularity, Amazon CloudWatch aggregates data points with time stamps that fall within the same one-minute period. In such a case, the data points queried can greatly outnumber the data points returned. </p> <p> The following examples show various statistics allowed by the data point query maximum of 50,850 when you call <code>GetMetricStatistics</code> on Amazon EC2 instances with detailed (one-minute) monitoring enabled: </p> <ul> <li>Statistics for up to 400 instances for a span of one hour</li> <li>Statistics for up to 35 instances over a span of 24 hours</li> <li>Statistics for up to 2 instances over a span of 2 weeks</li> </ul> <p> For information about the namespace, metric names, and dimensions that other Amazon Web Services products use to send metrics to Cloudwatch, go to <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html\\\">Amazon CloudWatch Metrics, Namespaces, and Dimensions Reference</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
        }, \
        \"ListMetrics\":{ \
          \"name\":\"ListMetrics\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"ListMetricsInput\"}, \
          \"output\":{ \
            \"shape\":\"ListMetricsOutput\", \
            \"documentation\":\"<p> The output for the <a>ListMetrics</a> action. </p>\", \
            \"xmlOrder\":[ \
              \"Metrics\", \
              \"NextToken\" \
            ], \
            \"resultWrapper\":\"ListMetricsResult\" \
          }, \
          \"errors\":[ \
            { \
              \"shape\":\"InternalServiceFault\", \
              \"error\":{ \
                \"code\":\"InternalServiceError\", \
                \"httpStatusCode\":500 \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Indicates that the request processing has failed due to some unknown error, exception, or failure. </p>\", \
              \"xmlOrder\":[\"Message\"] \
            }, \
            { \
              \"shape\":\"InvalidParameterValueException\", \
              \"error\":{ \
                \"code\":\"InvalidParameterValue\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Bad or out-of-range value was supplied for the input parameter. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Returns a list of valid metrics stored for the AWS account owner. Returned metrics can be used with <a>GetMetricStatistics</a> to obtain statistical data for a given metric. </p> <note> Up to 500 results are returned for any one call. To retrieve further results, use returned <code>NextToken</code> values with subsequent <code>ListMetrics</code> operations. </note> <note> If you create a metric with the <a>PutMetricData</a> action, allow up to fifteen minutes for the metric to appear in calls to the <code>ListMetrics</code> action. Statistics about the metric, however, are available sooner using <a>GetMetricStatistics</a>. </note>\" \
        }, \
        \"PutMetricAlarm\":{ \
          \"name\":\"PutMetricAlarm\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"PutMetricAlarmInput\"}, \
          \"errors\":[ \
            { \
              \"shape\":\"LimitExceededFault\", \
              \"error\":{ \
                \"code\":\"LimitExceeded\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> The quota for alarms for this customer has already been reached. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Creates or updates an alarm and associates it with the specified Amazon CloudWatch metric. Optionally, this operation can associate one or more Amazon Simple Notification Service resources with the alarm. </p> <p> When this operation creates an alarm, the alarm state is immediately set to <code>INSUFFICIENT_DATA</code>. The alarm is evaluated and its <code>StateValue</code> is set appropriately. Any actions associated with the <code>StateValue</code> is then executed. </p> <note> When updating an existing alarm, its <code>StateValue</code> is left unchanged. </note>\" \
        }, \
        \"PutMetricData\":{ \
          \"name\":\"PutMetricData\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"PutMetricDataInput\"}, \
          \"errors\":[ \
            { \
              \"shape\":\"InvalidParameterValueException\", \
              \"error\":{ \
                \"code\":\"InvalidParameterValue\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Bad or out-of-range value was supplied for the input parameter. </p>\" \
            }, \
            { \
              \"shape\":\"MissingRequiredParameterException\", \
              \"error\":{ \
                \"code\":\"MissingParameter\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> An input parameter that is mandatory for processing the request is not supplied. </p>\" \
            }, \
            { \
              \"shape\":\"InvalidParameterCombinationException\", \
              \"error\":{ \
                \"code\":\"InvalidParameterCombination\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Parameters that must not be used together were used together. </p>\" \
            }, \
            { \
              \"shape\":\"InternalServiceFault\", \
              \"error\":{ \
                \"code\":\"InternalServiceError\", \
                \"httpStatusCode\":500 \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Indicates that the request processing has failed due to some unknown error, exception, or failure. </p>\", \
              \"xmlOrder\":[\"Message\"] \
            } \
          ], \
          \"documentation\":\"<p> Publishes metric data points to Amazon CloudWatch. Amazon Cloudwatch associates the data points with the specified metric. If the specified metric does not exist, Amazon CloudWatch creates the metric. It can take up to fifteen minutes for a new metric to appear in calls to the <a>ListMetrics</a> action.</p> <p> The size of a <function>PutMetricData</function> request is limited to 8 KB for HTTP GET requests and 40 KB for HTTP POST requests. </p> <important> Although the <code>Value</code> parameter accepts numbers of type <code>Double</code>, Amazon CloudWatch truncates values with very large exponents. Values with base-10 exponents greater than 126 (1 x 10^126) are truncated. Likewise, values with base-10 exponents less than -130 (1 x 10^-130) are also truncated. </important> <p>Data that is timestamped 24 hours or more in the past may take in excess of 48 hours to become available from submission time using <code>GetMetricStatistics</code>.</p>\" \
        }, \
        \"SetAlarmState\":{ \
          \"name\":\"SetAlarmState\", \
          \"http\":{ \
            \"method\":\"POST\", \
            \"requestUri\":\"/\" \
          }, \
          \"input\":{\"shape\":\"SetAlarmStateInput\"}, \
          \"errors\":[ \
            { \
              \"shape\":\"ResourceNotFound\", \
              \"error\":{ \
                \"code\":\"ResourceNotFound\", \
                \"httpStatusCode\":404, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> The named resource does not exist. </p>\" \
            }, \
            { \
              \"shape\":\"InvalidFormatFault\", \
              \"error\":{ \
                \"code\":\"InvalidFormat\", \
                \"httpStatusCode\":400, \
                \"senderFault\":true \
              }, \
              \"exception\":true, \
              \"documentation\":\"<p> Data was not syntactically valid JSON. </p>\" \
            } \
          ], \
          \"documentation\":\"<p> Temporarily sets the state of an alarm. When the updated <code>StateValue</code> differs from the previous value, the action configured for the appropriate state is invoked. This is not a permanent change. The next periodic alarm check (in about a minute) will set the alarm to its actual state. </p>\" \
        } \
      }, \
      \"shapes\":{ \
        \"ActionPrefix\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":1024 \
        }, \
        \"ActionsEnabled\":{\"type\":\"boolean\"}, \
        \"AlarmArn\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":1600 \
        }, \
        \"AlarmDescription\":{ \
          \"type\":\"string\", \
          \"min\":0, \
          \"max\":255 \
        }, \
        \"AlarmHistoryItem\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"AlarmName\":{ \
              \"shape\":\"AlarmName\", \
              \"documentation\":\"<p> The descriptive name for the alarm. </p>\" \
            }, \
            \"Timestamp\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp for the alarm history item. Amazon CloudWatch uses Coordinated Universal Time (UTC) when returning time stamps, which do not accommodate seasonal adjustments such as daylight savings time. For more information, see <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#about_timestamp\\\">Time stamps</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
            }, \
            \"HistoryItemType\":{ \
              \"shape\":\"HistoryItemType\", \
              \"documentation\":\"<p> The type of alarm history item. </p>\" \
            }, \
            \"HistorySummary\":{ \
              \"shape\":\"HistorySummary\", \
              \"documentation\":\"<p> A human-readable summary of the alarm history. </p>\" \
            }, \
            \"HistoryData\":{ \
              \"shape\":\"HistoryData\", \
              \"documentation\":\"<p> Machine-readable data about the alarm in JSON format. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>AlarmHistoryItem</code> data type contains descriptive information about the history of a specific alarm. If you call <a>DescribeAlarmHistory</a>, Amazon CloudWatch returns this data type as part of the <a>DescribeAlarmHistoryResult</a> data type. </p>\" \
        }, \
        \"AlarmHistoryItems\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"AlarmHistoryItem\"} \
        }, \
        \"AlarmName\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"AlarmNamePrefix\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"AlarmNames\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"AlarmName\"}, \
          \"max\":100 \
        }, \
        \"AwsQueryErrorMessage\":{\"type\":\"string\"}, \
        \"ComparisonOperator\":{ \
          \"type\":\"string\", \
          \"enum\":[ \
            \"GreaterThanOrEqualToThreshold\", \
            \"GreaterThanThreshold\", \
            \"LessThanThreshold\", \
            \"LessThanOrEqualToThreshold\" \
          ] \
        }, \
        \"Datapoint\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Timestamp\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp used for the datapoint. Amazon CloudWatch uses Coordinated Universal Time (UTC) when returning time stamps, which do not accommodate seasonal adjustments such as daylight savings time. For more information, see <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#about_timestamp\\\">Time stamps</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
            }, \
            \"SampleCount\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The number of metric values that contributed to the aggregate value of this datapoint. </p>\" \
            }, \
            \"Average\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The average of metric values that correspond to the datapoint. </p>\" \
            }, \
            \"Sum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The sum of metric values used for the datapoint. </p>\" \
            }, \
            \"Minimum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The minimum metric value used for the datapoint. </p>\" \
            }, \
            \"Maximum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The maximum of the metric value used for the datapoint. </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The standard unit used for the datapoint. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>Datapoint</code> data type encapsulates the statistical data that Amazon CloudWatch computes from metric data. </p>\", \
          \"xmlOrder\":[ \
            \"Timestamp\", \
            \"SampleCount\", \
            \"Average\", \
            \"Sum\", \
            \"Minimum\", \
            \"Maximum\", \
            \"Unit\" \
          ] \
        }, \
        \"DatapointValue\":{\"type\":\"double\"}, \
        \"Datapoints\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"Datapoint\"} \
        }, \
        \"DeleteAlarmsInput\":{ \
          \"type\":\"structure\", \
          \"required\":[\"AlarmNames\"], \
          \"members\":{ \
            \"AlarmNames\":{ \
              \"shape\":\"AlarmNames\", \
              \"documentation\":\"<p> A list of alarms to be deleted. </p>\" \
            } \
          } \
        }, \
        \"DescribeAlarmHistoryInput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"AlarmName\":{ \
              \"shape\":\"AlarmName\", \
              \"documentation\":\"<p> The name of the alarm. </p>\" \
            }, \
            \"HistoryItemType\":{ \
              \"shape\":\"HistoryItemType\", \
              \"documentation\":\"<p> The type of alarm histories to retrieve. </p>\" \
            }, \
            \"StartDate\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The starting date to retrieve alarm history. </p>\" \
            }, \
            \"EndDate\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The ending date to retrieve alarm history. </p>\" \
            }, \
            \"MaxRecords\":{ \
              \"shape\":\"MaxRecords\", \
              \"documentation\":\"<p> The maximum number of alarm history records to retrieve. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> The token returned by a previous call to indicate that there is more data available. </p>\" \
            } \
          } \
        }, \
        \"DescribeAlarmHistoryOutput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"AlarmHistoryItems\":{ \
              \"shape\":\"AlarmHistoryItems\", \
              \"documentation\":\"<p> A list of alarm histories in JSON format. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> A string that marks the start of the next batch of returned results. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The output for the <a>DescribeAlarmHistory</a> action. </p>\" \
        }, \
        \"DescribeAlarmsForMetricInput\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"MetricName\", \
            \"Namespace\" \
          ], \
          \"members\":{ \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the metric. </p>\" \
            }, \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace of the metric. </p>\" \
            }, \
            \"Statistic\":{ \
              \"shape\":\"Statistic\", \
              \"documentation\":\"<p> The statistic for the metric. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> The list of dimensions associated with the metric. </p>\" \
            }, \
            \"Period\":{ \
              \"shape\":\"Period\", \
              \"documentation\":\"<p> The period in seconds over which the statistic is applied. </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The unit for the metric. </p>\" \
            } \
          } \
        }, \
        \"DescribeAlarmsForMetricOutput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"MetricAlarms\":{ \
              \"shape\":\"MetricAlarms\", \
              \"documentation\":\"<p> A list of information for each alarm with the specified metric. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The output for the <a>DescribeAlarmsForMetric</a> action. </p>\" \
        }, \
        \"DescribeAlarmsInput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"AlarmNames\":{ \
              \"shape\":\"AlarmNames\", \
              \"documentation\":\"<p> A list of alarm names to retrieve information for. </p>\" \
            }, \
            \"AlarmNamePrefix\":{ \
              \"shape\":\"AlarmNamePrefix\", \
              \"documentation\":\"<p> The alarm name prefix. <code>AlarmNames</code> cannot be specified if this parameter is specified. </p>\" \
            }, \
            \"StateValue\":{ \
              \"shape\":\"StateValue\", \
              \"documentation\":\"<p> The state value to be used in matching alarms. </p>\" \
            }, \
            \"ActionPrefix\":{ \
              \"shape\":\"ActionPrefix\", \
              \"documentation\":\"<p> The action name prefix. </p>\" \
            }, \
            \"MaxRecords\":{ \
              \"shape\":\"MaxRecords\", \
              \"documentation\":\"<p> The maximum number of alarm descriptions to retrieve. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> The token returned by a previous call to indicate that there is more data available. </p>\" \
            } \
          } \
        }, \
        \"DescribeAlarmsOutput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"MetricAlarms\":{ \
              \"shape\":\"MetricAlarms\", \
              \"documentation\":\"<p> A list of information for the specified alarms. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> A string that marks the start of the next batch of returned results. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The output for the <a>DescribeAlarms</a> action. </p>\" \
        }, \
        \"Dimension\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"Name\", \
            \"Value\" \
          ], \
          \"members\":{ \
            \"Name\":{ \
              \"shape\":\"DimensionName\", \
              \"documentation\":\"<p> The name of the dimension. </p>\" \
            }, \
            \"Value\":{ \
              \"shape\":\"DimensionValue\", \
              \"documentation\":\"<p> The value representing the dimension measurement </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>Dimension</code> data type further expands on the identity of a metric using a Name, Value pair. </p> <p>For examples that use one or more dimensions, see <a>PutMetricData</a>.</p>\", \
          \"xmlOrder\":[ \
            \"Name\", \
            \"Value\" \
          ] \
        }, \
        \"DimensionFilter\":{ \
          \"type\":\"structure\", \
          \"required\":[\"Name\"], \
          \"members\":{ \
            \"Name\":{ \
              \"shape\":\"DimensionName\", \
              \"documentation\":\"<p> The dimension name to be matched. </p>\" \
            }, \
            \"Value\":{ \
              \"shape\":\"DimensionValue\", \
              \"documentation\":\"<p> The value of the dimension to be matched. </p> <note> Specifying a <code>Name</code> without specifying a <code>Value</code> returns all values associated with that <code>Name</code>. </note>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>DimensionFilter</code> data type is used to filter <a>ListMetrics</a> results. </p>\" \
        }, \
        \"DimensionFilters\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"DimensionFilter\"}, \
          \"max\":10 \
        }, \
        \"DimensionName\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"DimensionValue\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"Dimensions\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"Dimension\"}, \
          \"max\":10 \
        }, \
        \"DisableAlarmActionsInput\":{ \
          \"type\":\"structure\", \
          \"required\":[\"AlarmNames\"], \
          \"members\":{ \
            \"AlarmNames\":{ \
              \"shape\":\"AlarmNames\", \
              \"documentation\":\"<p> The names of the alarms to disable actions for. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> </p>\" \
        }, \
        \"EnableAlarmActionsInput\":{ \
          \"type\":\"structure\", \
          \"required\":[\"AlarmNames\"], \
          \"members\":{ \
            \"AlarmNames\":{ \
              \"shape\":\"AlarmNames\", \
              \"documentation\":\"<p> The names of the alarms to enable actions for. </p>\" \
            } \
          } \
        }, \
        \"ErrorMessage\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"EvaluationPeriods\":{ \
          \"type\":\"integer\", \
          \"min\":1 \
        }, \
        \"FaultDescription\":{\"type\":\"string\"}, \
        \"GetMetricStatisticsInput\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"Namespace\", \
            \"MetricName\", \
            \"StartTime\", \
            \"EndTime\", \
            \"Period\", \
            \"Statistics\" \
          ], \
          \"members\":{ \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace of the metric, with or without spaces. </p>\" \
            }, \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the metric, with or without spaces. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> A list of dimensions describing qualities of the metric. </p>\" \
            }, \
            \"StartTime\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp to use for determining the first datapoint to return. The value specified is inclusive; results include datapoints with the time stamp specified. </p> <note> The specified start time is rounded down to the nearest value. Datapoints are returned for start times up to two weeks in the past. Specified start times that are more than two weeks in the past will not return datapoints for metrics that are older than two weeks. <p>Data that is timestamped 24 hours or more in the past may take in excess of 48 hours to become available from submission time using <code>GetMetricStatistics</code>.</p> </note>\" \
            }, \
            \"EndTime\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp to use for determining the last datapoint to return. The value specified is exclusive; results will include datapoints up to the time stamp specified. </p>\" \
            }, \
            \"Period\":{ \
              \"shape\":\"Period\", \
              \"documentation\":\"<p> The granularity, in seconds, of the returned datapoints. <code>Period</code> must be at least 60 seconds and must be a multiple of 60. The default value is 60. </p>\" \
            }, \
            \"Statistics\":{ \
              \"shape\":\"Statistics\", \
              \"documentation\":\"<p> The metric statistics to return. For information about specific statistics returned by GetMetricStatistics, go to <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/index.html?CHAP_TerminologyandKeyConcepts.html#Statistic\\\">Statistics</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p> <p> Valid Values: <code>Average | Sum | SampleCount | Maximum | Minimum</code> </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The unit for the metric. </p>\" \
            } \
          } \
        }, \
        \"GetMetricStatisticsOutput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Label\":{ \
              \"shape\":\"MetricLabel\", \
              \"documentation\":\"<p> A label describing the specified metric. </p>\" \
            }, \
            \"Datapoints\":{ \
              \"shape\":\"Datapoints\", \
              \"documentation\":\"<p> The datapoints for the specified metric. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The output for the <a>GetMetricStatistics</a> action. </p>\" \
        }, \
        \"HistoryData\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":4095 \
        }, \
        \"HistoryItemType\":{ \
          \"type\":\"string\", \
          \"enum\":[ \
            \"ConfigurationUpdate\", \
            \"StateUpdate\", \
            \"Action\" \
          ] \
        }, \
        \"HistorySummary\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"InternalServiceFault\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Message\":{ \
              \"shape\":\"FaultDescription\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"InternalServiceError\", \
            \"httpStatusCode\":500 \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> Indicates that the request processing has failed due to some unknown error, exception, or failure. </p>\", \
          \"xmlOrder\":[\"Message\"] \
        }, \
        \"InvalidFormatFault\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"ErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"InvalidFormat\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> Data was not syntactically valid JSON. </p>\" \
        }, \
        \"InvalidNextToken\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"ErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"InvalidNextToken\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> The next token specified is invalid. </p>\" \
        }, \
        \"InvalidParameterCombinationException\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"AwsQueryErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"InvalidParameterCombination\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> Parameters that must not be used together were used together. </p>\" \
        }, \
        \"InvalidParameterValueException\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"AwsQueryErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"InvalidParameterValue\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> Bad or out-of-range value was supplied for the input parameter. </p>\" \
        }, \
        \"LimitExceededFault\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"ErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"LimitExceeded\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> The quota for alarms for this customer has already been reached. </p>\" \
        }, \
        \"ListMetricsInput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace to filter against. </p>\" \
            }, \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the metric to filter against. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"DimensionFilters\", \
              \"documentation\":\"<p> A list of dimensions to filter against. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> The token returned by a previous call to indicate that there is more data available. </p>\" \
            } \
          } \
        }, \
        \"ListMetricsOutput\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Metrics\":{ \
              \"shape\":\"Metrics\", \
              \"documentation\":\"<p> A list of metrics used to generate statistics for an AWS account. </p>\" \
            }, \
            \"NextToken\":{ \
              \"shape\":\"NextToken\", \
              \"documentation\":\"<p> A string that marks the start of the next batch of returned results. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The output for the <a>ListMetrics</a> action. </p>\", \
          \"xmlOrder\":[ \
            \"Metrics\", \
            \"NextToken\" \
          ] \
        }, \
        \"MaxRecords\":{ \
          \"type\":\"integer\", \
          \"min\":1, \
          \"max\":100 \
        }, \
        \"Metric\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace of the metric. </p>\" \
            }, \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the metric. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> A list of dimensions associated with the metric. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>Metric</code> data type contains information about a specific metric. If you call <a>ListMetrics</a>, Amazon CloudWatch returns information contained by this data type. </p> <p> The example in the Examples section publishes two metrics named buffers and latency. Both metrics are in the examples namespace. Both metrics have two dimensions, InstanceID and InstanceType. </p>\", \
          \"xmlOrder\":[ \
            \"Namespace\", \
            \"MetricName\", \
            \"Dimensions\" \
          ] \
        }, \
        \"MetricAlarm\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"AlarmName\":{ \
              \"shape\":\"AlarmName\", \
              \"documentation\":\"<p> The name of the alarm. </p>\" \
            }, \
            \"AlarmArn\":{ \
              \"shape\":\"AlarmArn\", \
              \"documentation\":\"<p> The Amazon Resource Name (ARN) of the alarm. </p>\" \
            }, \
            \"AlarmDescription\":{ \
              \"shape\":\"AlarmDescription\", \
              \"documentation\":\"<p> The description for the alarm. </p>\" \
            }, \
            \"AlarmConfigurationUpdatedTimestamp\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp of the last update to the alarm configuration. Amazon CloudWatch uses Coordinated Universal Time (UTC) when returning time stamps, which do not accommodate seasonal adjustments such as daylight savings time. For more information, see <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#about_timestamp\\\">Time stamps</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
            }, \
            \"ActionsEnabled\":{ \
              \"shape\":\"ActionsEnabled\", \
              \"documentation\":\"<p> Indicates whether actions should be executed during any changes to the alarm's state. </p>\" \
            }, \
            \"OKActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>OK</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only actions supported are publishing to an Amazon SNS topic and triggering an Auto Scaling policy. </p>\" \
            }, \
            \"AlarmActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>ALARM</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only actions supported are publishing to an Amazon SNS topic and triggering an Auto Scaling policy. </p>\" \
            }, \
            \"InsufficientDataActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>INSUFFICIENT_DATA</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only actions supported are publishing to an Amazon SNS topic or triggering an Auto Scaling policy. </p> <important>The current WSDL lists this attribute as <code>UnknownActions</code>.</important>\" \
            }, \
            \"StateValue\":{ \
              \"shape\":\"StateValue\", \
              \"documentation\":\"<p> The state value for the alarm. </p>\" \
            }, \
            \"StateReason\":{ \
              \"shape\":\"StateReason\", \
              \"documentation\":\"<p> A human-readable explanation for the alarm's state. </p>\" \
            }, \
            \"StateReasonData\":{ \
              \"shape\":\"StateReasonData\", \
              \"documentation\":\"<p> An explanation for the alarm's state in machine-readable JSON format </p>\" \
            }, \
            \"StateUpdatedTimestamp\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp of the last update to the alarm's state. Amazon CloudWatch uses Coordinated Universal Time (UTC) when returning time stamps, which do not accommodate seasonal adjustments such as daylight savings time. For more information, see <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#about_timestamp\\\">Time stamps</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
            }, \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the alarm's metric. </p>\" \
            }, \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace of alarm's associated metric. </p>\" \
            }, \
            \"Statistic\":{ \
              \"shape\":\"Statistic\", \
              \"documentation\":\"<p> The statistic to apply to the alarm's associated metric. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> The list of dimensions associated with the alarm's associated metric. </p>\" \
            }, \
            \"Period\":{ \
              \"shape\":\"Period\", \
              \"documentation\":\"<p> The period in seconds over which the statistic is applied. </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The unit of the alarm's associated metric. </p>\" \
            }, \
            \"EvaluationPeriods\":{ \
              \"shape\":\"EvaluationPeriods\", \
              \"documentation\":\"<p> The number of periods over which data is compared to the specified threshold. </p>\" \
            }, \
            \"Threshold\":{ \
              \"shape\":\"Threshold\", \
              \"documentation\":\"<p> The value against which the specified statistic is compared. </p>\" \
            }, \
            \"ComparisonOperator\":{ \
              \"shape\":\"ComparisonOperator\", \
              \"documentation\":\"<p> The arithmetic operation to use when comparing the specified <code>Statistic</code> and <code>Threshold</code>. The specified <code>Statistic</code> value is used as the first operand. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <a>MetricAlarm</a> data type represents an alarm. You can use <a>PutMetricAlarm</a> to create or update an alarm. </p>\", \
          \"xmlOrder\":[ \
            \"AlarmName\", \
            \"AlarmArn\", \
            \"AlarmDescription\", \
            \"AlarmConfigurationUpdatedTimestamp\", \
            \"ActionsEnabled\", \
            \"OKActions\", \
            \"AlarmActions\", \
            \"InsufficientDataActions\", \
            \"StateValue\", \
            \"StateReason\", \
            \"StateReasonData\", \
            \"StateUpdatedTimestamp\", \
            \"MetricName\", \
            \"Namespace\", \
            \"Statistic\", \
            \"Dimensions\", \
            \"Period\", \
            \"Unit\", \
            \"EvaluationPeriods\", \
            \"Threshold\", \
            \"ComparisonOperator\" \
          ] \
        }, \
        \"MetricAlarms\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"MetricAlarm\"} \
        }, \
        \"MetricData\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"MetricDatum\"} \
        }, \
        \"MetricDatum\":{ \
          \"type\":\"structure\", \
          \"required\":[\"MetricName\"], \
          \"members\":{ \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name of the metric. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> A list of dimensions associated with the metric. Note, when using the Dimensions value in a query, you need to append .member.N to it (e.g., Dimensions.member.N). </p>\" \
            }, \
            \"Timestamp\":{ \
              \"shape\":\"Timestamp\", \
              \"documentation\":\"<p> The time stamp used for the metric. If not specified, the default value is set to the time the metric data was received. Amazon CloudWatch uses Coordinated Universal Time (UTC) when returning time stamps, which do not accommodate seasonal adjustments such as daylight savings time. For more information, see <a href=\\\"http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#about_timestamp\\\">Time stamps</a> in the <i>Amazon CloudWatch Developer Guide</i>. </p>\" \
            }, \
            \"Value\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The value for the metric. </p> <important>Although the <code>Value</code> parameter accepts numbers of type <code>Double</code>, Amazon CloudWatch truncates values with very large exponents. Values with base-10 exponents greater than 126 (1 x 10^126) are truncated. Likewise, values with base-10 exponents less than -130 (1 x 10^-130) are also truncated. </important>\" \
            }, \
            \"StatisticValues\":{ \
              \"shape\":\"StatisticSet\", \
              \"documentation\":\"<p> A set of statistical values describing the metric. </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The unit of the metric. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>MetricDatum</code> data type encapsulates the information sent with <a>PutMetricData</a> to either create a new metric or add new values to be aggregated into an existing metric. </p>\" \
        }, \
        \"MetricLabel\":{\"type\":\"string\"}, \
        \"MetricName\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255 \
        }, \
        \"Metrics\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"Metric\"} \
        }, \
        \"MissingRequiredParameterException\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"AwsQueryErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"MissingParameter\", \
            \"httpStatusCode\":400, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> An input parameter that is mandatory for processing the request is not supplied. </p>\" \
        }, \
        \"Namespace\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":255, \
          \"pattern\":\"[^:].*\" \
        }, \
        \"NextToken\":{\"type\":\"string\"}, \
        \"Period\":{ \
          \"type\":\"integer\", \
          \"min\":60 \
        }, \
        \"PutMetricAlarmInput\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"AlarmName\", \
            \"MetricName\", \
            \"Namespace\", \
            \"Statistic\", \
            \"Period\", \
            \"EvaluationPeriods\", \
            \"Threshold\", \
            \"ComparisonOperator\" \
          ], \
          \"members\":{ \
            \"AlarmName\":{ \
              \"shape\":\"AlarmName\", \
              \"documentation\":\"<p> The descriptive name for the alarm. This name must be unique within the user's AWS account </p>\" \
            }, \
            \"AlarmDescription\":{ \
              \"shape\":\"AlarmDescription\", \
              \"documentation\":\"<p> The description for the alarm. </p>\" \
            }, \
            \"ActionsEnabled\":{ \
              \"shape\":\"ActionsEnabled\", \
              \"documentation\":\"<p> Indicates whether or not actions should be executed during any changes to the alarm's state. </p>\" \
            }, \
            \"OKActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>OK</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only action supported is publishing to an Amazon SNS topic or an Amazon Auto Scaling policy. </p>\" \
            }, \
            \"AlarmActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>ALARM</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only action supported is publishing to an Amazon SNS topic or an Amazon Auto Scaling policy. </p>\" \
            }, \
            \"InsufficientDataActions\":{ \
              \"shape\":\"ResourceList\", \
              \"documentation\":\"<p> The list of actions to execute when this alarm transitions into an <code>INSUFFICIENT_DATA</code> state from any other state. Each action is specified as an Amazon Resource Number (ARN). Currently the only action supported is publishing to an Amazon SNS topic or an Amazon Auto Scaling policy. </p>\" \
            }, \
            \"MetricName\":{ \
              \"shape\":\"MetricName\", \
              \"documentation\":\"<p> The name for the alarm's associated metric. </p>\" \
            }, \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace for the alarm's associated metric. </p>\" \
            }, \
            \"Statistic\":{ \
              \"shape\":\"Statistic\", \
              \"documentation\":\"<p> The statistic to apply to the alarm's associated metric. </p>\" \
            }, \
            \"Dimensions\":{ \
              \"shape\":\"Dimensions\", \
              \"documentation\":\"<p> The dimensions for the alarm's associated metric. </p>\" \
            }, \
            \"Period\":{ \
              \"shape\":\"Period\", \
              \"documentation\":\"<p> The period in seconds over which the specified statistic is applied. </p>\" \
            }, \
            \"Unit\":{ \
              \"shape\":\"StandardUnit\", \
              \"documentation\":\"<p> The unit for the alarm's associated metric. </p>\" \
            }, \
            \"EvaluationPeriods\":{ \
              \"shape\":\"EvaluationPeriods\", \
              \"documentation\":\"<p> The number of periods over which data is compared to the specified threshold. </p>\" \
            }, \
            \"Threshold\":{ \
              \"shape\":\"Threshold\", \
              \"documentation\":\"<p> The value against which the specified statistic is compared. </p>\" \
            }, \
            \"ComparisonOperator\":{ \
              \"shape\":\"ComparisonOperator\", \
              \"documentation\":\"<p> The arithmetic operation to use when comparing the specified <code>Statistic</code> and <code>Threshold</code>. The specified <code>Statistic</code> value is used as the first operand. </p>\" \
            } \
          } \
        }, \
        \"PutMetricDataInput\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"Namespace\", \
            \"MetricData\" \
          ], \
          \"members\":{ \
            \"Namespace\":{ \
              \"shape\":\"Namespace\", \
              \"documentation\":\"<p> The namespace for the metric data. </p> <note> You cannot specify a namespace that begins with \\\"AWS/\\\". Namespaces that begin with \\\"AWS/\\\" are reserved for other Amazon Web Services products that send metrics to Amazon CloudWatch. </note>\" \
            }, \
            \"MetricData\":{ \
              \"shape\":\"MetricData\", \
              \"documentation\":\"<p> A list of data describing the metric. </p>\" \
            } \
          } \
        }, \
        \"ResourceList\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"ResourceName\"}, \
          \"max\":5 \
        }, \
        \"ResourceName\":{ \
          \"type\":\"string\", \
          \"min\":1, \
          \"max\":1024 \
        }, \
        \"ResourceNotFound\":{ \
          \"type\":\"structure\", \
          \"members\":{ \
            \"message\":{ \
              \"shape\":\"ErrorMessage\", \
              \"documentation\":\"<p></p>\" \
            } \
          }, \
          \"error\":{ \
            \"code\":\"ResourceNotFound\", \
            \"httpStatusCode\":404, \
            \"senderFault\":true \
          }, \
          \"exception\":true, \
          \"documentation\":\"<p> The named resource does not exist. </p>\" \
        }, \
        \"SetAlarmStateInput\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"AlarmName\", \
            \"StateValue\", \
            \"StateReason\" \
          ], \
          \"members\":{ \
            \"AlarmName\":{ \
              \"shape\":\"AlarmName\", \
              \"documentation\":\"<p> The descriptive name for the alarm. This name must be unique within the user's AWS account. The maximum length is 255 characters. </p>\" \
            }, \
            \"StateValue\":{ \
              \"shape\":\"StateValue\", \
              \"documentation\":\"<p> The value of the state. </p>\" \
            }, \
            \"StateReason\":{ \
              \"shape\":\"StateReason\", \
              \"documentation\":\"<p> The reason that this alarm is set to this specific state (in human-readable text format) </p>\" \
            }, \
            \"StateReasonData\":{ \
              \"shape\":\"StateReasonData\", \
              \"documentation\":\"<p> The reason that this alarm is set to this specific state (in machine-readable JSON format) </p>\" \
            } \
          } \
        }, \
        \"StandardUnit\":{ \
          \"type\":\"string\", \
          \"enum\":[ \
            \"Seconds\", \
            \"Microseconds\", \
            \"Milliseconds\", \
            \"Bytes\", \
            \"Kilobytes\", \
            \"Megabytes\", \
            \"Gigabytes\", \
            \"Terabytes\", \
            \"Bits\", \
            \"Kilobits\", \
            \"Megabits\", \
            \"Gigabits\", \
            \"Terabits\", \
            \"Percent\", \
            \"Count\", \
            \"Bytes/Second\", \
            \"Kilobytes/Second\", \
            \"Megabytes/Second\", \
            \"Gigabytes/Second\", \
            \"Terabytes/Second\", \
            \"Bits/Second\", \
            \"Kilobits/Second\", \
            \"Megabits/Second\", \
            \"Gigabits/Second\", \
            \"Terabits/Second\", \
            \"Count/Second\", \
            \"None\" \
          ] \
        }, \
        \"StateReason\":{ \
          \"type\":\"string\", \
          \"min\":0, \
          \"max\":1023 \
        }, \
        \"StateReasonData\":{ \
          \"type\":\"string\", \
          \"min\":0, \
          \"max\":4000 \
        }, \
        \"StateValue\":{ \
          \"type\":\"string\", \
          \"enum\":[ \
            \"OK\", \
            \"ALARM\", \
            \"INSUFFICIENT_DATA\" \
          ] \
        }, \
        \"Statistic\":{ \
          \"type\":\"string\", \
          \"enum\":[ \
            \"SampleCount\", \
            \"Average\", \
            \"Sum\", \
            \"Minimum\", \
            \"Maximum\" \
          ] \
        }, \
        \"StatisticSet\":{ \
          \"type\":\"structure\", \
          \"required\":[ \
            \"SampleCount\", \
            \"Sum\", \
            \"Minimum\", \
            \"Maximum\" \
          ], \
          \"members\":{ \
            \"SampleCount\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The number of samples used for the statistic set. </p>\" \
            }, \
            \"Sum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The sum of values for the sample set. </p>\" \
            }, \
            \"Minimum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The minimum value of the sample set. </p>\" \
            }, \
            \"Maximum\":{ \
              \"shape\":\"DatapointValue\", \
              \"documentation\":\"<p> The maximum value of the sample set. </p>\" \
            } \
          }, \
          \"documentation\":\"<p> The <code>StatisticSet</code> data type describes the <code>StatisticValues</code> component of <a>MetricDatum</a>, and represents a set of statistics that describes a specific metric. </p>\" \
        }, \
        \"Statistics\":{ \
          \"type\":\"list\", \
          \"member\":{\"shape\":\"Statistic\"}, \
          \"min\":1, \
          \"max\":5 \
        }, \
        \"Threshold\":{\"type\":\"double\"}, \
        \"Timestamp\":{\"type\":\"timestamp\"} \
      } \
    } \
     \
    ";
}

@end
