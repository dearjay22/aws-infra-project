#!/usr/bin/env python3
import aws_cdk as cdk
from cdk.InfraStack import InfraStack

app = cdk.App()

InfraStack(app, "prog8870-infra")

app.synth()
