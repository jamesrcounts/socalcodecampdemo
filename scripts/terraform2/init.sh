#!/usr/bin/env bash

init() {
  if [ -d .terraform ]; then
    if [ -e .terraform/terraform.tfstate ]; then
      echo "Remote state already exist!"
    fi
  fi


  terraform remote config \
    -backend=s3 \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="key=network/terraform.tfstate" \
    -backend-config="region=${AWS_DEFAULT_REGION}"

}

init