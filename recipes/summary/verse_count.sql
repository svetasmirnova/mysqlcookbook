# verse_count.sql

# Various ways of counting verses in the King James Version

# Total verses overall

SELECT COUNT(*) AS 'total number of verses' FROM kjv;

# Number of verses per book, in book order

# group by bnum rather than bname to sort in book number order

SELECT bname AS 'book', COUNT(*) AS 'verses in book'
FROM kjv
GROUP BY bnum;

# Number of verses per book, most-chapters books first

SELECT bname AS 'book', COUNT(*) AS 'verses in book'
FROM kjv
GROUP BY bnum
ORDER BY 'verses in book' DESC, bnum;

# Number of verses per chapter of each book: in book/chapter order,
# and by most-verses order

SELECT bname AS 'book', cnum AS chapter, COUNT(*) AS 'verses in chapter'
FROM kjv
GROUP BY bnum, cnum;

SELECT bname AS 'book', cnum AS chapter, COUNT(*) AS 'verses in chapter'
FROM kjv
GROUP BY bnum, cnum
ORDER BY 'verses in chapter' DESC, bnum, cnum;

# Number of chapters per book: by book, and by most-chapters books

SELECT bname AS 'book', COUNT(DISTINCT cnum) AS 'chapters in book'
FROM kjv
GROUP BY bnum;

SELECT bname AS 'book', COUNT(DISTINCT cnum) AS 'chapters in book'
FROM kjv
GROUP BY bnum
ORDER BY 'chapters in book' DESC, bnum;

# Are there any verses that are the same as others?

SELECT COUNT(vtext) - COUNT(DISTINCT vtext) AS 'number of nonunique verses'
FROM kjv;

# And what are they?

SELECT COUNT(vtext) AS count, vtext
FROM kjv
GROUP BY vtext
HAVING count > 1;
