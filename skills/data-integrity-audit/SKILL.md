---
name: data-integrity-audit
description: Use this skill when checking whether data stays correct across create/update/delete operations, failed processes, partial transactions, retries, and background jobs — especially for multi-step operations, cron/queue jobs, or anything touching multiple related MongoDB collections.
---

# Data Integrity Audit Skill

You are a QA engineer verifying that the data stays correct even when processes fail halfway through.

## Goal

Determine whether data remains correct and consistent across create/update/delete operations, failures, retries, and background jobs, or whether failure paths leave the database in a broken state.

## Create/Update/Delete Correctness Checklist

Check:
- Deleting a parent record doesn't leave orphaned child references (or cascade/soft-delete is handled deliberately)
- Creating a record that should update related counts/denormalized fields (e.g. `commentCount`, `totalStock`) actually updates them correctly
- Updating a record that other documents reference by ID keeps those references valid (no dangling ObjectId pointing nowhere)
- Soft-delete (`isDeleted`/`deletedAt`) is respected consistently across all queries, not just the main list view
- Cascading effects (e.g. deleting a user deletes/reassigns their content) are complete, not partially implemented in only one code path

## Partial Transaction Handling Checklist

Check:
- Multi-step operations that fail halfway (e.g. create order → charge payment → decrement stock) don't leave a state where one step succeeded and another didn't with no reconciliation
- MongoDB transactions (`session.startTransaction()`) are used for multi-document writes that must succeed or fail together, where the deployment topology supports them (replica set/sharded cluster)
- Where transactions aren't used/available, a compensating action or saga-style rollback exists for the steps that already succeeded
- Partial writes are detectable (a status field, a flag) so a background reconciliation job or manual review can find and fix them
- Errors thrown mid-operation are caught before the operation silently leaves inconsistent sibling documents behind

## Retry Safety Checklist

Check:
- Retried operations (client retry, queue redelivery, manual re-trigger) don't double-apply their effect (double charge, double stock decrement, duplicate record)
- Idempotency keys or natural unique constraints prevent a retried "create" from producing a second document
- Retry logic distinguishes between "safe to retry" errors (network timeout) and "unsafe to retry blindly" errors (ambiguous outcome — did the write happen or not)
- Exponential backoff and a max retry count exist for automated retries, to avoid runaway duplicate attempts
- Retrying a failed multi-step operation resumes from the correct step rather than restarting and repeating already-completed steps

## Background Job Data Effects Checklist

Check:
- A cron/queue job (Bull/BullMQ/agenda/node-cron) that fails partway through a batch doesn't leave some records processed and others silently skipped with no record of which
- Jobs are idempotent — re-running a job for the same input (after a crash/restart) doesn't duplicate its effects
- Failed jobs are logged/moved to a dead-letter queue rather than silently disappearing
- Long-running jobs update progress/state incrementally so a crash mid-job leaves a resumable checkpoint, not an all-or-nothing black box
- Jobs that write to multiple collections keep those writes consistent with each other even if the job process crashes mid-batch

## Referential Integrity Checklist

Check:
- Every `ObjectId` reference between collections points to a document that actually exists (no silent dangling references from deletes elsewhere)
- Population (`.populate()`) failures (missing referenced doc) are handled gracefully in the API response, not left as `null` crashing the frontend
- Foreign-key-style relationships enforced only in application code (not by MongoDB itself) are covered by validation before writes, not just by convention
- Renaming or migrating a referenced field/collection updates all documents that reference it, not just the primary one
- Aggregation pipelines (`$lookup`) that join collections handle missing/mismatched references without silently dropping or duplicating rows

## Severity Levels

Use:
- Critical — breaks core functionality or corrupts data for all/most users
- High — breaks functionality for a common path or subset of users
- Medium — degraded experience, workaround exists
- Low — minor/cosmetic issue
- Improvement — suggestion, not a defect

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority issues
- What was tested / files inspected
- What could not be tested (and why)
- Testing verdict / release recommendation
