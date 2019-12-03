create table if not exists fbird.goods
(
  G_ID int default 0 not null
    primary key,
  G_NAME varchar(20) not null,
  G_DESCRIBE varchar(40) null,
  G_PRICE double(18,2) null,
  G_MADE varchar(20) null,
  G_AMOUNT int(10) null,
  G_CREATE_DATE timestamp null,
  G_PIC varchar(11) null
);