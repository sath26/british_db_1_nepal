--send issue when unresolved i.e. while separating error data
--send issue when resolved i.e. while cleaning error data
--from stg_table
create table PRO_issues(
    issue_id number not null,
    row_id number,
    issue varchar(50),
    I_status varchar(50),
    constraint pk_PJ_issue_id primary key(issue_id)
);

create sequence seq_issues_pk
start with 1
increment by 1;