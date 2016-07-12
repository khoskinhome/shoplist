--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: item_groups_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE item_groups_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_groups_seq OWNER TO shoplist_write;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: item_groups; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE item_groups (
    id integer DEFAULT nextval('item_groups_seq'::regclass) NOT NULL,
    name text NOT NULL,
    tag text NOT NULL,
    sequence integer
);


ALTER TABLE public.item_groups OWNER TO shoplist_write;

--
-- Name: item_lists_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE item_lists_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_lists_seq OWNER TO shoplist_write;

--
-- Name: item_lists; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE item_lists (
    id integer DEFAULT nextval('item_lists_seq'::regclass) NOT NULL,
    item_id integer NOT NULL,
    list_id integer NOT NULL,
    priority integer NOT NULL,
    price real,
    quantity integer DEFAULT 0
);


ALTER TABLE public.item_lists OWNER TO shoplist_write;

--
-- Name: item_shops; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE item_shops (
    shop_id integer NOT NULL,
    item_id integer NOT NULL,
    price real
);


ALTER TABLE public.item_shops OWNER TO shoplist_write;

--
-- Name: item_shops_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE item_shops_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_shops_seq OWNER TO shoplist_write;

--
-- Name: items_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE items_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_seq OWNER TO shoplist_write;

--
-- Name: items; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE items (
    id integer DEFAULT nextval('items_seq'::regclass) NOT NULL,
    item_group_id integer NOT NULL,
    name text NOT NULL,
    show_item boolean DEFAULT true NOT NULL
);


ALTER TABLE public.items OWNER TO shoplist_write;

--
-- Name: lists_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE lists_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lists_seq OWNER TO shoplist_write;

--
-- Name: lists; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE lists (
    id integer DEFAULT nextval('lists_seq'::regclass) NOT NULL,
    name text NOT NULL,
    create_date timestamp with time zone NOT NULL,
    show_all boolean DEFAULT false
);


ALTER TABLE public.lists OWNER TO shoplist_write;

--
-- Name: shops_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE shops_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shops_seq OWNER TO shoplist_write;

--
-- Name: shops; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE shops (
    id integer DEFAULT nextval('shops_seq'::regclass) NOT NULL,
    name text NOT NULL,
    tag text NOT NULL
);


ALTER TABLE public.shops OWNER TO shoplist_write;

--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE users_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_seq OWNER TO shoplist_write;

--
-- Name: users; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_seq'::regclass) NOT NULL,
    username text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    passhash text NOT NULL,
    passhash_expire timestamp with time zone,
    passhash_must_change boolean,
    is_api_user boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    can_remote boolean DEFAULT false NOT NULL,
    mobile_phone text NOT NULL
);


ALTER TABLE public.users OWNER TO shoplist_write;

--
-- Data for Name: item_groups; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY item_groups (id, name, tag, sequence) FROM stdin;
1	Drinks	drinks	10
2	Tinned	tinned	20
3	Cleaning	cleaning	30
4	Toiletries	toiletries	40
5	Miscellaneous	miscellaneous	50
7	Savoury Snacks	savoury-snacks	70
8	Fruit and Veg	fruit-n-veg	80
9	Chilled	chilled	90
10	Frozen	frozen	100
6	Bakery	bakery	60
11	Confectionery	confectionery	55
\.


--
-- Name: item_groups_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('item_groups_seq', 11, true);


--
-- Data for Name: item_lists; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY item_lists (id, item_id, list_id, priority, price, quantity) FROM stdin;
\.


--
-- Name: item_lists_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('item_lists_seq', 1, false);


