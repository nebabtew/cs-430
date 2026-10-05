# Actual MySQL test log

Engine: 8.0.46-0ubuntu0.24.04.3, InnoDB. Date: October 4, 2026 (America/Chicago).

Execution method: this environment blocks sockets, so MySQL executed the supplied SQL through its offline --initialize-insecure/--init-file mechanism. Every build and SELECT statement ran in the real MySQL engine. Identical SELECT copies exported results using INTO OUTFILE. This export harness is separate from the submitted four normal client scripts. The temporary databases and server binaries are not submission dependencies.

| Check | Expected | Actual | Status |
|---|---|---|---|
| Build 1 | Four scripts create/load/view/query without error | All executed successfully; no engine error | PASS |
| Build 2 in same session | Clean reset, same data, no accumulation | All five ordered table exports and all six query exports byte-identical | PASS |
| FK enforcement | 1 | 1 | PASS |
| T1 counts | >=15/4/2/20/2 | 15 businesses / 4 services / 2 categories / 20 offerings / 18 publisher names | PASS |
| T1 source/parent/required-value checks | All failure counts 0 | All 8 checks 0 | PASS |
| T2 | Invalid business FK rejected | Actual engine error names fk_offering_business; separate error instance | PASS |
| T3 | Duplicate pair rejected | Actual engine error reports Duplicate entry '1-2' for BusinessService.PRIMARY | PASS |
| T4 Q4 | Alpha only | Alpha only | PASS |
| T4 Q5 | A=1, B=NULL | A=1, B=NULL | PASS |
| T4 Q6 | Alpha only | Alpha only | PASS |
| T4 Q3 at 1 | A=2, B=1 | A=2, B=1 | PASS |
| T4 Q3 at 2 | A=2 only | A=2 only | PASS |
| Fixture cleanup | Fixture database absent | Schema count 0 | PASS |
| Real snapshot after T4 | Same T1 counts | Same counts | PASS |

Ordered-table export SHA-256 after both clean builds: 39e10b087618a5de3d4269e4aa011622a1dd3ca055eff46d19ee9aa5d74ecf7e.
Raw engine log, T1 exports, T2/T3 rejection logs, and T4 output accompany this log. Typical normal mysql-client errors are 1452 for T2 and 1062 for T3. These logs are MySQL initialization-engine errors, not fabricated mysql-client screenshots. All query checks in query_checks.md passed against independent CSV expectations.
