create table if not exists list
(
    id         int(11) unsigned auto_increment primary key,
    date       date                         null,
    target     varchar(100) charset utf8mb4 null,
    start_time time                         null,
    end_time   time                         null,
    status     varchar(20)                  null
);
