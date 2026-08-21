---
name: aws-backup-disaster-recovery
description: Use this skill when reviewing backup and disaster recovery readiness on AWS — automated backups, restore tests, retention policies, database snapshots, S3 versioning, multi-region requirements, RPO, and RTO.
---

# AWS Backup & Disaster Recovery Skill

You are a cloud reliability engineer auditing whether the organization could actually recover its data after a serious failure, not just whether backups exist somewhere.

## Goal

Determine whether backups are automated, tested, retained appropriately, and sufficient to meet the business's actual data-loss and downtime tolerance.

## Backup Automation Checklist

Check:
- RDS/DocumentDB automated backups are enabled and actually running on schedule, not silently failing
- EBS snapshots automated (AWS Backup or DLM lifecycle policy), not dependent on someone remembering to run them manually
- Application-level data (uploaded files, generated reports) backed up, not just the database
- Backup jobs have alerting on failure, so a broken backup job is noticed immediately, not months later

## Restore Testing Checklist

Check:
- A restore has actually been performed from a snapshot/backup within the last few months, not just assumed to work
- Restore was validated against the current schema/application version, not an outdated one
- Time-to-restore has been measured and is known, not estimated
- Restore process is documented so it doesn't depend on one specific person's memory during an incident

## Retention Policy Checklist

Check:
- Backup retention period matches actual business/compliance requirements, not left at AWS defaults
- Backups aren't being deleted too early (risking data loss beyond the recovery window needed)
- Backups aren't being kept indefinitely with no lifecycle policy, incurring needless storage cost
- Retention is consistent across all data stores (database, file storage, config), not backed up piecemeal

## Database Snapshot Strategy Checklist

Check:
- Snapshot frequency matches the acceptable data-loss window (RPO) for the business
- Snapshots are encrypted at rest
- Cross-region snapshot copies exist if a regional outage must be survivable
- Point-in-time recovery is enabled where supported (RDS) for finer-grained recovery than daily snapshots

## S3 Versioning & Object Recovery Checklist

Check:
- Versioning enabled on buckets holding critical or user-generated data
- Accidental deletion/overwrite protection considered (MFA delete or object lock for critical buckets)
- Lifecycle rules manage old versions so versioning doesn't silently balloon storage cost
- Cross-region replication considered for buckets that must survive a regional outage

## RPO/RTO Definition Checklist

Check:
- The business has explicitly defined how much data loss is acceptable (RPO) and how much downtime is acceptable (RTO)
- Current backup frequency and restore time are compared against the defined RPO/RTO to confirm they're actually met
- Different tiers of data (critical vs non-critical) have appropriately different RPO/RTO targets, not one blanket policy
- RPO/RTO targets are revisited as the business and data volume grow

## Multi-Region Considerations Checklist

Check:
- Multi-region backup/DR is evaluated against actual business need, not skipped or over-built without justification
- If required, a documented failover process exists for standing up infrastructure in a second region
- Cross-region data transfer and replication costs are understood and accepted
- DNS/Route 53 failover routing is configured if multi-region DR is in place

## Severity Levels

Use:
- Critical — backups are missing, broken, or unrestorable for critical data right now
- High — backups exist but are untested, under-retained, or wouldn't meet the business's real RPO/RTO
- Medium — backup strategy is functional but has gaps in coverage or process
- Low — minor gap with limited impact on actual recovery capability
- Improvement — DR hygiene (documentation, drills) with no direct data-loss risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Disaster recovery readiness score out of 10
