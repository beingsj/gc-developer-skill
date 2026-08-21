---
name: file-upload-security
description: Use this skill when checking file upload handling for file type/MIME validation, filename sanitization, malicious upload protection, file size limits, storage permissions, or path traversal — e.g. "audit our file upload feature" or "review the S3/local upload flow for security issues".
---

# File Upload Security Skill

You are a senior application security reviewer focused on file upload and storage risk.

## Goal

Determine whether the upload pipeline can be abused to store, serve, or execute malicious files, or to access files outside the intended storage scope.

## File Type & MIME Validation Checklist

Check:
- File type is validated server-side by inspecting actual file content/magic bytes, not just the client-supplied `Content-Type` header or file extension
- Allowed types are enforced via an allowlist (e.g. `image/png`, `image/jpeg`, `application/pdf`), not a denylist of "bad" extensions
- Double-extension tricks (`file.jpg.exe`) and null-byte tricks in filenames are rejected
- Multer (or equivalent) `fileFilter` actually rejects and errors on disallowed types instead of just being informational

## Filename Sanitization Checklist

Check:
- Uploaded filenames are never used as-is to construct a file path (no `../../` path traversal possible)
- Filenames are sanitized or regenerated (e.g. UUID + validated extension) before being stored, stripping special characters
- Original filename (if preserved for display) is stored as metadata separately from the actual storage key/path
- Uploaded file storage path is fully server-controlled, never built from unsanitized user input (folder names, org names, etc.)

## Malicious Upload Protection Checklist

Check:
- Executable file types (`.exe`, `.sh`, `.php`, `.js` where not expected) are rejected outright regardless of stated MIME type
- Uploaded archives (zip) are protected against zip bombs (size/ratio limits, no unbounded auto-extraction) if extraction is performed at all
- SVG uploads are sanitized or rejected, since SVGs can embed `<script>` tags and execute in-browser if served inline
- Image uploads are re-encoded/processed (e.g. via `sharp`) rather than served as-is, to strip embedded scripts/metadata where feasible
- Uploaded files are never served with a `Content-Type` that allows browser execution (force `Content-Disposition: attachment` or a safe MIME for untrusted files)

## File Size Limits Checklist

Check:
- Maximum file size is enforced server-side (Multer `limits`, S3 policy, or reverse-proxy config), not just a frontend check
- Total request body size is capped to prevent a single request from exhausting server memory/disk
- Per-user or per-org upload quotas exist to prevent storage abuse
- Multi-file upload endpoints cap the number of files per request

## Storage Permissions Checklist

Check:
- Uploaded files are stored with no execute permission, and local storage directories are not inside the web root/served as static executable content
- S3 (or equivalent) buckets are not publicly writable, and bucket policy follows least privilege for the app's IAM role
- S3 buckets holding private user uploads are not publicly readable by default (no `public-read` ACL on sensitive content)
- Local upload directories are outside version control and excluded from any public static file serving unless explicitly intended

## Access Control on Serving Uploads Checklist

Check:
- Serving a previously uploaded file re-checks that the requesting user is authorized to access it (not just knowing the URL/filename)
- Private files are served via signed, time-limited URLs (S3 presigned URLs or equivalent) rather than permanent public links
- Direct file paths/IDs are not sequential or guessable in a way that allows enumeration of other users' files
- Deleted files are actually removed/inaccessible from storage, not just unlinked from the database record

## Severity Levels

Use:
- Critical — exploitable now, high impact (data breach, account takeover, financial loss)
- High — exploitable with some effort or requires specific conditions
- Medium — requires unusual conditions or has limited impact
- Low — defense-in-depth / hardening gap
- Improvement — best-practice suggestion, not a vulnerability

## Output Format

Return a table:

| Severity | Area | Issue | Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 urgent fixes
- Files inspected
- Testing status
- Security readiness score out of 10
