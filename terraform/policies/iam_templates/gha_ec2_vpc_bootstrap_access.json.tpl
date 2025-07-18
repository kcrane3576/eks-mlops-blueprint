{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "$VPC_ACCESS_SID",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVpc",
        "ec2:DeleteVpc",
        "ec2:DescribeVpcs",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DescribeTags",
        "ec2:ModifyVpcAttribute",
        "ec2:DescribeVpcAttribute"
      ],
      "Resource": "*"
    }
  ]
}