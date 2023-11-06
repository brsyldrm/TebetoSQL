--86. a.Bu ülkeler hangileri..?
select distinct ship_country from orders
--87. En Pahalı 5 ürün
select * from products 
order by unit_price desc
limit 5
--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select count(*) from orders
where customer_id ='ALFKI'
--89. Ürünlerimin toplam maliyeti
select sum(unit_price * quantity) from order_details
--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum((unit_price * quantity * (1 - discount)) ) from order_details
--91. Ortalama Ürün Fiyatım
Select avg(unit_price) from products
--92. En Pahalı Ürünün Adı
select product_name from products 
order by unit_price desc
limit 1
--93. En az kazandıran sipariş
select * from orders
where order_id = (select order_id  from order_details
group by order_id
order by sum((unit_price * quantity * (1 - discount)) )
limit 1)

--94. Müşterilerimin içinde en uzun isimli müşteri
select * from customers
order by length(company_name) desc
limit 1
--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name, last_name ,date_part('year',age(birth_date)) as yas  
from employees

--96. Hangi üründen toplam kaç adet alınmış..?
select od.product_id, pr.product_name, sum(od.quantity) 
from order_details od
inner join products pr on od.product_id = pr.product_id
group by od.product_id,pr.product_name
--97. Hangi siparişte toplam ne kadar kazanmışım..?
select order_id, sum((unit_price * quantity * (1 - discount)) ) 
from order_details
group by order_id
--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select pr.category_id,c.category_name, count(*) from products pr
inner join categories c on pr.category_id = c.category_id
group by pr.category_id,c.category_name
--99. 1000 Adetten fazla satılan ürünler?
select pr.product_id,pr.product_name,sum(od.quantity) from order_details od
inner join products pr on od.product_id = pr.product_id
group by pr.product_id
having sum(od.quantity) > 1000
order by pr.product_name

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.* from orders o
right join customers c on c.customer_id = o.customer_id
where order_id is null

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.company_name, pr.product_name from products pr
inner join suppliers s on pr.supplier_id=s.supplier_id
--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select s.company_name,o.order_id,o.shipped_date from orders o
inner join shippers s on o.ship_via = s.shipper_id
--103. Hangi siparişi hangi müşteri verir..?
select o.order_id,c.company_name from orders o
inner join customers c on o.customer_id = c.customer_id
--104. Hangi çalışan, toplam kaç sipariş almış..?
select o.employee_id, e.first_name, e.last_name, count(o.employee_id) as toplam 
from employees e
inner join orders o on o.employee_id = e.employee_id
group by o.employee_id, e.first_name, e.last_name
order by o.employee_id 

--105. En fazla siparişi kim almış..?
select o.employee_id, e.first_name, e.last_name, count(o.employee_id) as toplam 
from employees e
inner join orders o on o.employee_id = e.employee_id
group by o.employee_id, e.first_name, e.last_name
order by toplam desc
limit 1
--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id,c.company_name,(e.first_name || ' ' || e.last_name) as "ad soyad" 
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id
--107. Hangi ürün, hangi kategoride bulunmaktadır..? 
--Bu ürünü kim tedarik etmektedir..?
select p.product_name,c.category_name,s.company_name from products p
inner join categories c on p.category_id = c.category_id
inner join suppliers s on p.supplier_id = s.supplier_id
--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, 
--hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, 
--hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi 
--tedarikçi sağlamış
select o.order_id,c.company_name,(e.first_name || ' ' || e.last_name) as "çalışan",
o.order_date,sh.company_name,pr.product_name, od.quantity,od.unit_price,ca.category_name,s.company_name from orders o
inner join employees e on o.employee_id = e.employee_id
inner join customers c on o.customer_id = c.customer_id
inner join shippers sh on o.ship_via = sh.shipper_id
inner join order_details od on o.order_id = od.order_id
inner join products pr on od.product_id = pr.product_id
inner join categories ca on pr.category_id = ca.category_id
inner join suppliers s on pr.supplier_id = s.supplier_id
--109. Altında ürün bulunmayan kategoriler
select c.* from products p
right join categories c on p.category_id = c.category_id
where p.category_id is null
--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select * from customers where contact_title like '%Manager%'
--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select * from customers
where company_name like 'FR%'
and length(company_name) = 5;
--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers
where phone like '%(171)%'
--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products
where quantity_per_unit like '%boxes%'
--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name, phone from customers
where contact_title like '%Manager%'
and country in('France', 'Germany')
--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
Select * from products
order by unit_price desc
limit 10
--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
Select * from customers
order by country, city 
--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name, last_name, date_part('year', age(birth_date)) as Age 
from employees
--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders
where shipped_date - order_date >= 35
--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name from categories 
where category_id = (select category_id from products
					order by unit_price desc 
					limit 1)
--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select p.Product_Name, c.Category_Name
from Products p
inner join Categories c on p.Category_ID = c.Category_ID
where c.Category_Name like '%on%';
--121. Konbu adlı üründen kaç adet satılmıştır.
select sum(quantity) as total
from order_details
where product_id = (select product_id
                    from products p
                    where product_name = 'Konbu')

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct product_id) from products 
where supplier_id in (select supplier_id from suppliers
					 where country = 'Japan')
--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight), min(freight), avg(freight) from orders
where date_part('year', order_date) =1997
--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers
where fax is not null
--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select order_id from orders
where shipped_date between '1996-07-16' and '1996-07-30'