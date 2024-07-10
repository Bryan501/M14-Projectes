--
-- PostgreSQL database dump
--

/*
SET statement_timeout = 0;
SET cliecodnt_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET cliecodnt_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;
*/

--
-- Name: cliecodnte; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

/*ALTER TABLE OFICINES drop CONSTRAINT FK_OFICINA_DIRECTOR;
ALTER TABLE REP_VENDES drop CONSTRAINT FK_REP_VENDES_CAP;
DROP TABLE COMANDES;
DROP TABLE PRODUCTES;
DROP TABLE CLIENTS;
DROP TABLE REP_VENDES;
DROP TABLE OFICINES;
*/

CREATE TABLE PRODUCTES (
    id_fabricant character(3),
    id_producte character(5),
    descripcio character varying(20) NOT NULL,
    preu numeric(7,2) NOT NULL,
    estoc integer,
    CONSTRAINT PK_PRODUCTE_FP PRIMARY KEY(id_fabricant,id_producte)
	);

--
-- Name: OFICINES; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--


CREATE TABLE OFICINES (
    oficina smallint CONSTRAINT PK_OFICINES_OFICINA PRIMARY KEY,
    ciutat character varying(15) NOT NULL,
    regio character varying(10) NOT NULL,
    director smallint,
    objectiu numeric(9,2),
    vendes numeric(9,2)
);

--
-- Name: REP_VENDES; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE REP_VENDES (
    num_empl smallint CONSTRAINT PK_REP_VENDES_NUM_EMPL PRIMARY KEY,
    nom character varying(30) NOT NULL,
    edat smallint,
    oficina_rep smallint,
    carrec character varying(20),
    data_contracte date NOT NULL,
    cap smallint,
    quota numeric(8,2),
    vendes numeric(8,2),
    CONSTRAINT CK_REP_VENDES_NOM CHECK(NOM = INITCAP(NOM)),
	CONSTRAINT CK_REP_VENDES_EDAT CHECK(EDAT>0),
	CONSTRAINT CK_REP_VENDES_VENDES CHECK(VENDES>0),
	CONSTRAINT CK_REP_VENDES_QUOTA CHECK(QUOTA>0),
	CONSTRAINT FK_REP_VENDES_OFICINA_REP FOREIGN KEY(oficina_rep) REFERENCES OFICINES(oficina)	
);

/*
ALTER TABLE public.CLIENTS OWNER TO postgres;
*/

CREATE TABLE CLIENTS (
    num_clie smallint CONSTRAINT PK_CLIENTS_NUM_CLIE PRIMARY KEY,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL,
    limit_credit numeric(8,2),
    CONSTRAINT FK_CLIENTS_REP_CLIE FOREIGN KEY(REP_CLIE) REFERENCES REP_VENDES(NUM_EMPL)
);


--
-- Name: COMANDES; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE COMANDES (
    num_comanda integer CONSTRAINT PK_COMANDA_NUM_COMANDA PRIMARY KEY ,
    data date NOT NULL,
    clie smallint NOT NULL,
    rep smallint,
    fabricant character(3) NOT NULL,
    producte character varying(5) NOT NULL,
    quantitat smallint NOT NULL,
    import numeric(7,2) NOT NULL,
--    CONSTRAINT FK_COMANDES_FP FOREIGN KEY(FABRICANT,PRODUCTE) REFERENCES PRODUCTES(ID_FABRICANT,ID_PRODUCTE),
	CONSTRAINT FK_COMANDES_REP FOREIGN KEY(REP) REFERENCES REP_VENDES(NUM_EMPL),
	CONSTRAINT FK_COMANDES_CLIE FOREIGN KEY(CLIE) REFERENCES CLIENTS(NUM_CLIE)
);

/*
ALTER TABLE public.COMANDES OWNER TO postgres;
*/


