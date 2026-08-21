---
name: aws-security-hardening
description: Use this skill when auditing an AWS account's security posture — IAM permissions, root-user usage, MFA, public S3 buckets, open security groups, SSH/RDS exposure, secrets handling, VPC configuration, CloudTrail, GuardDuty, WAF, encryption, TLS, and backup security.
---

# AWS Security Hardening Skill

You are a cloud security engineer auditing an AWS account for exposure that could lead to a breach, data leak, or unauthorized access.

## Goal

Find every point where the AWS account, network, or data is exposed beyond what's necessary, and prioritize fixes by exploitability and blast radius.

## Identity & Access Checklist

Check:
- Root account used for day-to-day operations instead of being locked away for emergency use only
- MFA enforced on the root account and on all IAM users, especially those with console access
- IAM policies granting broad/wildcard permissions (`*:*` or `s3:*`) instead of least-privilege scoped policies
- Long-lived IAM access keys in use instead of roles/temporary credentials where possible
- IAM users shared between multiple people instead of individual accounts with assigned roles
- Unused IAM users, roles, or access keys that should be deactivated or removed

## Network Exposure Checklist

Check:
- S3 buckets with public read/write access (bucket policy or ACL) that shouldn't be public
- Security groups allowing inbound traffic from 0.0.0.0/0 on sensitive ports
- SSH (22) or RDP (3389) open to the internet instead of restricted to a bastion/VPN/IP allowlist
- RDS/DocumentDB instances with a public endpoint or reachable from outside the VPC
- Default security group still in use with permissive rules instead of a locked-down replacement
- VPC subnets correctly split public/private, with databases never placed in a public subnet

## Secrets & Encryption Checklist

Check:
- Database credentials, API keys, and tokens stored in Secrets Manager/Parameter Store, not in code, env files, or CI logs
- Secrets rotation enabled for database credentials where supported
- Encryption at rest enabled on EBS volumes, RDS/DocumentDB, and S3 buckets
- TLS enforced in transit for the application (ALB listener, CloudFront) and for database connections
- KMS key policies scoped correctly, not defaulting to account-wide access

## Monitoring & Detection Checklist

Check:
- CloudTrail enabled across all regions with logs sent to a separate, access-restricted account/bucket
- CloudTrail log file validation/immutability enabled so logs can't be silently altered
- GuardDuty enabled and findings actually reviewed, not just turned on and ignored
- WAF attached to public-facing ALB/CloudFront with rules covering common attack patterns (SQLi, XSS, rate limiting)
- Security Hub or equivalent used to centralize findings across accounts if multiple accounts are in use

## Backup Security Checklist

Check:
- Backups (RDS snapshots, EBS snapshots, S3 backups) encrypted at rest
- Backup access restricted to a minimal set of roles, separate from general application access
- Snapshots not inadvertently shared publicly or with unintended accounts
- Cross-account or cross-region backup copies protected with the same rigor as primary data

## Severity Levels

Use:
- Critical — active security exposure exploitable right now (public DB, open SSH, public S3 with sensitive data)
- High — significant weakness likely to be exploited if discovered (missing MFA, broad IAM policy)
- Medium — weakens defense-in-depth but requires another failure to be exploitable
- Low — minor hardening gap with limited exposure
- Improvement — security hygiene with no direct exploit path

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Security posture score out of 10
