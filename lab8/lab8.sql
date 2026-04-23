--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

-- Started on 2026-03-26 12:10:51 +05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 16398)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 3 (class 3079 OID 16399)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 247 (class 1255 OID 17445)
-- Name: get_customer_full_name(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_customer_full_name(p_customer_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    full_name text;
BEGIN
    SELECT last_name || ' ' || first_name
    INTO full_name
    FROM customers
    WHERE customer_id = p_customer_id;

    RETURN full_name;
END;
$$;


ALTER FUNCTION public.get_customer_full_name(p_customer_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 34042)
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    author_id integer NOT NULL,
    name character varying(100) NOT NULL,
    birth_year integer
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 34052)
-- Name: bookauthors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookauthors (
    book_isbn character varying(20) NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.bookauthors OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 34047)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    isbn character varying(20) NOT NULL,
    title character varying(200) NOT NULL,
    publisher character varying(100),
    publication_year integer,
    price numeric(10,2) NOT NULL,
    stock_quantity integer NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 34067)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    address character varying(200),
    registration_date date
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 34084)
-- Name: orderitems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderitems (
    order_item_id integer NOT NULL,
    order_id integer,
    book_isbn character varying(20),
    quantity integer,
    price numeric(10,2)
);


ALTER TABLE public.orderitems OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 34074)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    order_date date,
    total_amount numeric(10,2),
    status character varying(20)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 16400)
-- Dependencies: 220
-- Data for Name: pga_jobagent; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
410	2026-03-20 15:25:22.308202+05	MacBook-Air-Dinara-2.local
\.


--
-- TOC entry 3514 (class 0 OID 16409)
-- Dependencies: 222
-- Data for Name: pga_jobclass; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
\.


--
-- TOC entry 3515 (class 0 OID 16419)
-- Dependencies: 224
-- Data for Name: pga_job; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
\.


--
-- TOC entry 3517 (class 0 OID 16467)
-- Dependencies: 228
-- Data for Name: pga_schedule; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
\.


--
-- TOC entry 3518 (class 0 OID 16495)
-- Dependencies: 230
-- Data for Name: pga_exception; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
\.


--
-- TOC entry 3519 (class 0 OID 16509)
-- Dependencies: 232
-- Data for Name: pga_joblog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
\.


--
-- TOC entry 3516 (class 0 OID 16443)
-- Dependencies: 226
-- Data for Name: pga_jobstep; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
\.


--
-- TOC entry 3520 (class 0 OID 16525)
-- Dependencies: 234
-- Data for Name: pga_jobsteplog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
\.


--
-- TOC entry 3747 (class 0 OID 34042)
-- Dependencies: 235
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (author_id, name, birth_year) FROM stdin;
1	J.K. Rowling	1965
2	George Orwell	1903
3	J.R.R. Tolkien	1892
4	Agatha Christie	1890
5	Dan Brown	1964
\.


--
-- TOC entry 3749 (class 0 OID 34052)
-- Dependencies: 237
-- Data for Name: bookauthors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookauthors (book_isbn, author_id) FROM stdin;
ISBN001	1
ISBN009	1
ISBN010	1
ISBN002	2
ISBN003	2
ISBN004	3
ISBN005	3
ISBN006	4
ISBN007	5
ISBN008	5
\.


--
-- TOC entry 3748 (class 0 OID 34047)
-- Dependencies: 236
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (isbn, title, publisher, publication_year, price, stock_quantity) FROM stdin;
ISBN001	Harry Potter	Bloomsbury	1997	20.00	50
ISBN002	1984	Secker & Warburg	1949	15.00	40
ISBN003	Animal Farm	Secker & Warburg	1945	12.00	35
ISBN004	Lord of the Rings	Allen & Unwin	1954	25.00	20
ISBN005	Hobbit	Allen & Unwin	1937	18.00	30
ISBN006	Murder on the Orient Express	Collins Crime Club	1934	14.00	25
ISBN007	Da Vinci Code	Doubleday	2003	22.00	45
ISBN008	Angels and Demons	Pocket Books	2000	19.00	40
ISBN009	Casual Vacancy	Little Brown	2012	17.00	15
ISBN010	Silkworm	Mulholland Books	2014	16.00	10
\.


--
-- TOC entry 3750 (class 0 OID 34067)
-- Dependencies: 238
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, name, email, address, registration_date) FROM stdin;
1	Alice Smith	alice@mail.com	NY, USA	2023-01-10
2	Bob Lee	bob@mail.com	LA, USA	2023-05-12
3	Charlie Brown	charlie@mail.com	Chicago, USA	2024-02-01
4	Diana Prince	diana@mail.com	Paris, France	2024-03-15
5	Ethan Hunt	ethan@mail.com	London, UK	2022-11-20
\.


--
-- TOC entry 3752 (class 0 OID 34084)
-- Dependencies: 240
-- Data for Name: orderitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderitems (order_item_id, order_id, book_isbn, quantity, price) FROM stdin;
1	1	ISBN001	2	20.00
2	2	ISBN004	1	25.00
3	3	ISBN002	2	15.00
4	4	ISBN007	1	22.00
5	5	ISBN004	2	25.00
6	6	ISBN005	1	18.00
7	7	ISBN003	2	12.00
8	8	ISBN008	1	19.00
9	8	ISBN006	1	14.00
\.


--
-- TOC entry 3751 (class 0 OID 34074)
-- Dependencies: 239
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, order_date, total_amount, status) FROM stdin;
1	1	2024-03-01	40.00	shipped
2	2	2024-03-05	25.00	pending
3	3	2024-03-10	30.00	shipped
4	1	2024-03-15	22.00	pending
5	4	2024-02-20	50.00	shipped
6	5	2024-01-10	18.00	shipped
7	3	2024-03-18	27.00	pending
8	2	2024-03-22	35.00	shipped
\.


--
-- TOC entry 3586 (class 2606 OID 34046)
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- TOC entry 3590 (class 2606 OID 34056)
-- Name: bookauthors bookauthors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookauthors
    ADD CONSTRAINT bookauthors_pkey PRIMARY KEY (book_isbn, author_id);


--
-- TOC entry 3588 (class 2606 OID 34051)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (isbn);


--
-- TOC entry 3592 (class 2606 OID 34073)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 3594 (class 2606 OID 34071)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3598 (class 2606 OID 34088)
-- Name: orderitems orderitems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 3596 (class 2606 OID 34078)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3599 (class 2606 OID 34062)
-- Name: bookauthors bookauthors_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookauthors
    ADD CONSTRAINT bookauthors_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(author_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3600 (class 2606 OID 34057)
-- Name: bookauthors bookauthors_book_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookauthors
    ADD CONSTRAINT bookauthors_book_isbn_fkey FOREIGN KEY (book_isbn) REFERENCES public.books(isbn) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3602 (class 2606 OID 34094)
-- Name: orderitems orderitems_book_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_book_isbn_fkey FOREIGN KEY (book_isbn) REFERENCES public.books(isbn) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3603 (class 2606 OID 34089)
-- Name: orderitems orderitems_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3601 (class 2606 OID 34079)
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-03-26 12:10:51 +05

--
-- PostgreSQL database dump complete
--

