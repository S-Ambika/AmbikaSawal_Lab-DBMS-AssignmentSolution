create database ecommerce;
use ecommerce;
/*
1. creating tables
*/
create table if not exists supplier(SUPP_ID int auto_increment primary key,SUPP_NAME varchar (50),SUPP_CITY varchar(50),SUPP_PHONE bigint);
create table if not exists customer(CUS_ID int auto_increment primary key,CUS_NAME varchar (50),CUS_PHONE bigint,CUS_CITY varchar(50),CUS_GENDER varchar(20));
create table if not exists Category(CAT_ID int auto_increment primary key,CAT_NAME varchar (50));
create table if not exists product(PRO_ID int auto_increment primary key,PRO_NAME varchar (50),PRO_DESC varchar (50),CAT_ID int,
                                  foreign key (CAT_ID) references category(CAT_ID));
create table if not exists productDetails(PROD_ID int auto_increment primary key,PRO_ID int,SUPP_ID int,PRICE float,
                                  foreign key (PRO_ID) references product(PRO_ID),foreign key (SUPP_ID) references supplier(SUPP_ID));
create table if not exists orders(ORD_ID int primary key,ORD_AMOUNT float,ORD_DATE date, CUS_ID int,PROD_ID int,
                                  foreign key (CUS_ID) references customer(CUS_ID),foreign key (PROD_ID) references productDetails(PROD_ID));
create table if not exists rating(RAT_ID int auto_increment primary key,CUS_ID int,SUPP_ID int,RAT_RATSTARS float,
                                  foreign key (CUS_ID) references customer(CUS_ID),foreign key (SUPP_ID) references supplier(SUPP_ID));
/*
2. inserting values inside tables
*/							
insert into supplier values(1,'Rajesh Retails','Delhi',1234567890),(2,'Appario Ltd' ,'Mumbai' ,2589631470),(3,'Knome Products', 'Banglore', 9785462315),(4,'Bansal Retails', 'Kochi', 8975463285),
							(5,'Mittal Ltd. ','Lucknow' ,7898456532);
insert into customer values(1,'AAKASH' ,9999999999, 'DELHI' ,'M'),(2,'AMAN' ,9785463215 ,'NOIDA' ,'M'),(3,'NEHA' ,9999999999 ,'MUMBAI' ,'F'),(4,'MEGHA' ,9994562399 ,'KOLKATA','F'),
						   (5,'PULKIT' ,7895999999, 'LUCKNOW' ,'M');
insert into Category values(1,'BOOKS'),(2,'GAMES'),(3,'GROCERIES'),(4,'ELECTRONICS'),(5,'CLOTHES');
insert into product values(1,'GTA V', 'DFJDJFDJFDJFDJFJF' ,2),(2,'TSHIRT', 'DFDFJDFJDKFD' ,5),(3,'ROG LAPTOP' ,'DFNTTNTNTERND' ,4),(4,'OATS', 'REURENTBTOTH ',3),
                          (5,'HARRY POTTER' ,'NBEMCTHTJTH' ,1);
insert into productDetails values(1,1 ,2 ,1500),(2,3 ,5, 30000),(3,5 ,1 ,3000),(4,2 ,3 ,2500),(5,4, 1, 1000);
insert into orders values(20,1500, '2021-10-12', 3 ,5),(25,30500, '2021-09-16' ,5 ,2),(26,2000, '2021-10-05', 1 ,1),(30,3500 ,'2021-08-16' ,4 ,3),
						 (50,2000 ,'2021-10-06' ,2 ,1);
insert into rating values(1,2 ,2 ,4),(2,3,4,3),(3,5,1,5),(4,1,3,2),(5,4,5,4);

/*
3. Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
*/
SELECT 
    c.cus_gender,COUNT(c.cus_gender)
FROM
    customer AS c,
    orders AS o
WHERE
    o.ord_amount >= 3000
        AND c.cus_id = o.cus_id
GROUP BY c.cus_gender;

/*
4. Display all the orders along with the product name ordered by a customer having Customer_Id=2
*/
SELECT 
    o.ord_id, o.ord_amount, o.ord_date, o.prod_id, p.pro_name
FROM
    orders AS o,
    product AS p
WHERE
    o.cus_id = 2
GROUP BY o.cus_id;

/*
5.Display the Supplier details who can supply more than one product.
*/
SELECT 
    s.supp_id, s.supp_name, s.supp_city, s.supp_phone
FROM
    supplier AS s,
    productdetails AS pd
WHERE
    pd.supp_id = s.supp_id
HAVING COUNT(pd.supp_id) > 1;

/*
 6.Find the category of the product whose order amount is minimum.
*/
/*solved by me by not so good way*/
SELECT ca.cat_name FROM category ca WHERE
    ca.cat_id = (SELECT 
            p.cat_id
        FROM
            product p,
            productdetails pd
        WHERE
            p.pro_id = (SELECT 
                    pd.pro_id
                FROM
                    productdetails AS pd
                WHERE
                    pd.prod_id = (SELECT 
                            o.prod_id
                        FROM
                            orders o
                        WHERE
                            o.ord_amount = (SELECT 
                                    MIN(o.ord_amount)
                                FROM
                                    orders o)))
        GROUP BY p.cat_id)
GROUP BY ca.cat_id;


/*modified after mentor's suggestion*/

SELECT 
    c.cat_name
FROM
    orders AS o
        JOIN
    productdetails AS pd ON pd.prod_id = o.prod_id
        JOIN
    product p ON p.pro_id = pd.pro_id
        JOIN
    category c ON c.cat_id = p.cat_id
HAVING MIN(o.ord_amount);


/*
 7.Display the Id and Name of the Product ordered after “2021-10-05”.
*/
SELECT 
    p.pro_id, p.pro_name
FROM
    product AS p
        JOIN
    productdetails AS pd ON p.pro_id = pd.pro_id
        JOIN
    orders AS o ON pd.prod_id = o.prod_id
        AND o.ord_date > '2021-10-05'
GROUP BY p.pro_id;


/*
 8.Print the top 3 supplier name and id and their rating on the basis of their rating along with the customer name who has given the rating.
*/
SELECT 
    s.supp_id, s.supp_name, c.cus_name, r.rat_ratstars
FROM
    rating as r
        JOIN
    supplier as s ON r.supp_id = s.supp_id
        JOIN
    customer as c ON r.cus_id = c.cus_id
ORDER BY r.rat_ratstars DESC
LIMIT 3;


/*
9. Display customer name and gender whose names start or end with character 'A'.
*/
SELECT 
    c.cus_name, c.cus_gender
FROM
    customer c
WHERE
    c.cus_name LIKE '%A'
        OR c.cus_name LIKE 'A%';


/*
10. Display the total order amount of the male customers.
*/
SELECT 
    SUM(o.ord_amount)
FROM
    orders o,
    customer c
WHERE
    c.cus_id = o.cus_id
        AND c.cus_gender = 'M';
        
/*
11.Display all the Customers left outer join with the orders.
*/
SELECT 
    *
FROM
    customer
        LEFT JOIN
    orders ON orders.cus_id = customer.cus_id;

/*
12. Create a stored procedure to display the Rating for a Supplier if any along with the
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average
Supplier” else “Supplier should not be considered”
*/
call gettingRatingForSuppliers();

