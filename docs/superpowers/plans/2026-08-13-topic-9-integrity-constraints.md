# Topic 9 Integrity Constraints Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce and runtime-test one submission-ready SQL Server script containing all three domain constraints and all nineteen trigger constraints from Topic 9.

**Architecture:** Keep the submitted solution in the existing single lab file and organize it in assignment order. Add the missing `NGUOITHAN.QUANHE` column idempotently, use set-based `AFTER` triggers on every relation that can invalidate a rule, and validate the result against a disposable SQL Server database built from the repository's Topic 2 schema.

**Tech Stack:** Microsoft SQL Server T-SQL, Docker SQL Server container, `sqlcmd`, shell-based static checks.

## Global Constraints

- Submission file: `LABS/LAB7-TOPIC9/19127616.sql`.
- Do not put a subquery in a `SELECT` list or a `FROM` clause.
- Follow the header, indentation, comments, and `GO` batch style of existing lab files.
- Keep tests and fixture changes outside the submitted SQL file.
- Treat triggers as statement-level and support multi-row changes.
- Add `NGUOITHAN.QUANHE nvarchar(10)` only when it does not exist.
- Use `Vợ`, `Chồng`, `Con gái`, and `Con trai` as relationship values.
- Do not modify the user-owned Topic 2 schema file.

---

### Task 1: Build the Submission Skeleton and Domain Constraints

**Files:**
- Modify: `LABS/LAB7-TOPIC9/19127616.sql`
- Reference: `LABS/LAB2-TOPIC2/19127616.sql`

**Interfaces:**
- Consumes: Existing QLDT tables and column names from Topic 2.
- Produces: A rerunnable Topic 9 script with `QUANHE`, `CK_GIAOVIEN_PHAI`, `rule_LUONG_BOI_10`, and `CK_GIAOVIEN_TUOI` available to later trigger tasks.

- [ ] **Step 1: Create a disposable baseline test script**

Copy `LABS/LAB2-TOPIC2/19127616.sql` to a file under `tmp/topic9-tests/`, replacing only the database name `QLDT` with `QLDT_TOPIC9_TEST`. Do not edit the repository source fixture.

- [ ] **Step 2: Write the submission header and schema compatibility block**

Start the submission with the existing student header style, `USE QLDT`, and an idempotent metadata check:

```sql
if col_length('dbo.NGUOITHAN', 'QUANHE') is null
    alter table NGUOITHAN add QUANHE nvarchar(10)
go
```

- [ ] **Step 3: Implement the three domain constraints**

Implement gender with a named `CHECK`, salary with `CREATE RULE` plus `sp_bindrule`, and age with a named `CHECK`. Drop or unbind only the same named objects when rerunning. Use the inclusive age condition based on `DATEADD(year, -60, CAST(GETDATE() AS date))` and `DATEADD(year, -18, CAST(GETDATE() AS date))` so birthday boundaries are accurate.

- [ ] **Step 4: Run the baseline and submission in SQL Server**

Run the disposable database script, replace `USE QLDT` with `USE QLDT_TOPIC9_TEST` in a temporary copy of the submission, execute it with `sqlcmd -b`, and require exit code 0.

- [ ] **Step 5: Test the domain boundaries**

Inside a transaction, verify `Nam`, `Nữ`, a salary divisible by ten, and dates exactly 18 and 60 years ago are accepted. Verify another gender, a salary not divisible by ten, a teacher younger than 18, and a teacher older than 60 are rejected; roll back the transaction.

- [ ] **Step 6: Commit the domain-constraint slice**

```bash
git add LABS/LAB7-TOPIC9/19127616.sql
git commit -m "feat: add Topic 9 domain constraints"
```

### Task 2: Implement Trigger IC1-IC9

**Files:**
- Modify: `LABS/LAB7-TOPIC9/19127616.sql`

**Interfaces:**
- Consumes: `GIAOVIEN`, `GV_DT`, `BOMON`, and `DETAI` from QLDT.
- Produces: Named, set-based triggers enforcing IC1-IC9.

- [ ] **Step 1: Add direct uniqueness and head-of-department checks**

Add `CREATE OR ALTER TRIGGER` definitions for:

- IC1 on `DETAI` after insert/update, rejecting two non-null equal `TENDT` values using a self-join and unequal `MADT`.
- IC2 on `BOMON` after insert/update and on `GIAOVIEN` after update, rejecting a non-null `TRUONGBM` whose `NGSINH >= '19750101'`.
- IC3 on `GIAOVIEN` after insert/update/delete, rejecting any affected non-null department with no female teacher.

- [ ] **Step 2: Add phone cardinality checks**

Add IC4 triggers on `GIAOVIEN` insert and `GV_DT` delete/update to require at least one phone for an affected teacher. Add IC5 on `GV_DT` insert/update, grouping by `MAGV` and rejecting `COUNT(*) > 3`.

- [ ] **Step 3: Add department membership and leadership checks**

Add IC6 on `GIAOVIEN` insert/update/delete to reject affected departments with fewer than four teachers. Add IC7 on both `BOMON` and `GIAOVIEN`, rejecting a head for whom another teacher in the same department has an earlier `NGSINH`.

