SELECT title, published_year
FROM Book
WHERE published_year > (
    SELECT AVG(published_year) 
    FROM Book 
    WHERE published_year IS NOT NULL
);

 
 SELECT m.member_id, m.name, m.email
FROM Member m
WHERE (
    SELECT COUNT(*) 
    FROM Loan l 
    WHERE l.member_id = m.member_id
) > 2;


  SELECT m.name,
       (SELECT b.title
        FROM Loan l 
        JOIN Book b ON l.book_id = b.book_id
        WHERE l.member_id = m.member_id
        ORDER BY l.loan_date DESC
        LIMIT 1) AS latest_book
FROM Member m;

SELECT DISTINCT a.name AS author_name
FROM Author a
WHERE EXISTS (
    SELECT 1
    FROM Book b
    JOIN Loan l ON b.book_id = l.book_id
    WHERE b.book_id = a.author_id
    AND l.return_date IS NULL
);

SELECT title
FROM Book
WHERE book_id IN (
    SELECT l.book_id
    FROM Loan l
    JOIN Member m ON l.member_id = m.member_id
    WHERE m.join_date > '2025-01-01'
);
 
SELECT m.name, COUNT(l.loan_id) AS total_loans
FROM Member m
JOIN Loan l ON m.member_id = l.member_id
GROUP BY m.member_id
HAVING COUNT(l.loan_id) = (
    SELECT MAX(borrow_count)
    FROM (
        SELECT COUNT(*) AS borrow_count
        FROM Loan
        GROUP BY member_id
    ) AS sub
);
 
 SELECT title
FROM Book
WHERE book_id NOT IN (SELECT DISTINCT book_id FROM Loan);

SELECT a.name, COUNT(b.book_id) AS book_count
FROM Author a
JOIN Book b ON a.author_id = a.author_id
GROUP BY a.author_id
HAVING COUNT(b.book_id) = (
    SELECT MAX(book_total)
    FROM (
        SELECT COUNT(book_id) AS book_total
        FROM Book
        GROUP BY author_id
    ) AS sub
);
 