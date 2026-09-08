Task 41 — Staff member and their manager's full name

manager_id same staff_id ko refer karta hai.

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;

LEFT JOIN ki wajah se top-level staff bhi show honge aur unka manager_name NULL hoga.

Task 42 — Same brand + exact same list price
SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;

p1.product_id < p2.product_id duplicate pairs ko prevent karta hai.

Task 43 — Customers from same city and state
SELECT 
    c1.customer_id AS customer_1_id,
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.customer_id AS customer_2_id,
    c2.first_name + ' ' + c2.last_name AS customer_2,
    c1.city,
    c1.state
FROM sales.customers AS c1
JOIN sales.customers AS c2
    ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id;

customer_id < ki wajah se A-B aur B-A dono nahi aayenge.

Task 44 — Staff and manager working at the same store

Tumhare diagram mein staffs table mein store_id aur manager_id hain, lekin separate hire_date column nahi hai. Is schema ke basis par same store check karne ka query:

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    s.store_id
FROM sales.staffs AS s
JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id;
Cross Join
Task 45 — Every brand × every category
SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;

Har brand ko har category ke saath pair karega.

Task 46 — Brand-category combinations with NO products
SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;

Yahan pehle all combinations bante hain, phir products se match karke unmatched combinations nikale jaate hain.

Task 47 — Every store × every product with stock quantity
SELECT 
    s.store_name,
    p.product_name,
    ISNULL(st.quantity, 0) AS stock_quantity
FROM sales.stores AS s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS st
    ON s.store_id = st.store_id
    AND p.product_id = st.product_id;

ISNULL(..., 0) ka matlab: agar product store mein nahi hai to 0 show karo.

Task 48 — Every staff × every store + actual assignments
SELECT 
    st.first_name + ' ' + st.last_name AS staff_name,
    s.store_name,
    CASE 
        WHEN st.store_id = s.store_id THEN 'Current Assignment'
        ELSE 'Not Assigned'
    END AS assignment_status
FROM sales.staffs AS st
CROSS JOIN sales.stores AS s;
Right Join
Task 49 — All brands and their products
SELECT 
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;

RIGHT JOIN ensure karta hai ke all brands appear hon, even if no products hain.

Task 50 — All stores and their orders
SELECT 
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
    ON o.store_id = s.store_id;

Jis store ka koi order nahi hoga, uske liye order_id NULL hoga.

Task 51 — All categories with product count
SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products AS p
RIGHT JOIN production.categories AS c
    ON p.category_id = c.category_id
GROUP BY c.category_name;

COUNT(p.product_id) use karna important hai, COUNT(*) nahi, warna empty categories ka count 1 aa sakta hai.

Task 52 — All staff and orders they handled
SELECT 
    st.staff_id,
    st.first_name + ' ' + st.last_name AS staff_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id;

Isse zero orders handle karne wale staff members bhi show honge.

Left Anti Join
Task 53 — Customers who NEVER placed an order
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
Task 54 — Products NOT currently in stock at ANY store
SELECT 
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS st
    ON p.product_id = st.product_id
WHERE st.store_id IS NULL;
Task 55 — Brands with NO products
SELECT 
    b.brand_id,
    b.brand_name
FROM production.brands AS b
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;
Task 56 — Products that have NEVER been ordered
SELECT 
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;
Task 57 — Stores with NO staff assigned
SELECT 
    s.store_id,
    s.store_name
FROM sales.stores AS s
LEFT JOIN sales.staffs AS st
    ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;
Task 58 — Staff who NEVER handled an order
SELECT 
    st.staff_id,
    st.first_name,
    st.last_name
FROM sales.staffs AS st
LEFT JOIN sales.orders AS o
    ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;
Task 59 — Categories where NO product has price above 2000
SELECT 
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS high_price
    ON c.category_id = high_price.category_id
WHERE high_price.category_id IS NULL;

Logic: Pehle woh categories find hoti hain jahan price > 2000 hai, phir unko exclude karke baqi categories milti hain.

Task 60 — Customers who ordered but NEVER ordered Trek
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o2
    JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    JOIN production.products AS p
        ON oi.product_id = p.product_id
    JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE o2.customer_id = c.customer_id
      AND b.brand_name = 'Trek'