--
-- Data for Name: PRODUCTES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY PRODUCTES (id_fabricant, id_producte, descripcio, preu, estoc) FROM stdin;
rei	2a45c	V Stago Trinquet	79.00	210
aci	4100y	Extractor	2750.00	25
qsa	xk47	Reductor	355.00	38
bic	41672	Plate	180.00	0
imm	779c	Riosta 2-Tm	1875.00	9
aci	41003	Article Tipus 3	107.00	207
aci	41004	Article Tipus 4	117.00	139
bic	41003	Manovella	652.00	3
imm	887p	Pern Riosta	250.00	24
qsa	xk48	Reductor	134.00	203
rei	2a44l	Frontissa Esq.	4500.00	12
fea	112	Coberta	148.00	115
imm	887h	Suport Riosta	54.00	223
bic	41089	Retn	225.00	78
aci	41001	Article Tipus 1	55.00	277
imm	775c	Riosta 1-Tm	1425.00	5
aci	4100z	Muntador	2500.00	28
qsa	xk48a	Reductor	117.00	37
aci	41002	Article Tipus 2	76.00	167
rei	2a44r	Frontissa Dta.	4500.00	12
imm	773c	Riosta 1/2-Tm	975.00	28
aci	4100x	Peu de rei	25.00	37
fea	114	Bancada Motor	243.00	15
imm	887x	Retenidor Riosta	475.00	32
rei	2a44g	Passador Frontissa	350.00	14
\.


--
-- Data for Name: OFICINES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY OFICINES (oficina, ciutat, regio, director, objectiu, vendes) FROM stdin;
22	Denver	Oest	108	300000.00	186042.00
11	New York	Est	106	575000.00	692637.00
12	Chicago	Est	104	800000.00	735042.00
13	Atlanta	Est	105	350000.00	367911.00
21	Los Angeles	Oest	108	725000.00	835915.00
\.


--
-- Data for Name: REP_VENDES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY REP_VENDES (num_empl, nom, edat, oficina_rep, carrec, data_contracte, cap, quota, vendes) FROM stdin;
105	Bill Adams	37	13	Representant Vendes	1988-02-12	104	350000.00	367911.00
109	Mary Jones	31	11	Representant Vendes	2022-10-12	106	300000.00	392725.00
102	Sue Smith	48	21	Representant Vendes	1986-12-10	108	350000.00	474050.00
106	Sam Clark	52	11	VP Vendes	1988-06-14	\N	275000.00	299912.00
104	Bob Smith	33	12	Dir Vendes	1987-05-19	106	200000.00	142594.00
101	Dan Roberts	45	12	Representant Vendes	1986-10-20	104	300000.00	305673.00
110	Tom Snyder	41	\N	Representant Vendes	2023-02-13	101	\N	75985.00
108	Larry Fitch	62	21	Dir Vendes	2022-10-12	106	350000.00	361865.00
103	Paul Cruz	29	12	Representant Vendes	1987-03-01	104	275000.00	286775.00
107	Nancy Angelli	49	22	Representant Vendes	1988-11-14	108	300000.00	186042.00
\.


COPY CLIENTS (num_clie, empresa, rep_clie, limit_credit) FROM stdin;
2111	JCP Inc.	103	50000.00
2102	First Corp.	101	65000.00
2103	Acme Mfg.	105	50000.00
2123	Carter & Sons	102	40000.00
2107	Ace International	110	35000.00
2115	Smithson Corp.	101	20000.00
2101	Jones Mfg.	106	65000.00
2112	Zetacorp	108	50000.00
2121	QMA Assoc.	103	45000.00
2114	Orion Corp	102	20000.00
2124	Peter Brothers	107	40000.00
2108	Holm & Landis	109	55000.00
2117	J.P. Sinclair	106	35000.00
2122	Three-Way Lines	105	30000.00
2120	Rico Enterprises	102	50000.00
2106	Fred Lewis Corp.	102	65000.00
2119	Solomon Inc.	109	25000.00
2118	Midwest Systems	108	60000.00
2113	Ian & Schmidt	104	20000.00
2109	Chen Associates	103	25000.00
2105	AAA Investments	101	45000.00
\.






