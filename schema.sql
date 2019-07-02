DROP TABLE IF EXISTS inv;
DROP TABLE IF EXISTS upc;

CREATE TABLE inv (
  name varchar(100) NOT NULL,
  size varchar(10) NOT NULL,
  sku integer NOT NULL,
  invprice decimal NOT NULL
);

CREATE TABLE upc (
  upc varchar(50) NOT NULL,
  sku integer NOT NULL
);
