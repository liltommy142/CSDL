# Topic 9 Integrity Constraints and Trigger - Design

## Goal

Create one submission-ready SQL Server script for all exercises in Topic 9:

- Three domain constraints implemented with `CHECK` and `RULE`.
- Nineteen integrity constraints implemented with triggers.

The script must target the existing `QLDT` schema, follow the formatting style of the earlier lab files, and contain no subquery in a `SELECT` list or a `FROM` clause.

## Output

The submission file will be `LABS/LAB7-TOPIC9/19127616.sql` and will contain only the requested solution, not test data or a database rebuild script. This path already exists in the workspace and matches the user's lab numbering.

The file will use this structure:

1. Student and lab header.
2. `USE QLDT` and batch separators.
3. Schema compatibility addition for `NGUOITHAN.QUANHE`.
4. Domain constraints IC1-IC3.
5. Trigger constraints IC1-IC19 in assignment order.

## SQL Design

- Each integrity constraint will have clearly labelled SQL so it can be matched directly to the assignment.
- Separate triggers will be placed on every table whose `INSERT`, `UPDATE`, or `DELETE` operation can invalidate a cross-table constraint.
- Trigger checks will be set-based and correct for statements affecting multiple rows.
- `inserted` and `deleted` will be used to limit checks to affected entities when practical.
- Ordinary joins are allowed. Necessary subqueries may appear only in predicates such as `EXISTS` and `NOT EXISTS`, never in a `SELECT` list or `FROM` clause.
- Violations will use `THROW` with distinct error numbers and Vietnamese error messages. The failed statement will be rolled back by SQL Server.
- Trigger definitions will use `CREATE OR ALTER TRIGGER` so the submission can be rerun during development and grading without manually dropping triggers.
- The script will add `NGUOITHAN.QUANHE nvarchar(10)` only when the column does not already exist. The addition is required because the supplied physical QLDT schema omits the relationship attribute needed by trigger IC10-IC12, while the ER requirements explicitly describe that attribute.

## Constraint Interpretation

- Gender accepts only `Nam` or `Nữ`.
- Salary must be evenly divisible by ten.
- Teacher age is evaluated at execution time and must be from 18 through 60 inclusive.
- Project-title uniqueness applies to non-null titles; duplicate non-null titles are rejected.
- “Born before 1975” means date of birth is earlier than `1975-01-01`.
- “Oldest” means no teacher in the same department has an earlier birth date; ties for the oldest date are allowed.
- A spouse is a `NGUOITHAN` row whose new `QUANHE` value is `Vợ` or `Chồng`.
- “Daughter” and “son” are `NGUOITHAN` rows whose new `QUANHE` value is `Con gái` or `Con trai`.
- Principal investigator means `DETAI.GVCNDT`.
- Academic supervisor means `GIAOVIEN.GVQLCM`.

## Minimum-Cardinality Rules

Rules requiring at least one related row or at least four teachers are checked after relevant changes to existing data. As `AFTER` triggers validate the state at the end of each statement, creating a new parent row with no required children in a separate later statement is rejected. The solution will not disable constraints or introduce deferred-validation tables.

## Verification

Testing will use a disposable QLDT database or transaction-controlled fixture, never modify the submission file with test cases. Verification will cover:

- Clean execution of the complete submission script.
- At least one accepted and one rejected case per rule.
- Multi-row inserts or updates for rules where statement-level trigger correctness matters.
- Rerunning the script to confirm idempotent trigger creation.
- Static scan confirming no subquery appears in a `SELECT` list or `FROM` clause.

If a local SQL Server engine is unavailable, the implementation will not be claimed as runtime-tested; the exact limitation and completed static checks will be reported.