--
-- Data for Name: COMANDES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY COMANDES (num_comanda, data, clie, rep, fabricant, producte, quantitat, import) FROM stdin;
112961	2022-12-17	2117	106	rei	2a44l	7	31500.00
113012	2023-02-11	2111	105	aci	41003	35	3745.00
112989	2023-02-03	2101	106	fea	114	6	1458.00
113051	2023-04-10	2118	108	qsa	k47	4	1420.00
112968	2022-10-12	2102	101	aci	41004	34	3978.00
110036	2023-02-25	2107	110	aci	4100z	9	22500.00
113045	2023-04-02	2112	108	rei	2a44r	10	45000.00
112963	2022-12-17	2103	105	aci	41004	28	3276.00
113013	2023-02-14	2118	108	bic	41003	1	652.00
113058	2023-04-23	2108	109	fea	112	10	1480.00
112997	2023-02-08	2124	107	bic	41003	1	652.00
112983	2022-12-27	2103	105	aci	41004	6	702.00
113024	2023-02-20	2114	108	qsa	xk47	20	7100.00
113062	2023-04-24	2124	107	fea	114	10	2430.00
112979	2022-10-12	2114	102	aci	4100z	6	15000.00
113027	2023-02-22	2103	105	aci	41002	54	4104.00
113007	2023-02-08	2112	108	imm	773c	3	2925.00
113069	2023-03-02	2109	107	imm	775c	22	31350.00
113034	2023-02-22	2107	110	rei	2a45c	8	632.00
112992	2022-11-04	2118	108	aci	41002	10	760.00
112975	2022-12-12	2111	103	rei	2a44g	6	2100.00
113055	2023-04-15	2108	101	aci	4100x	6	150.00
113048	2023-04-10	2120	102	imm	779c	2	3750.00
112993	2022-01-04	2106	102	rei	2a45c	24	1896.00
113065	2023-04-27	2106	102	qsa	xk47	6	2130.00
113003	2023-02-25	2108	109	imm	779c	3	5625.00
113049	2023-04-10	2118	108	qsa	xk47	2	776.00
112987	2022-12-31	2103	105	aci	4100y	11	27500.00
113057	2023-04-18	2111	103	aci	4100x	24	600.00
113042	2023-04-02	2113	101	rei	2a44r	5	22500.00
\.




ALTER TABLE ONLY OFICINES ADD CONSTRAINT FK_OFICINA_DIRECTOR FOREIGN KEY(DIRECTOR) REFERENCES REP_VENDES(NUM_EMPL);
ALTER TABLE ONLY REP_VENDES ADD CONSTRAINT FK_REP_VENDES_CAP FOREIGN KEY(CAP) REFERENCES REP_VENDES(NUM_EMPL);



--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

/*
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
*/


--
-- Name: cliecodnte; Type: ACL; Schema: public; Owner: postgres
--

/*
REVOKE ALL ON TABLE cliecodnte FROM PUBLIC;
REVOKE ALL ON TABLE cliecodnte FROM postgres;
GRANT ALL ON TABLE cliecodnte TO postgres;
GRANT SELECT ON TABLE cliecodnte TO PUBLIC;
*/


--
-- Name: OFICINES; Type: ACL; Schema: public; Owner: postgres
--

/*
REVOKE ALL ON TABLE OFICINES FROM PUBLIC;
REVOKE ALL ON TABLE OFICINES FROM postgres;
GRANT ALL ON TABLE OFICINES TO postgres;
GRANT SELECT ON TABLE OFICINES TO PUBLIC;
*/


--
-- Name: COMANDES; Type: ACL; Schema: public; Owner: postgres
--

/*
REVOKE ALL ON TABLE COMANDES FROM PUBLIC;
REVOKE ALL ON TABLE COMANDES FROM postgres;
GRANT ALL ON TABLE COMANDES TO postgres;
GRANT SELECT ON TABLE COMANDES TO PUBLIC;
*/


--
-- Name: PRODUCTES; Type: ACL; Schema: public; Owner: postgres
--

/*
REVOKE ALL ON TABLE PRODUCTES FROM PUBLIC;
REVOKE ALL ON TABLE PRODUCTES FROM postgres;
GRANT ALL ON TABLE PRODUCTES TO postgres;
GRANT SELECT ON TABLE PRODUCTES TO PUBLIC;
*/


--
-- Name: REP_VENDES; Type: ACL; Schema: public; Owner: postgres
--

/*
REVOKE ALL ON TABLE REP_VENDES FROM PUBLIC;
REVOKE ALL ON TABLE REP_VENDES FROM postgres;
GRANT ALL ON TABLE REP_VENDES TO postgres;
GRANT SELECT ON TABLE REP_VENDES TO PUBLIC;
*/


--
-- PostgreSQL database dump complete
--

