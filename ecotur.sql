--
-- PostgreSQL database dump
--

\restrict 8gMozuNmtgXHmW8ZEpKxS9DzarS3nPZFYRzsWDucX86K4OpwLu39bYfbr83k4Bv

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-09-02 15:59:40

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 24934)
-- Name: admin; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA admin;


ALTER SCHEMA admin OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 24935)
-- Name: contabil; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabil;


ALTER SCHEMA contabil OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 24936)
-- Name: site; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA site;


ALTER SCHEMA site OWNER TO postgres;

--
-- TOC entry 862 (class 1247 OID 24938)
-- Name: forma; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.forma AS ENUM (
    'PIX',
    'BOLETO',
    'CARTAO',
    'A_VISTA'
);


ALTER TYPE contabil.forma OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 24953)
-- Name: usuarios; Type: TABLE; Schema: admin; Owner: postgres
--

CREATE TABLE admin.usuarios (
    id_usuarios integer NOT NULL,
    usuario character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL,
    cpf character varying(20) NOT NULL,
    permissao character varying(20) DEFAULT 'usuario'::character varying NOT NULL
);


ALTER TABLE admin.usuarios OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24965)
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE; Schema: admin; Owner: postgres
--

CREATE SEQUENCE admin.usuarios_id_usuarios_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE admin.usuarios_id_usuarios_seq OWNER TO postgres;

--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 225
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: postgres
--

ALTER SEQUENCE admin.usuarios_id_usuarios_seq OWNED BY admin.usuarios.id_usuarios;


--
-- TOC entry 222 (class 1259 OID 24947)
-- Name: pagamentos; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.pagamentos (
    id_pagamentos integer NOT NULL,
    data_pagamento date NOT NULL,
    forma contabil.forma,
    id_reserva integer
);


ALTER TABLE contabil.pagamentos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24952)
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE; Schema: contabil; Owner: postgres
--

CREATE SEQUENCE contabil.pagamentos_id_pagamentos_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabil.pagamentos_id_pagamentos_seq OWNER TO postgres;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 223
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE OWNED BY; Schema: contabil; Owner: postgres
--

ALTER SEQUENCE contabil.pagamentos_id_pagamentos_seq OWNED BY contabil.pagamentos.id_pagamentos;


--
-- TOC entry 226 (class 1259 OID 24966)
-- Name: pacotes; Type: TABLE; Schema: site; Owner: postgres
--

CREATE TABLE site.pacotes (
    id_pacotes integer NOT NULL,
    nome character varying(255) NOT NULL,
    destino character varying(255) NOT NULL,
    "preco " numeric(13,2) NOT NULL
);


ALTER TABLE site.pacotes OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24975)
-- Name: pacotes_id_pacotes_seq; Type: SEQUENCE; Schema: site; Owner: postgres
--

CREATE SEQUENCE site.pacotes_id_pacotes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE site.pacotes_id_pacotes_seq OWNER TO postgres;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 227
-- Name: pacotes_id_pacotes_seq; Type: SEQUENCE OWNED BY; Schema: site; Owner: postgres
--

ALTER SEQUENCE site.pacotes_id_pacotes_seq OWNED BY site.pacotes.id_pacotes;


--
-- TOC entry 228 (class 1259 OID 24976)
-- Name: reservas; Type: TABLE; Schema: site; Owner: postgres
--

CREATE TABLE site.reservas (
    "ID_reserva" integer NOT NULL,
    data_reserva date NOT NULL,
    status character varying(255) NOT NULL,
    "FK_Usuario" integer NOT NULL,
    "FK_local" integer NOT NULL
);


ALTER TABLE site.reservas OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24984)
-- Name: reservas_ID_reserva_seq; Type: SEQUENCE; Schema: site; Owner: postgres
--

CREATE SEQUENCE site."reservas_ID_reserva_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE site."reservas_ID_reserva_seq" OWNER TO postgres;

--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservas_ID_reserva_seq; Type: SEQUENCE OWNED BY; Schema: site; Owner: postgres
--

ALTER SEQUENCE site."reservas_ID_reserva_seq" OWNED BY site.reservas."ID_reserva";


