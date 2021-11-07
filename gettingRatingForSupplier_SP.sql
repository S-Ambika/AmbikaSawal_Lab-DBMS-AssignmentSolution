CREATE DEFINER=`root`@`localhost` PROCEDURE `gettingRatingForSuppliers`()
BEGIN
select s.supp_id,s.supp_name,r.rat_ratstars,
case
when r.rat_ratstars>4 then 'Genuine Supplier'
when r.rat_ratstars>2 then 'Average Supplier'
else 'Supplier should not be considered'
END as verdict 
from rating r
inner join supplier s on s.supp_id=r.supp_id;
END