--
-- Data for Name: item_shops; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY item_shops (shop_id, item_id, price) FROM stdin;
1	3	\N
5	3	\N
5	21	\N
1	22	\N
5	22	\N
1	23	\N
5	23	\N
1	24	\N
5	24	\N
1	26	\N
5	26	\N
3	26	\N
5	27	\N
1	28	\N
5	28	\N
3	28	\N
1	29	\N
5	29	\N
3	29	\N
1	30	\N
1	31	\N
1	32	\N
1	33	\N
3	34	\N
1	35	\N
3	35	\N
1	36	\N
3	36	\N
1	37	\N
3	37	\N
1	38	\N
3	38	\N
1	39	\N
3	39	\N
1	40	\N
3	40	\N
1	41	\N
5	41	\N
4	41	\N
5	42	\N
5	44	\N
5	46	\N
5	47	\N
1	48	\N
5	48	\N
1	49	\N
5	49	\N
5	52	\N
1	53	\N
5	53	\N
1	54	\N
5	54	\N
3	54	\N
1	57	\N
5	57	\N
1	60	\N
5	60	\N
3	60	\N
1	61	\N
5	61	\N
3	61	\N
1	62	\N
5	62	\N
3	62	\N
1	63	\N
5	63	\N
5	68	\N
3	68	\N
3	69	\N
3	70	\N
3	71	\N
1	72	\N
3	72	\N
3	73	\N
3	74	\N
1	75	\N
3	75	\N
1	76	\N
3	77	\N
3	78	\N
3	79	\N
1	25	\N
5	25	\N
5	43	\N
\.


--
-- Name: item_shops_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('item_shops_seq', 1, false);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY items (id, item_group_id, name, show_item) FROM stdin;
3	9	fresh-chicken	t
21	9	sausages-in-bacon	t
22	10	frozen-fish	t
23	10	frozen-peas	t
24	10	ice-creams	t
26	9	bacon	t
27	10	kebab-meat	t
28	9	ham	t
29	9	corned-beef	t
30	9	dairylea-dunkers	t
31	6	crumpets	t
32	6	pain-au-chocolat	t
33	9	choc-puds	t
34	9	fresh-salmon	t
35	9	milk	t
36	9	blue-cheese-stilton	t
37	9	cream	t
38	9	dips-sour-cream-and-chive	t
39	9	mackerel	t
40	9	large-block-of-extra-mature-cheddar	t
41	10	veggie-burgers	t
42	10	curly-fries	t
44	10	turkey-joint	t
46	10	chicken-breast-nuggets	t
47	10	southern-fried-chicken-bits	t
48	10	french-fry-frozen-chips	t
49	10	cheese-stuffed-crust-frozen-pizza	t
52	10	beef-mince	t
53	10	quarter-pounder-beef-burgers	t
54	9	salami	t
57	10	garlic-bread	t
60	9	chicken-roll	t
61	9	nice-chicken-slices	t
62	9	sliced-beef	t
63	9	frozen-york-puds	t
68	9	large-block-of-mild-cheddar	t
69	9	brie	t
70	9	butter	t
71	9	spread	t
72	9	humous	t
73	9	cream-cheese	t
74	9	cheese-triangles	t
75	9	processed-cheese-slices	t
76	9	yoghurts-fruit-corner	t
77	9	packs-of-eggs	t
78	9	ribeye-steak	t
79	9	black-pudding	t
25	11	mintos	t
43	10	mini-kiev-balls	t
\.


--
-- Name: items_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('items_seq', 80, true);


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY lists (id, name, create_date, show_all) FROM stdin;
\.


--
-- Name: lists_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('lists_seq', 1, false);


--
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY shops (id, name, tag) FROM stdin;
1	Asda	As
3	Lidl	L
4	Sainsburys	S
8	Wilko	W
5	Iceland	Ic
\.


