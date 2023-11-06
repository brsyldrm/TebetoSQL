-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
Select product_name,quantity_per_unit from products;

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
Select product_id,product_name from products
where discontinued=0;

-- 3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
Select product_id,product_name from products
where discontinued=1;

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id,product_name,unit_price from products
where unit_price<20
order by unit_price;

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id,product_name,unit_price from products
where unit_price between 15 and 25
order by unit_price

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_name,units_on_order,units_in_stock from products
where units_on_order>units_in_stock

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
select product_name from products
where product_name like 'A%'

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
select product_name from products
where product_name like '%i'

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name,unit_price,unit_price*1.18 as UnitPriceKDV from products

-- 10. Fiyatı 30 dan büyük kaç ürün var?
select count(product_name) from products
where unit_price>30

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select LOWER(product_name),unit_price from products
ORDER BY unit_price desc

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT CONCAT(first_name,' ',last_name) FROM employees

-- 13. Region alanı NULL olan kaç tedarikçim var?
Select * from suppliers
where region is null

-- 14. a.Null olmayanlar?
Select * from suppliers
where region is not null

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT concat('TR ',UPPER(product_name)) FROM products

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT concat('TR ',UPPER(product_name)),unit_price FROM products
where unit_price<20

-- 17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
order by unit_price desc
LIMIT 1
-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
order by unit_price desc
LIMIT 10
-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
where unit_price>(Select  AVG(unit_price) from products )
order by unit_price
-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
Select sum(unit_price*units_in_stock) from products
where units_in_stock>0

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select count(product_name) from products
where units_in_stock>0 and discontinued=1

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select product_name,category_name from products p
JOIN categories c
on p.category_id=c.category_id

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select category_name,avg(p.unit_price) from categories c
JOIN products p
on p.category_id=c.category_id
group by category_name

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select product_name,category_name,unit_price from products p
JOIN categories c
on p.category_id=c.category_id
ORDER BY unit_price desc
LIMIT 1
-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select o.product_id,sum(quantity),product_name,category_name,company_name from categories c
JOIN products p
on p.category_id=c.category_id
JOIN suppliers s
on s.supplier_id=p.supplier_id
JOIN order_details o
on o.product_id=p.product_id
group by o.product_id,product_name,category_name,company_name
order by sum(quantity) desc
LIMIT 1