- [ ] **Step 4: Add supervisor compatibility checks**

Add IC8 on both `BOMON` and `GIAOVIEN`, rejecting any `TRUONGBM` also referenced by another row's `GVQLCM`. Add IC9 on `GIAOVIEN` insert/update, rejecting a teacher and non-null academic supervisor whose `MABM` values differ.

- [ ] **Step 5: Execute focused accepted/rejected and multi-row tests**

For each IC1-IC9, run one transaction that preserves the rule and one that violates it. Include a two-row duplicate-title insert, a multi-row department move, and a multi-row phone insert to prove statement-level handling. Require the expected `THROW` number for rejected cases.

- [ ] **Step 6: Commit IC1-IC9**

```bash
git add LABS/LAB7-TOPIC9/19127616.sql
git commit -m "feat: enforce Topic 9 trigger constraints IC1 to IC9"
```

### Task 3: Implement Trigger IC10-IC19

**Files:**
- Modify: `LABS/LAB7-TOPIC9/19127616.sql`

**Interfaces:**
- Consumes: `NGUOITHAN.QUANHE` from Task 1 and all QLDT project/supervision relations.
- Produces: Named, set-based triggers enforcing IC10-IC19.

- [ ] **Step 1: Add family constraints IC10-IC12**

On `NGUOITHAN`, implement IC10 by counting `QUANHE IN (N'Vợ', N'Chồng')` per teacher and rejecting counts above one. Implement IC11 by joining the relative to `GIAOVIEN` and rejecting equal `PHAI` for spouse rows. Implement IC12 by rejecting `Con gái` or `Con trai` rows whose `NGSINH` is not later than the teacher's `NGSINH`. Add a companion `GIAOVIEN` update trigger for IC11-IC12 when teacher gender or birth date changes.

- [ ] **Step 2: Add project ownership and task constraints IC13-IC14**

Implement IC13 on `DETAI` insert/update by grouping non-null `GVCNDT` and rejecting counts above three. Implement IC14 on `DETAI` insert and `CONGVIEC` delete/update, rejecting affected projects with no task.

- [ ] **Step 3: Add salary hierarchy constraints IC15-IC16**

Implement IC15 on `GIAOVIEN` insert/update, rejecting a teacher whose salary is not lower than the academic supervisor's salary. Implement IC16 on both `BOMON` and `GIAOVIEN`, rejecting a department whose head salary is not strictly greater than every other teacher's salary.

- [ ] **Step 4: Add final leadership and participation constraints IC17-IC19**

Implement IC17 on `BOMON` insert/update to require a non-null `TRUONGBM` referencing an existing teacher. Implement IC18 on `GIAOVIEN` insert/update by grouping `GVQLCM` and rejecting counts above three. Implement IC19 on `THAMGIADT` insert/update, `DETAI` update, and `GIAOVIEN` update, rejecting participation where participant and principal investigator departments differ.

- [ ] **Step 5: Execute focused accepted/rejected and multi-row tests**

For each IC10-IC19, run one accepted and one rejected transaction. Include two spouse rows in one insert, four projects for one principal investigator, deleting all tasks from a project, four supervised teachers, and a multi-row participation insert across departments.

- [ ] **Step 6: Commit IC10-IC19**

```bash
git add LABS/LAB7-TOPIC9/19127616.sql
git commit -m "feat: enforce Topic 9 trigger constraints IC10 to IC19"
```

### Task 4: Full Runtime and Static Verification

**Files:**
- Verify: `LABS/LAB7-TOPIC9/19127616.sql`
- Temporary test artifacts: `tmp/topic9-tests/`

**Interfaces:**
- Consumes: Complete submission script from Tasks 1-3.
- Produces: Reproducible evidence that the one submitted file loads, reruns, and enforces all rules.

- [ ] **Step 1: Rebuild the disposable database from scratch**

Drop and recreate only `QLDT_TOPIC9_TEST`, run the adapted Topic 2 fixture with `sqlcmd -b`, then execute the adapted Topic 9 script.

- [ ] **Step 2: Run the complete test suite**

Execute all accepted, rejected, boundary, and multi-row cases in a single test runner. Fail the runner if an expected rejection succeeds, an expected acceptance fails, or the received error number differs.

- [ ] **Step 3: Rerun the submission script**

Execute the adapted Topic 9 script a second time against the same database and require exit code 0, confirming idempotent column, constraint, rule, binding, and trigger setup.

- [ ] **Step 4: Run static submission checks**

Check `git diff --check`, confirm the file contains exactly three domain IC labels and nineteen trigger IC labels, and inspect every parenthesized query to confirm it occurs only under `WHERE`, `EXISTS`, or `NOT EXISTS`, never as a projected expression or derived table.

- [ ] **Step 5: Inspect the final diff and repository status**

Confirm only the approved spec/plan and `LABS/LAB7-TOPIC9/19127616.sql` are authored changes. Preserve the user's untracked Topic 9 PDF and any unrelated files.

- [ ] **Step 6: Commit verification refinements if needed**

If verification required SQL changes, commit only the submission file:

```bash
git add LABS/LAB7-TOPIC9/19127616.sql
git commit -m "test: harden Topic 9 trigger solution"
```
