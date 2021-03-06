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


ALTER TABLE item_groups_seq OWNER TO shoplist_write;

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


ALTER TABLE item_groups OWNER TO shoplist_write;

--
-- Name: item_shops; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE item_shops (
    shop_id integer NOT NULL,
    item_id integer NOT NULL,
    price real
);


ALTER TABLE item_shops OWNER TO shoplist_write;

--
-- Name: item_shops_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE item_shops_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_shops_seq OWNER TO shoplist_write;

--
-- Name: items_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE items_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items_seq OWNER TO shoplist_write;

--
-- Name: items; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE items (
    id integer DEFAULT nextval('items_seq'::regclass) NOT NULL,
    item_group_id integer NOT NULL,
    name text NOT NULL,
    show_item boolean DEFAULT true NOT NULL
);


ALTER TABLE items OWNER TO shoplist_write;

--
-- Name: lists_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE lists_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lists_seq OWNER TO shoplist_write;

--
-- Name: lists; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE lists (
    id integer DEFAULT nextval('lists_seq'::regclass) NOT NULL,
    show_all_items boolean DEFAULT false,
    show_list boolean DEFAULT true,
    name text NOT NULL,
    create_date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE lists OWNER TO shoplist_write;

--
-- Name: shopping_lists_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE shopping_lists_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shopping_lists_seq OWNER TO shoplist_write;

--
-- Name: shopping_lists; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE shopping_lists (
    id integer DEFAULT nextval('shopping_lists_seq'::regclass) NOT NULL,
    item_id integer NOT NULL,
    list_id integer NOT NULL,
    priority integer NOT NULL,
    price real,
    quantity integer DEFAULT 0
);


ALTER TABLE shopping_lists OWNER TO shoplist_write;

--
-- Name: shops_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE shops_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shops_seq OWNER TO shoplist_write;

--
-- Name: shops; Type: TABLE; Schema: public; Owner: shoplist_write; Tablespace: 
--

CREATE TABLE shops (
    id integer DEFAULT nextval('shops_seq'::regclass) NOT NULL,
    name text NOT NULL,
    tag text NOT NULL
);


ALTER TABLE shops OWNER TO shoplist_write;

--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: shoplist_write
--

CREATE SEQUENCE users_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_seq OWNER TO shoplist_write;

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


ALTER TABLE users OWNER TO shoplist_write;

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
1	32	\N
1	33	\N
3	34	\N
1	36	\N
3	36	\N
1	37	\N
3	37	\N
1	38	\N
3	38	\N
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
5	43	\N
1	81	\N
5	81	\N
4	81	\N
1	82	\N
3	82	\N
3	83	\N
3	84	\N
3	85	\N
3	86	\N
3	87	\N
3	88	\N
1	89	\N
3	90	\N
1	91	\N
1	92	\N
1	93	\N
1	94	\N
3	94	\N
1	96	\N
1	97	\N
4	97	\N
1	98	\N
4	98	\N
3	95	\N
3	99	\N
1	100	\N
3	100	\N
1	101	\N
3	101	\N
3	102	\N
3	103	\N
3	104	\N
3	105	\N
3	106	\N
1	107	\N
1	108	\N
4	108	\N
1	109	\N
4	109	\N
3	110	\N
1	111	\N
3	111	\N
3	112	\N
3	113	\N
3	114	\N
3	115	\N
3	116	\N
1	117	\N
1	118	\N
3	119	\N
3	120	\N
3	121	\N
1	122	\N
3	122	\N
3	123	\N
1	124	\N
3	124	\N
1	125	\N
3	125	\N
1	126	\N
3	126	\N
1	127	\N
3	127	\N
1	128	\N
3	128	\N
1	129	\N
3	129	\N
3	130	\N
3	131	\N
3	132	\N
1	133	\N
3	133	\N
3	134	\N
3	135	\N
3	136	\N
3	137	\N
3	138	\N
3	139	\N
3	140	\N
3	141	\N
3	142	\N
3	143	\N
3	144	\N
3	145	\N
4	146	\N
3	147	\N
3	148	\N
3	149	\N
3	150	\N
3	151	\N
8	152	\N
8	153	\N
3	154	\N
8	154	\N
3	155	\N
8	155	\N
1	157	\N
8	157	\N
8	158	\N
3	159	\N
8	159	\N
3	160	\N
8	160	\N
3	161	\N
8	161	\N
3	162	\N
8	162	\N
8	163	\N
8	164	\N
3	165	\N
8	165	\N
4	166	\N
4	167	\N
8	167	\N
4	168	\N
1	169	\N
3	169	\N
1	170	\N
3	170	\N
3	171	\N
8	171	\N
8	172	\N
8	173	\N
3	174	\N
8	174	\N
3	175	\N
8	175	\N
3	176	\N
8	176	\N
3	177	\N
8	177	\N
3	178	\N
8	178	\N
8	179	\N
8	180	\N
8	181	\N
8	182	\N
8	183	\N
8	184	\N
1	185	\N
3	185	\N
8	186	\N
3	187	\N
8	187	\N
3	188	\N
8	188	\N
3	189	\N
8	189	\N
8	190	\N
1	191	\N
3	191	\N
8	191	\N
1	192	\N
3	192	\N
8	192	\N
1	193	\N
3	193	\N
8	193	\N
1	194	\N
1	195	\N
3	195	\N
1	196	\N
3	196	\N
1	197	\N
3	197	\N
1	198	\N
3	198	\N
1	199	\N
3	199	\N
1	200	\N
3	200	\N
1	201	\N
3	201	\N
1	202	\N
3	202	\N
1	203	\N
3	203	\N
1	204	\N
3	204	\N
1	205	\N
3	205	\N
1	206	\N
3	206	\N
1	207	\N
3	207	\N
1	208	\N
3	208	\N
1	209	\N
3	209	\N
1	210	\N
3	210	\N
1	211	\N
3	211	\N
1	212	\N
3	212	\N
1	213	\N
3	213	\N
1	214	\N
3	214	\N
1	215	\N
3	215	\N
1	216	\N
3	216	\N
1	218	\N
3	218	\N
1	219	\N
3	219	\N
1	220	\N
3	220	\N
1	221	\N
3	221	\N
1	222	\N
3	222	\N
1	223	\N
3	223	\N
1	224	\N
3	224	\N
1	225	\N
3	225	\N
1	25	\N
5	25	\N
1	31	\N
1	63	\N
5	63	\N
5	52	\N
1	35	\N
3	35	\N
1	39	\N
3	39	\N
1	226	\N
3	226	\N
1	227	\N
4	227	\N
1	228	\N
3	228	\N
1	229	\N
3	229	\N
1	230	\N
3	230	\N
1	231	\N
3	231	\N
1	232	\N
3	232	\N
1	233	\N
3	233	\N
8	156	\N
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
32	6	pain-au-chocolat	t
33	9	choc-puds	t
34	9	fresh-salmon	t
36	9	blue-cheese-stilton	t
37	9	cream	t
38	9	dips-sour-cream-and-chive	t
40	9	large-block-of-extra-mature-cheddar	t
41	10	veggie-burgers	t
42	10	curly-fries	t
44	10	turkey-joint	t
46	10	chicken-breast-nuggets	t
47	10	southern-fried-chicken-bits	t
48	10	french-fry-frozen-chips	t
49	10	cheese-stuffed-crust-frozen-pizza	t
53	10	quarter-pounder-beef-burgers	t
54	9	salami	t
57	10	garlic-bread	t
60	9	chicken-roll	t
61	9	nice-chicken-slices	t
62	9	sliced-beef	t
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
43	10	mini-kiev-balls	t
81	1	diet-lemonade	t
82	5	barbecue-sauce-ketchup	t
83	2	tin-of-sardines-in-tomato-sauce	t
84	2	tin-of-salmon	t
85	2	tin-of-tomatoes	t
86	2	tin-of-sweetcorn	t
87	2	tin-of-peaches	t
88	2	Tin-of-tuna-in-sun-f-oil	t
89	2	tin-of-beans	t
90	2	tin-of-potatoes	t
91	2	tin-of-ravioli	t
92	2	tin-of-hoops	t
93	2	tin-of-chicken-soup	t
94	2	tin-of-tomato-soup	t
96	2	cat-food	t
97	2	veg-curry	t
98	2	ratatouile	t
95	2	tin-of-tikka-chicken-curry	t
99	6	tin-of-korma-chicken-curry	t
100	5	brown-sauce	t
101	5	heinz-tomato-ketchup	t
102	5	pepper-corns	t
103	5	soy-sauce	t
104	5	instant-noodles	t
105	5	rapeseed-oil	t
106	5	olive-oil	t
107	5	tomato-sauce-for-pasta-bolognaise	t
108	5	green-pesto	t
109	5	red-pesto	t
110	5	fuesli-pasta	t
111	5	spaghetti	t
112	5	rice	t
113	5	muesli	t
114	5	walnuts	t
115	5	brazil-nuts	t
116	5	mixed-nuts	t
117	5	bread-sticks	t
118	5	small-pkts-raisins	t
119	11	dark-choc	t
120	11	fruit-n-nut-choc	t
121	11	milk-choc	t
122	7	24-pack-of-crisps	t
123	7	6-pack-ridge-cut-crisps	t
124	7	wotsits	t
125	7	doritos	t
126	7	monster-munch	t
127	7	skips	t
128	11	milk-choc-digestive-biscuits	t
129	11	dark-choc-digestive-biscuits	t
130	5	cream-crackers	t
131	5	water-biscuits	t
132	6	part-baked-bread	t
133	6	choco-brioches	t
134	11	choco-coconut-bars	t
135	11	marathon-bars	t
136	6	flour	t
137	6	self-raising-flour	t
138	6	baking-powder	t
139	6	caster-sugar	t
140	6	brown-pitta-bread	t
141	6	white-pitta-bread	t
142	6	brown-bread	t
143	6	white-bread	t
144	5	nutella	t
145	5	packet-of-filter-coffee	t
146	5	coffee-filters	t
147	5	nescafe-instant-coffee	t
148	5	brown-tea-bags	t
149	5	green-tea-bags	t
150	5	nesquik-strawberry-milk-shake	t
151	5	nesquik-chocolate-milk-shake-powder	t
152	3	dishwasher-tablets	t
153	3	toilet-blocks	t
154	3	toilet-roll	t
155	3	kitchen-roll	t
157	3	ironing-water	t
158	3	anti-bacterial-cleaner	t
159	3	disinfectant	t
160	3	washing-up-liquid	t
161	3	hand-wash	t
162	3	hand-sanitizer	t
163	3	small-paper-plates-4-cat	t
164	3	stainless-scourers	t
165	3	aluminium-foil	t
166	4	boston-conditioning-for-contact-lens	t
167	4	contact-lens-saline	t
168	4	boston-contact-lens-cleaner	t
169	4	washing-powder	t
170	3	washing-clothes-conditioner	t
171	3	cream-cleaner	t
172	4	clearasil	t
173	4	oil-of-olay	t
174	4	always-sanitary-towels-purple-maxi	t
175	4	tampax-regular	t
176	4	shave-foam	t
31	6	crumpets	t
63	10	frozen-york-puds	t
52	9	beef-mince	t
35	9	milk-4-pints	t
156	3	furniture-polish	t
177	4	razor-blades	t
178	4	deodourant	t
179	4	interdental-tootbrushes	t
180	4	toothbrushes	t
181	4	pink-mouthwash	t
182	4	smokers-toothpaste	t
183	3	blue-cloths	t
184	3	mildew-spray	t
185	3	cat-litter	t
186	4	bubble-bath	t
187	4	hair-shampoo	t
188	4	hair-conditioner	t
189	4	shower-gel	t
190	4	hair-bands	t
191	3	large-food-bags	t
192	3	medium-food-bags	t
193	3	bin-bags	t
194	8	blueberries	t
195	8	strawberries	t
196	8	satsumas	t
197	8	pineapple	t
198	8	cherries	t
199	8	raddishes	t
200	8	lemons	t
201	8	avocado	t
202	8	parsnip	t
203	8	bananas	t
204	8	green-apples	t
205	8	red-apples	t
206	8	cucumber	t
207	8	lettuce	t
208	8	mushrooms	t
209	8	courgette	t
210	8	beetroot	t
211	8	spinach	t
212	8	water-cress	t
213	8	small-vine-tomatos	t
214	8	brocolli	t
215	8	carrots	t
216	8	cress	t
218	8	yellow-pepper	t
219	8	red-pepper	t
220	8	green-pepper	t
221	8	cauliflower	t
222	8	grapefruit	t
223	8	red-onions	t
224	8	red-grapes	t
225	8	garlic	t
25	11	mintos	t
39	9	smoked-mackerel	t
226	1	pepsi-max	t
227	1	cloudy-diet-lemonade	t
228	1	red-wine	t
229	1	white-wine	t
230	1	diet-cream-soda	t
231	1	fresh-orange-juice	t
232	1	orange-sqsh	t
233	1	blackcurrant-sqsh	t
\.


--
-- Name: items_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('items_seq', 233, true);


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY lists (id, show_all_items, show_list, name, create_date) FROM stdin;
5	t	t	Sat 15th July 16	2016-07-14 22:39:07.861444+00
\.


--
-- Name: lists_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('lists_seq', 5, true);


--
-- Data for Name: shopping_lists; Type: TABLE DATA; Schema: public; Owner: shoplist_write
--

COPY shopping_lists (id, item_id, list_id, priority, price, quantity) FROM stdin;
43	35	5	0	\N	3
44	226	5	0	\N	3
45	228	5	0	\N	1
\.


--
-- Name: shopping_lists_seq; Type: SEQUENCE SET; Schema: public; Owner: shoplist_write
--

SELECT pg_catalog.setval('shopping_lists_seq', 45, true);


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

ALTER TABLE ONLY shopping_lists
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

ALTER TABLE ONLY shopping_lists
    ADD CONSTRAINT item_lists_item_id_fkey FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_lists_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shoplist_write
--

ALTER TABLE ONLY shopping_lists
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
-- Name: shopping_lists_seq; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON SEQUENCE shopping_lists_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE shopping_lists_seq FROM shoplist_write;
GRANT ALL ON SEQUENCE shopping_lists_seq TO shoplist_write;
GRANT SELECT ON SEQUENCE shopping_lists_seq TO shoplist_read;


--
-- Name: shopping_lists; Type: ACL; Schema: public; Owner: shoplist_write
--

REVOKE ALL ON TABLE shopping_lists FROM PUBLIC;
REVOKE ALL ON TABLE shopping_lists FROM shoplist_write;
GRANT ALL ON TABLE shopping_lists TO shoplist_write;
GRANT SELECT ON TABLE shopping_lists TO shoplist_read;


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

