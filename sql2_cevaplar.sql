--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını 
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select product_id,product_name,company_name,phone from products pr
inner join suppliers s on pr.supplier_id = s.supplier_id
where units_in_stock = 0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address,concat(first_name, ' ', last_name) as "Ad Soyad" from orders o
inner join employees e on o.employee_id = e.employee_id
where o.order_date between '1998-03-01' and '1998-03-31'

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) from orders o
where date_part('year',o.order_date) = 1997
and date_part('month',o.order_date) = 2

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*) from orders o
where date_part('year',o.order_date) = 1998
and ship_city = 'London'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name,phone from orders o
inner join customers c on o.customer_id = c.customer_id
where date_part('year',o.order_date) = 1997
group by contact_name,phone

--31. Taşıma ücreti 40 üzeri olan siparişlerim
Select * from orders
where freight>40

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
Select o.ship_city,c.contact_name from orders o
inner join customers c
on o.customer_id = c.customer_id
where freight>=40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
Select order_date, ship_city,concat(upper(first_name), ' ',  upper(last_name)) as Ad_Soyad
from orders o
inner join employees e
on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
Select c.contact_name,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.phone, '-', ''),
             ')', ''),
             '(', ''),
             ' ', ''),
             '.', '')
from orders o
inner join customers c
on o.customer_id = c.customer_id
where date_part('year',o.order_date) = 1997
group by c.contact_name,c.phone

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
Select o.order_date, c.contact_name,e.first_name,e.last_name from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id

--36. Geciken siparişlerim?
Select * from orders
where shipped_date>required_date or shipped_date is null

--37. Geciken siparişlerimin tarihi, müşterisinin adı
Select o.order_date,c.contact_name from orders o
inner join customers c on o.customer_id = c.customer_id
where shipped_date>required_date or shipped_date is null

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select pr.product_name,c.category_name,od.quantity from order_details od
inner join products pr on od.product_id = pr.product_id
inner join categories c on pr.category_id = c.category_id
where od.order_id = 10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select pr.product_name,s.company_name from order_details od
inner join products pr on od.product_id = pr.product_id
inner join suppliers s on pr.supplier_id = s.supplier_id
where od.order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select pr.product_name,sum(od.quantity) from orders o 
inner join order_details od on o.order_id = od.order_id
inner join products pr on od.product_id = pr.product_id
where o.employee_id=3 and date_part('year',o.order_date) = 1997
group by pr.product_name

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, first_name, last_name
from orders
inner join employees e
on orders.employee_id = e.employee_id
where order_id = 
    (select od.order_id
     from order_details od
     inner join orders o
     on o.order_id = od.order_id
     where date_part('year', o.order_date) = 1997
     group by od.order_id
     order by sum(quantity) desc
     limit 1)
	  
--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Çalışan Ad Soyad"
from employees e
where e.employee_id = (
    select o.employee_id
    from orders o
    inner join order_details od on o.order_id = od.order_id
    where date_part('year', o.order_date) = 1997
    group by o.employee_id
    order by sum(od.quantity) desc--azalan sırala
    limit 1
)
--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id = c.category_id
order by p.unit_price desc
limit 1

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id
from orders o
inner join employees e
on o.employee_id = e.employee_id
order by o.order_date

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select od.order_id,
    avg((pr.unit_price * od.quantity) - (pr.unit_price * od.quantity) * od.discount) as TotalPrice
    from order_details od
    inner join products pr 
	on od.product_id = pr.product_id
    group by od.order_id
    order by od.order_id desc
    limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

select p.product_name, c.category_name, sum(od.quantity) as ToplamSatisMiktari
 from orders o
 inner join order_details od
 on o.order_id = od.order_id
 inner join products p
 on p.product_id = od.product_id
 inner join categories c
 on c.category_id = p.category_id
 where date_part('month', o.order_date) = 1
 group by p.product_name, c.category_name
 
--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
--kontrol et **************
select *
from orders
where order_id in(select o.order_id
                    from orders o
                    inner join order_details od
                    on o.order_id = od.order_id
                    group by o.order_id
                    having sum(od.quantity) > (select (sum(total_quantity_by_order) / count(*)) as average
                                                from  (select o.order_id, sum(od.quantity) as total_quantity_by_order
                                                        from orders o
                                                        inner join order_details od
                                                        on o.order_id = od.order_id
                                                        group by o.order_id)))
														
--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join categories c on c.category_id = p.category_id
order by p.units_on_order desc
limit 1

