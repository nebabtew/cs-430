# Rebuild from packaged submission

The final ZIP was extracted to a fresh directory. The portable tools/verify_offline_mysql.py audit harness read the four submitted SQL scripts from that extracted folder and executed them in actual MySQL 8.0.46. Both clean builds, all six outputs, T1–T4, fixture cleanup and independent CSV expectations passed. Intentional errors were actual 1452 and 1062. No dependencies, credentials, temporary server databases or source downloads are included in the ZIP. The video remains a separate student deliverable.
