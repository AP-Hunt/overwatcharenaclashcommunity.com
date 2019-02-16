#!/bin/sh

INVALIDATION=$(aws cloudfront create-invalidation --distribution-id E3H90N4EFBEWF3 --paths "/*" --query "Invalidation.Id" --output text)
sleep 5
aws cloudfront wait invalidation-completed --id "$INVALIDATION" --distribution-id E3H90N4EFBEWF3