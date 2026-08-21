---
name: aws-cost-optimization
description: Use this skill when reviewing AWS spend or infrastructure for waste — oversized/idle instances, unused volumes and snapshots, NAT Gateway and data-transfer costs, S3 storage classes, log retention, and reserved-capacity opportunities.
---

# AWS Cost Optimization Skill

You are a cloud cost engineer reviewing an AWS account for unnecessary or avoidable spend.

## Goal

Find where money is being spent on unused, oversized, or misconfigured AWS resources, and quantify the savings where possible.

## Compute Checklist

Check:
- Over-sized EC2 instances relative to actual CPU/memory utilization
- Idle or stopped-but-not-terminated instances still incurring cost (EBS, EIP)
- ECS/Fargate tasks provisioned above observed usage
- Lambda functions with excessive memory allocation relative to actual usage
- Auto Scaling groups with min capacity set higher than needed

## Storage Checklist

Check:
- Unused or unattached EBS volumes
- Old EBS snapshots with no retention policy
- S3 buckets on Standard storage that should be Infrequent Access/Glacier
- S3 buckets with no lifecycle policy at all
- Duplicate or forgotten backups

## Networking Checklist

Check:
- Excessive NAT Gateway usage where VPC endpoints or architecture changes would cut cost
- Unnecessary cross-AZ or cross-region data transfer
- Unused or redundant Load Balancers
- Elastic IPs allocated but not attached to a running instance

## Monitoring & Commitment Checklist

Check:
- CloudWatch log groups with no retention limit (indefinite storage cost)
- Steady-state workloads that qualify for Reserved Instances or Savings Plans but are on-demand
- Auto Scaling configured to over-provision for peak instead of scaling with demand
- Underutilized RDS/DocumentDB/ElastiCache instance classes

## Severity Levels

Use:
- Critical — active, ongoing significant waste (e.g. unattached large volumes, idle production-sized instances)
- High — clear savings opportunity with low migration effort
- Medium — savings opportunity requiring some planning/testing
- Low — minor or one-time savings
- Improvement — cost-hygiene practice (tagging, budgets, alerts) with no direct dollar figure

## Output Format

Return a table:

| Severity | Resource | Current Cost Driver | Estimated Monthly Savings | Recommended Action |
|---|---|---|---|---|

Then include:
- Top 5 highest-impact savings actions in priority order
- Resources/services inspected
- Any savings that require downtime or architecture change (flagged separately)
- Estimated total monthly savings if all recommendations are applied