--49. Kaç ülkeden müşterim var
select count(distinct country) from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum((od.unit_price * od.quantity * (1 - od.discount)) ) as TotalPrice 
from employees as e
inner join orders as o
on o.employee_id = e.employee_id
inner join order_details as od
on od.order_id = o.order_id
where e.employee_id = 3
and o.order_date <= now()
and o.order_date >= (select order_date
                        from orders
                        where date_part('month', order_date) = 1
                        and employee_id = 3
                        order by date_part('year', order_date) desc
                        limit 1
                        )
group by e.employee_id
 

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select pr.product_name,c.category_name,od.quantity from order_details od
inner join products pr on od.product_id = pr.product_id
inner join categories c on pr.category_id = c.category_id
where od.order_id = 10248

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select pr.product_name,s.company_name from order_details od
inner join products pr on od.product_id = pr.product_id
inner join suppliers s on pr.supplier_id = s.supplier_id
where od.order_id = 10248

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select pr.product_name,sum(od.quantity) from orders o 
inner join order_details od on o.order_id = od.order_id
inner join products pr on od.product_id = pr.product_id
where o.employee_id=3 and date_part('year',o.order_date) = 1997
group by pr.product_name

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, first_name, last_name
from orders
inner join employees e
on orders.employee_id = e.employee_id
where order_id = 
    (select od.order_id
     from order_details od
     inner join orders o
     on o.order_id = od.order_id
     where date_part('year', o.order_date) = 1997
     group by od.order_id
     order by sum(quantity) desc
     limit 1)
	 
--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS "Çalışan Ad Soyad"
FROM Employees e
WHERE e.employee_id = (
    SELECT o.employee_id
    FROM Orders o
    INNER JOIN Order_Details od ON o.order_id = od.order_id
    WHERE date_part('year', o.Order_Date) = 1997
    GROUP BY o.employee_id
    ORDER BY SUM(od.quantity) DESC--azalan sırala
    LIMIT 1
)

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id = c.category_id
order by p.unit_price desc
limit 1

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id
from orders o
inner join employees e
on o.employee_id = e.employee_id
order by o.order_date

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select od.order_id,
    avg((pr.unit_price * od.quantity) - (pr.unit_price * od.quantity) * od.discount) as TotalPrice
    from order_details od
    inner join products pr 
	on od.product_id = pr.product_id
    group by od.order_id
    order by od.order_id desc
    limit 5

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity) as ToplamSatisMiktari
	from orders o
	inner join order_details od
	on o.order_id = od.order_id
	inner join products p
	on p.product_id = od.product_id
	inner join categories c
	on c.category_id = p.category_id
	where date_part('month', o.order_date) = 1
	group by p.product_name, c.category_name
 
--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select *
from order_details od
where quantity>(select AVG(quantity) from order_details)
order by od.quantity desc

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join categories c on c.category_id = p.category_id
order by p.units_on_order desc
limit 1

--62. Kaç ülkeden müşterim var
select count(distinct country) from customers

--63. Hangi ülkeden kaç müşterimiz var
select country,count(country) from customers
group by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select concat(e.first_name, ' ', e.last_name) as AdSoyad, sum((od.Unit_Price * od.Quantity) - (od.Unit_Price * od.Quantity) * od.Discount)
 from order_details od
 inner join orders o
 on o.order_id = od.order_id
 inner join employees e
 on o.employee_id = e.employee_id
 where e.employee_id = 3
 and date_part('year', o.Order_Date) >= (select date_part('year', order_date)
                                        from orders
                                        order by order_date desc
                                        limit 1)
 and date_part('month', o.Order_Date) >= 1
 group by AdSoyad
 
--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum((unit_Price * quantity) - (unit_Price * quantity) * discount) from order_details 
where product_id=10

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select employee_id, count(order_id) from orders group by employee_id

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.* from orders o
right join customers c on c.customer_id = o.customer_id
where order_id is null

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,address,city,country from customers where country = 'Brazil'

--69. Brezilya’da olmayan müşteriler
select * from customers where country != 'Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country in('France','Spain','Germany')

--71. Faks numarasını bilmediğim müşteriler
select * from customers where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
Select * from Customers
where city in ('London','Paris')

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers where city = 'México D.F.' and contact_title='Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name,unit_price from products
where product_name like 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees
where first_name like 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where upper(company_name) like '%RESTAURANT%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price from products
where unit_price between 50 and 100

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select o.order_id, o.order_date
from orders o
where order_date between '1996-7-1' and '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country='Germany' or country='Spain' or country='France'

--80. Faks numarasını bilmediğim müşteriler
select * from customers where fax is null

--81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
Select product_name,unit_price from products
order by unit_price desc

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price
from products
order by unit_price desc, units_in_stock asc

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(*) from products
where category_id = 1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct ship_country) from orders