--
-- Name: shops_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('shops_seq', 8, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY users (id, username, name, email, passhash, passhash_expire, passhash_must_change, is_api_user, is_admin, can_remote, mobile_phone) FROM stdin;
\.


--
-- Name: users_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('users_seq', 1, false);


--
-- Name: item_groups_name_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY item_groups
    ADD CONSTRAINT item_groups_name_key UNIQUE (name);


--
-- Name: item_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY item_groups
    ADD CONSTRAINT item_groups_pkey PRIMARY KEY (id);


--
-- Name: item_groups_tag_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY item_groups
    ADD CONSTRAINT item_groups_tag_key UNIQUE (tag);


--
-- Name: item_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY item_lists
    ADD CONSTRAINT item_lists_pkey PRIMARY KEY (id);


--
-- Name: items_name_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_name_key UNIQUE (name);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: lists_name_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_name_key UNIQUE (name);


--
-- Name: lists_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: shops_name_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY shops
    ADD CONSTRAINT shops_name_key UNIQUE (name);


--
-- Name: shops_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- Name: shops_tag_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY shops
    ADD CONSTRAINT shops_tag_key UNIQUE (tag);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_mobile_phone_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_mobile_phone_key UNIQUE (mobile_phone);


--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: shoplist_write; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: items_name_idx; Type: INDEX; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE UNIQUE INDEX items_name_idx ON items USING btree (name);


--
-- Name: item_lists_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY item_lists
    ADD CONSTRAINT item_lists_item_id_fkey FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_lists_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY item_lists
    ADD CONSTRAINT item_lists_list_id_fkey FOREIGN KEY (list_id) REFERENCES lists(id);


--
-- Name: item_shops_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY item_shops
    ADD CONSTRAINT item_shops_item_id_fkey FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_shops_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY item_shops
    ADD CONSTRAINT item_shops_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES shops(id);


--
-- Name: items_item_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_item_group_id_fkey FOREIGN KEY (item_group_id) REFERENCES item_groups(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: item_groups_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE item_groups_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE item_groups_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE item_groups_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE item_groups_seq TO shoplist_read;


--
-- Name: item_groups; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE item_groups FROM PUBLIC;
REVOKE ALL ON TABLE item_groups FROM shoplist_write;
GRANT ALL ON TABLE item_groups TO shoplist_write;
GRANT SELECT ON TABLE item_groups TO shoplist_read;


--
-- Name: item_lists_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE item_lists_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE item_lists_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE item_lists_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE item_lists_seq TO shoplist_read;


--
-- Name: item_lists; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE item_lists FROM PUBLIC;
REVOKE ALL ON TABLE item_lists FROM shoplist_write;
GRANT ALL ON TABLE item_lists TO shoplist_write;
GRANT SELECT ON TABLE item_lists TO shoplist_read;


--
-- Name: item_shops; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE item_shops FROM PUBLIC;
REVOKE ALL ON TABLE item_shops FROM shoplist_write;
GRANT ALL ON TABLE item_shops TO shoplist_write;
GRANT SELECT ON TABLE item_shops TO shoplist_read;


--
-- Name: item_shops_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE item_shops_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE item_shops_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE item_shops_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE item_shops_seq TO shoplist_read;


--
-- Name: items_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE items_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE items_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE items_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE items_seq TO shoplist_read;


--
-- Name: items; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE items FROM PUBLIC;
REVOKE ALL ON TABLE items FROM shoplist_write;
GRANT ALL ON TABLE items TO shoplist_write;
GRANT SELECT ON TABLE items TO shoplist_read;


--
-- Name: lists_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE lists_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lists_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE lists_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE lists_seq TO shoplist_read;


--
-- Name: lists; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE lists FROM PUBLIC;
REVOKE ALL ON TABLE lists FROM shoplist_write;
GRANT ALL ON TABLE lists TO shoplist_write;
GRANT SELECT ON TABLE lists TO shoplist_read;


--
-- Name: shops_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE shops_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE shops_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE shops_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE shops_seq TO shoplist_read;


--
-- Name: shops; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE shops FROM PUBLIC;
REVOKE ALL ON TABLE shops FROM shoplist_write;
GRANT ALL ON TABLE shops TO shoplist_write;
GRANT SELECT ON TABLE shops TO shoplist_read;


--
-- Name: users_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE users_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE users_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE users_seq TO khaospy_read;
GRANT ALL ON SEQUENCE users_seq TO khaospy_write;


--
-- Name: users; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM shoplist_write;
GRANT ALL ON TABLE users TO shoplist_write;
GRANT SELECT ON TABLE users TO khaospy_read;
GRANT ALL ON TABLE users TO khaospy_write;


--
-- PostgreSQL database dump complete
--

