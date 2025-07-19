{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "$FLOW_LOGS_ACCESS_SID",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}