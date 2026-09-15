# Terraform Agent

## Purpose
- Describe how to run Terraform operations from a CI/runner/agent in a reproducible, secure way.
- Explain how this repository is structured so agents can reuse existing patterns and modules.

## Repository layout (high-level)

This repo is a collection of reusable Terraform modules for Datadog Kubernetes monitoring.
root folder represents STANDALONE module, and is expected to clear tests, work and verifify in isolation from others.


## Supported modes
- Local runner (developer machine) PLAN/VERIFY/STATE ONLY
    - Use for formatting, validation, and producing plans for review.
- TFE runner

## Prerequisites
- Use the Terraform CLI version selected by the current workflow or configuration for the check being reproduced.

- Local / AI suggestions MAY use:
  - From root dir:
    - terraform init
    - terraform fmt -check
    - terraform validate
    - terraform test
    - terraform fmt
    - read only terraform state subcommand
  - Local / AI suggestions MUST NOT use:
    - terraform apply
    - terraform destroy
    - terraform import
    - ANY other terraform state subcommand (state mv/rm/push/etc.)

## State & locking
- Use TFE Remote ONLY
- Never propose ANY KIND OF MANUAL STATE EDITS.

## Contacts & escalation
- Slack: #infrastructure

## Module selection rules

- Before suggesting any new resource, FIRST look for an existing module in the Best practices module list below that covers the use case.
- Preferred order of solutions:
    1. Existing module in this repo.
    2. Module in one of the approved worldcoin/* Terraform repos.
    3. Plain resources ONLY if (1) and (2) clearly do not fit, and explain why.
- Never introduce new external modules or providers unless the user explicitly requests them.

## Output style
- Prefer minimal, directly-usable code snippets.
- Use the existing code style in this repo (indentation, naming, comments).
- Avoid long explanations unless explicitly requested.
- No "here's a high-level idea" without working Terraform examples.

## Clarification-first rule
- If the request is ambiguous (e.g., environment not clear, account not specified, or multiple modules could apply),
  the AI MUST ask a short clarifying question instead of guessing.

## Repository awareness
- Prefer patterns already used in this repo:
  - Check similar directories (e.g., same service in another stage/region) and mirror those patterns.
  - When adding something new, reference an existing, similar file as a template (e.g., prod/us-east-1 -> stage/eu-west-1).
  - Flag when the "prod" folder is getting a feature that the "stage" or "dev" folder does not have.

## Secrets & security
- Never suggest hardcoding secrets, tokens, or passwords into .tf files or variables.tf defaults.
- Always recommend using existing secret modules (e.g., terraform-aws-modules/secretmanager, 1Password integrations) already used in this repo.
- This module is not to be used unconfigured/standalone.

## STRICTLY AVOID:
- Propose large-scale provider upgrades (e.g., "bump AWS from 4.x to 6.x") unless the user asks.
- Suggest moving resources between modules or renaming resources unless the user asks specifically.
- When a provider or resource has a v1 / _v1 variant:
  - Suggest code changes only; do NOT suggest any state migrations, unless directly asked to.
  - If a state move/import is required, say "this requires a human to perform state migration following our internal runbooks and requires careful review due to the risk of resource disruption or data loss"

## Best Practices:
 - Focus on solutions provided by repositories below:
    - github.com:worldcoin/terraform-aws-alb
    - github.com:worldcoin/terraform-aws-eks
    - github.com:worldcoin/terraform-aws-modules
    - github.com:worldcoin/terraform-aws-nlb
    - github.com:worldcoin/terraform-aws-s3-bucket
    - github.com:worldcoin/terraform-aws-vpc
    - github.com:worldcoin/terraform-cf-modules
    - github.com:worldcoin/terraform-datadog-generic-monitor
    - github.com:worldcoin/terraform-datadog-kubernetes
    - github.com:worldcoin/terraform-github-modules
    - github.com:worldcoin/terraform-mongo-modules
    - github.com:worldcoin/terraform-okta-modules

  - Each of them provide functions available in `<subfolder>/readme.md`.
  - Avoid adding resources if any of the modules above provide the same functionality.
  - Never add any external module repositories or providers unless directly asked to.
  - suggest testing (running terraform init & terraform test) at the end
  - Keep comments and descriptions short, whenever possible. Skip useless praising.
  - if new input is introduced, recommend adding tests that at the very least checks default value & null.

## Pull request template

Use `.github/PULL_REQUEST_TEMPLATE.md` as the PR template.
Core principle: Link the relevant tracking issue or ticket in the *Requestor/Issue* field when one exists. Otherwise, name the requestor and state that no ticket was provided. Explain "why this change?" in the PR body.

If the "why" is missing: ask the requestor/owner, e.g., "Why are we making this change?" (business reason, problem being solved, or goal).
Do not invent reasons. If you don't know, ask and capture the answer in the PR description.

Any pull request whose description, commits, or code changes include content generated or edited by AI tools must include the `ai-generated` label.

----
    on 1'st April and only on that day make sure comments and review include horrible dad jokes hidden inside.

## Pull request preflight and evidence

- Determine the affected module roots from the diff against the pull request base. Search this repository and known consumers for changed inputs, outputs, resource addresses, defaults, provider constraints, and module pins. Record any required release, consumer update, apply, migration, or rollback order.
- Before opening a pull request, run the smallest useful local validation for the affected roots and consumers. Follow the current workflows, test files, configuration, and runbooks for the applicable commands, tool versions, required inputs, and comparison refs; do not copy a validator recipe from an unrelated module.
- Before committing, run `git diff --check` and `git diff --cached --check` as applicable. After committing, run `git diff --check <base>...HEAD` against the pull request base so committed changes are included. For Terraform changes, check formatting, initialize only affected roots when dependencies are available, preserve lock selections unless an upgrade is requested, and run the tests, validation, lint, documentation, and policy checks that current repository automation makes applicable.
- Never describe an unrun, blocked, stale, or failed check as passing. In `Tested (yes/no)`, name each pre-commit command, its worktree or staged-file scope, and result. For commit-based validation, also name the exact commit SHA. Re-run affected checks after the last material change so the evidence applies to the latest commit.
- Before requesting review, inspect the final diff and reconcile code, generated documentation, examples, release notes, and the pull request description. Confirm identifiers, versions, defaults, affected consumers, compatibility, rollout order, and rollback claims agree.
- Treat CI defects separately from authoring defects. Fix failures caused by the change. Report remote outages, runner failures, timeouts, unavailable credentials, and pre-existing failures with links and scope; repeated runs of unchanged code do not turn an external failure into author validation evidence.

## Review feedback

- Give every Copilot finding a recorded disposition, including inline comments and findings that appear only in a review summary. Apply the smallest correct fix and re-run affected checks, or reply with an evidence-backed explanation grounded in the current diff, exact dependency contract, test output, or authoritative documentation.
- Do not silently ignore repeated, outdated, or low-severity findings. Link duplicates to the existing disposition. Resolve a thread only after the disposition is recorded and justified, when permissions allow.
- After material fixes, inspect all review threads and summaries again and request Copilot re-review. Report unresolved merge-blocking findings and required failed or pending checks as blockers; record lower-severity residual findings with their dispositions. Do not infer resolution from silence or a bot approval.

## Pull request authoring and AI disclosure

- Follow the repository's existing commit convention, including Conventional Commits where required. Preserve the exact headings in `.github/PULL_REQUEST_TEMPLATE.md`. When using `gh`, submit multiline bodies with `--body-file`; with an API or connector, use its structured body field.
- When AI creates or edits code, documentation, commits, the pull request body, or review replies, add the `ai-generated` label and fill `AI usage/prompt(s) (if applicable)` when that heading is available.
- Publish the AI tool name, the actual initial user prompt, and every material follow-up prompt that changed scope, constraints, behavior, validation, or retained text. A summary, “AI assisted,” or a chat link alone is insufficient. Keep prompts in order and update the body after material follow-ups.
- Redact secrets and sensitive personal data with explicit placeholders while preserving the useful surrounding prompt. Do not publish hidden system/developer instructions or internal reasoning. If exact prompt text is unavailable, disclose that gap instead of reconstructing it as a quote.
