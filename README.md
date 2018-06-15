# Command Utility JIRA

<p align="center">
    <img src="./Images/cujira_logo.png" alt="cujira" />
</p>
<p align="center">
  <a href="https://swift.org/package-manager">
    <img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat" alt="SPM" />
  </a>
  <a href="https://github.com/yonaskolb/Mint">
    <img src="https://img.shields.io/badge/Mint-compatible-brightgreen.svg?style=flat" alt="Mint" />
  </a>
  <a href="https://github.com/abema/cujira/releases">
    <img src="https://img.shields.io/github/release/abema/cujira.svg" alt="Git Version" />
  </a>
  <a href="https://github.com/abema/cujira/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-lightgray.svg" alt="license" />
  </a>
</p>

## Usage

### 1. Register `domain`, `username` and `apikey`.

- domain is `https://[ HERE ].atlassian.net`.
- username is your email that registered Jira.
- apikey can get from [https://id.atlassian.com/manage/api-tokens](https://id.atlassian.com/manage/api-tokens).

Please execute those 3 commands.

```
$ cujira register domain XXX
```

```
$ cujira register username XXX
```

```
$ cujira register apikey XXX
```

In addition, you can check registered information with `cujira register info`.

### 2. Check ProjectID (or BoardID) and Add `Project Alias`.

You can check ProjectID (or BoardID) with `cujira board list` that shown all boards of your Jira domain.

```
$ cujira board list

Results:

	id: 1
	name: cujira Development
	project - id: 10001
	project - name: cujira

	id: 2
	name: cujira Bug Fix
	project - id: 10002
	project - name: cujira (Bug)
```

After checking ProjectID, add Project alias with `cujira alias project add`.

```
$ cujira alias project add cujira-bug --project-id 10002
```

In addition, you can check registered project alias with `cujira alias project list`.

```
$ cujira alias project list

    name: cujira-bug, projectID: 10002, boardID: 2
```

### 3. Get project issues with `today`, `yyyy/mm/dd` or `SPRINT_NAME`.

If you want to get today's issues of project, below command can show them.

```
$ cujira issue list cujira-bug today
JQL: project = 10002 AND created >= startOfDay()

Summary: All command responses are `Great Scott!!`.
URL: https://XXX.atlassian.net/browse/BUG-1985
IssueType: Critical Bug
Status: Open
User: doc-emmett-brown

Summary: Command usages is a little strange.
URL: https://XXX.atlassian.net/browse/BUG-1986
IssueType: Bug
Status: Open
User: --
```

If you want to get issues with `SPRINT_NAME`, check sprints with `cujira sprint list`.

```
$ cujira sprint list cujira-bug

Results:

	id: 5
	name: Sprint 1
	startDate: 2018/06/02
	endDate: 2018/06/07

	id: 8
	name: Sprint 2
	startDate: 2018/06/08
	endDate: --
```

After checking sprint name, you can get issues with `cujira issue list cujira-bug "Sprint 2"`.

### Additional Usage for getting Issues.

`cujira issue list` has some options.

```
Options:

    --issue-type [ISSUE_TYPE]
        ... Filter issues with a issueType.
    --label [ISSUE_LABEL]
        ... Filter issues with a issue label.
    --status [STATUS_NAME]
        ... Filter issues with a issue status.
    --assigned [USER_NAME]
        ... Filter issues with a user who has assigned.
    --aggregate
        ... Show every options issue counts.
    --output-json
        ... Print results as JSON format.
```

You can get aggregation of issues.

```
$ cujira issue list cujira-bug today --issue-type "Critical Bug" --aggregate
JQL: project = 10002 AND created >= startOfDay()

Summary: All command responses are `Great Scott!!`.
URL: https://XXX.atlassian.net/browse/BUG-1985
IssueType: Critical Bug
Status: Open
User: doc-emmett-brown

Number of Issues: 2
Number of Critical Bug: 1
```
