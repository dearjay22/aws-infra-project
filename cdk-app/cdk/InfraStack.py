from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_rds as rds,
    aws_s3 as s3,
)
from constructs import Construct


class InfraStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs):
        super().__init__(scope, construct_id, **kwargs)

        # --------------------------
        # 1. VPC + Subnet
        # --------------------------
        vpc = ec2.Vpc(
            self,
            "Prog8870VPC",
            max_azs=2,
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="public-subnet",
                    subnet_type=ec2.SubnetType.PUBLIC
                )
            ]
        )

        public_subnet = vpc.public_subnets[0]

        # --------------------------
        # 2. Security Group (EC2 + RDS)
        # --------------------------
        sg = ec2.SecurityGroup(
            self,
            "InstanceSG",
            vpc=vpc,
            description="Allow SSH & MySQL",
            allow_all_outbound=True
        )

        sg.add_ingress_rule(
            peer=ec2.Peer.any_ipv4(),
            connection=ec2.Port.tcp(22),
            description="Allow SSH"
        )

        sg.add_ingress_rule(
            peer=ec2.Peer.any_ipv4(),
            connection=ec2.Port.tcp(3306),
            description="Allow MySQL"
        )

        # --------------------------
        # 3. EC2 Instance
        # --------------------------
        ec2_instance = ec2.Instance(
            self,
            "Prog8870EC2",
            instance_type=ec2.InstanceType("t3.micro"),
            machine_image=ec2.MachineImage.generic_linux({
                "us-east-1": "0c02fb55956c7d316"  # your AMI ID
            }),
            vpc=vpc,
            vpc_subnets=ec2.SubnetSelection(subnets=[public_subnet]),
            security_group=sg,
            key_name="my-ec2-keypair"
        )

        # --------------------------
        # 4. RDS MySQL Instance
        # --------------------------
        rds_instance = rds.DatabaseInstance(
            self,
            "Prog8870RDS",
            engine=rds.DatabaseInstanceEngine.MYSQL,
            instance_type=ec2.InstanceType("t3.micro"),
            vpc=vpc,
            vpc_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC),
            credentials=rds.Credentials.from_username(
                "admin",
                password=None  # Auto-generated unless you specify
            ),
            allocated_storage=20,
            publicly_accessible=True,
            security_groups=[sg],
            database_name="prog8870db"
        )

        # --------------------------
        # 5. Three S3 Buckets
        # --------------------------
        bucket1 = s3.Bucket(
            self,
            "BucketOne",
            versioned=True,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL
        )

        bucket2 = s3.Bucket(
            self,
            "BucketTwo",
            versioned=True,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL
        )

        bucket3 = s3.Bucket(
            self,
            "BucketThree",
            versioned=True,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL
        )
