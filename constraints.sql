alter table ord
  add constraint ord_ordid_pk primary key (ordid);
alter table product
  add constraint product_proid_pk primary key (prodid);
alter table item
  add constraint item_ordid_fk foreign key (ordid) references ord(ordid);
alter table item
  add constraint item_prodid_fk foreign key (prodid) references product(prodid);
alter table customer
  add constraint customer_custid_pk primary key (custid);

alter table customer
  add constraint customer_repid_fk foreign key (repid) references emp(empno);
alter table price
  add constraint price_prodid_fk foreign key (prodid) references product(prodid);
alter table ord
  add constraint ord_custid_fk foreign key (custid) references customer(custid);