--
-- TOC entry 4878 (class 2604 OID 24986)
-- Name: usuarios id_usuarios; Type: DEFAULT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.usuarios ALTER COLUMN id_usuarios SET DEFAULT nextval('admin.usuarios_id_usuarios_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 24985)
-- Name: pagamentos id_pagamentos; Type: DEFAULT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.pagamentos ALTER COLUMN id_pagamentos SET DEFAULT nextval('contabil.pagamentos_id_pagamentos_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 24987)
-- Name: pacotes id_pacotes; Type: DEFAULT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.pacotes ALTER COLUMN id_pacotes SET DEFAULT nextval('site.pacotes_id_pacotes_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 24988)
-- Name: reservas ID_reserva; Type: DEFAULT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas ALTER COLUMN "ID_reserva" SET DEFAULT nextval('site."reservas_ID_reserva_seq"'::regclass);


--
-- TOC entry 5045 (class 0 OID 24953)
-- Dependencies: 224
-- Data for Name: usuarios; Type: TABLE DATA; Schema: admin; Owner: postgres
--

COPY admin.usuarios (id_usuarios, usuario, senha, telefone, cpf, permissao) FROM stdin;
2	paulo	12345	3240028922	00000000001	usuario
6	luiz	1234	32991919191	00000000002	admin
\.


--
-- TOC entry 5043 (class 0 OID 24947)
-- Dependencies: 222
-- Data for Name: pagamentos; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

COPY contabil.pagamentos (id_pagamentos, data_pagamento, forma, id_reserva) FROM stdin;
1	2011-02-02	PIX	3
\.


--
-- TOC entry 5047 (class 0 OID 24966)
-- Dependencies: 226
-- Data for Name: pacotes; Type: TABLE DATA; Schema: site; Owner: postgres
--

COPY site.pacotes (id_pacotes, nome, destino, "preco ") FROM stdin;
1	Saco do Mamangua	RJ	299.00
2	Serra do Cipo	MG	299.00
\.


--
-- TOC entry 5049 (class 0 OID 24976)
-- Dependencies: 228
-- Data for Name: reservas; Type: TABLE DATA; Schema: site; Owner: postgres
--

COPY site.reservas ("ID_reserva", data_reserva, status, "FK_Usuario", "FK_local") FROM stdin;
3	2011-01-01	teste	2	1
\.


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 225
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE SET; Schema: admin; Owner: postgres
--

SELECT pg_catalog.setval('admin.usuarios_id_usuarios_seq', 6, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 223
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE SET; Schema: contabil; Owner: postgres
--

SELECT pg_catalog.setval('contabil.pagamentos_id_pagamentos_seq', 1, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 227
-- Name: pacotes_id_pacotes_seq; Type: SEQUENCE SET; Schema: site; Owner: postgres
--

SELECT pg_catalog.setval('site.pacotes_id_pacotes_seq', 2, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservas_ID_reserva_seq; Type: SEQUENCE SET; Schema: site; Owner: postgres
--

SELECT pg_catalog.setval('site."reservas_ID_reserva_seq"', 3, true);


--
-- TOC entry 4886 (class 2606 OID 24992)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuarios);


--
-- TOC entry 4884 (class 2606 OID 24990)
-- Name: pagamentos pagamentos_pkey; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.pagamentos
    ADD CONSTRAINT pagamentos_pkey PRIMARY KEY (id_pagamentos);


--
-- TOC entry 4888 (class 2606 OID 24994)
-- Name: pacotes pacotes_pkey; Type: CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.pacotes
    ADD CONSTRAINT pacotes_pkey PRIMARY KEY (id_pacotes);


--
-- TOC entry 4892 (class 2606 OID 24996)
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY ("ID_reserva");


--
-- TOC entry 4882 (class 1259 OID 24997)
-- Name: fki_id_reserva; Type: INDEX; Schema: contabil; Owner: postgres
--

CREATE INDEX fki_id_reserva ON contabil.pagamentos USING btree (id_reserva);


--
-- TOC entry 4889 (class 1259 OID 24998)
-- Name: fki_FK_Usuario; Type: INDEX; Schema: site; Owner: postgres
--

CREATE INDEX "fki_FK_Usuario" ON site.reservas USING btree ("FK_Usuario");


--
-- TOC entry 4890 (class 1259 OID 24999)
-- Name: fki_FK_local; Type: INDEX; Schema: site; Owner: postgres
--

CREATE INDEX "fki_FK_local" ON site.reservas USING btree ("FK_local");


--
-- TOC entry 4893 (class 2606 OID 25000)
-- Name: pagamentos id_reserva; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.pagamentos
    ADD CONSTRAINT id_reserva FOREIGN KEY (id_reserva) REFERENCES site.reservas("ID_reserva");


--
-- TOC entry 4894 (class 2606 OID 25005)
-- Name: reservas FK_Usuario; Type: FK CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT "FK_Usuario" FOREIGN KEY ("FK_Usuario") REFERENCES admin.usuarios(id_usuarios);


--
-- TOC entry 4895 (class 2606 OID 25010)
-- Name: reservas FK_local; Type: FK CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT "FK_local" FOREIGN KEY ("FK_local") REFERENCES site.pacotes(id_pacotes);


-- Completed on 2026-09-02 15:59:41

--
-- PostgreSQL database dump complete
--

\unrestrict 8gMozuNmtgXHmW8ZEpKxS9DzarS3nPZFYRzsWDucX86K4OpwLu39bYfbr83k4Bv

