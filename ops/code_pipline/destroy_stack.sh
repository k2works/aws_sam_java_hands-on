#!/usr/bin/env bash
STACKNAME=AWS-SAM-Java-Hands-on-pipeline

echo "**********************************"
echo STACKNAME:${STACKNAME}
echo "**********************************"

aws cloudformation delete-stack --stack-name ${STACKNAME}
