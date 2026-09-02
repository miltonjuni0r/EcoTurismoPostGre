--
-- PostgreSQL database dump
--

\restrict s3BMaKOVwFqZuv2mmK5JHZDvjwmfdI2Zb2YDugCiwiI7EqteRx21McCSrfZDG5X

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-09-02 14:16:58

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
-- TOC entry 6 (class 2615 OID 17384)
-- Name: admin; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA admin;


ALTER SCHEMA admin OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 17385)
-- Name: contabil; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabil;


ALTER SCHEMA contabil OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 17386)
-- Name: site; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA site;


ALTER SCHEMA site OWNER TO postgres;

--
-- TOC entry 865 (class 1247 OID 17388)
-- Name: forma; Type: TYPE; Schema: admin; Owner: postgres
--

CREATE TYPE admin.forma AS ENUM (
    'PIX',
    'BOLETO',
    'CARTAO',
    'A_VISTA'
);


ALTER TYPE admin.forma OWNER TO postgres;

--
-- TOC entry 868 (class 1247 OID 17398)
-- Name: natureza_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.natureza_conta_enum AS ENUM (
    'DEVEDORA',
    'CREDORA'
);


ALTER TYPE contabil.natureza_conta_enum OWNER TO postgres;

--
-- TOC entry 871 (class 1247 OID 17404)
-- Name: tipo_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.tipo_conta_enum AS ENUM (
    'ATIVO',
    'PASSIVO',
    'PATROMONIO_LIQUIDO',
    'RECEITA',
    'DESPESA'
);


ALTER TYPE contabil.tipo_conta_enum OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 17553)
-- Name: nome_pra_codigo(); Type: FUNCTION; Schema: contabil; Owner: postgres
--

CREATE FUNCTION contabil.nome_pra_codigo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 1. Tradução para a conta de DÉBITO
    NEW.conta_debito := CASE 
        WHEN TRIM(NEW.conta_debito) IN ('Bancos - Conta Movimento', 'Bancos') THEN '1.1.02'
        WHEN TRIM(NEW.conta_debito) IN ('Caixa', 'CAIXA') THEN '1.1.01'
        WHEN TRIM(NEW.conta_debito) IN ('Custo das Mercadorias Vendidas', 'CMV') THEN '5.1.01'
        WHEN TRIM(NEW.conta_debito) IN ('Fornecedores a Pagar', 'Fornecedor') THEN '2.1.01'
        WHEN TRIM(NEW.conta_debito) = '' THEN NULL
        ELSE (SELECT codigo FROM plano_contas WHERE LOWER(TRIM(nome_conta)) = LOWER(TRIM(NEW.conta_debito)))
    END;

    -- 2. Tradução para a conta de CRÉDITO
    NEW.conta_credito := CASE 
        WHEN TRIM(NEW.conta_credito) IN ('Bancos - Conta Movimento', 'Bancos') THEN '1.1.02'
        WHEN TRIM(NEW.conta_credito) IN ('Caixa', 'CAIXA') THEN '1.1.01'
        WHEN TRIM(NEW.conta_credito) IN ('Custo das Mercadorias Vendidas', 'CMV') THEN '5.1.01'
        WHEN TRIM(NEW.conta_credito) IN ('Fornecedores a Pagar', 'Fornecedor') THEN '2.1.01'
        WHEN TRIM(NEW.conta_credito) = '' THEN NULL
        ELSE (SELECT codigo FROM plano_contas WHERE LOWER(TRIM(nome_conta)) = LOWER(TRIM(NEW.conta_credito)))
    END;

    RETURN NEW;
END;
$$;


ALTER FUNCTION contabil.nome_pra_codigo() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 17415)
-- Name: pagamentos; Type: TABLE; Schema: admin; Owner: postgres
--

CREATE TABLE admin.pagamentos (
    id_pagamentos integer NOT NULL,
    data_pagamento date NOT NULL,
    forma admin.forma,
    id_reserva integer
);


ALTER TABLE admin.pagamentos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17420)
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE; Schema: admin; Owner: postgres
--

CREATE SEQUENCE admin.pagamentos_id_pagamentos_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE admin.pagamentos_id_pagamentos_seq OWNER TO postgres;

--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 223
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: postgres
--

ALTER SEQUENCE admin.pagamentos_id_pagamentos_seq OWNED BY admin.pagamentos.id_pagamentos;


--
-- TOC entry 224 (class 1259 OID 17421)
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
-- TOC entry 225 (class 1259 OID 17433)
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
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 225
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: postgres
--

ALTER SEQUENCE admin.usuarios_id_usuarios_seq OWNED BY admin.usuarios.id_usuarios;


--
-- TOC entry 231 (class 1259 OID 17536)
-- Name: lancamentos_brutos; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.lancamentos_brutos (
    data date NOT NULL,
    historico text NOT NULL,
    conta_debito character varying(100),
    conta_credito character varying(100),
    valor numeric(10,2)
);


ALTER TABLE contabil.lancamentos_brutos OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17517)
-- Name: plano_contas; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.plano_contas (
    codigo character varying(20) NOT NULL,
    nome_conta character varying(100) NOT NULL,
    tipo character varying(50) NOT NULL,
    natureza character varying(20) NOT NULL
);


ALTER TABLE contabil.plano_contas OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17450)
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
-- TOC entry 227 (class 1259 OID 17459)
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
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 227
-- Name: pacotes_id_pacotes_seq; Type: SEQUENCE OWNED BY; Schema: site; Owner: postgres
--

ALTER SEQUENCE site.pacotes_id_pacotes_seq OWNED BY site.pacotes.id_pacotes;


--
-- TOC entry 228 (class 1259 OID 17460)
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
-- TOC entry 229 (class 1259 OID 17468)
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
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservas_ID_reserva_seq; Type: SEQUENCE OWNED BY; Schema: site; Owner: postgres
--

ALTER SEQUENCE site."reservas_ID_reserva_seq" OWNED BY site.reservas."ID_reserva";


--
-- TOC entry 4791 (class 2604 OID 17469)
-- Name: pagamentos id_pagamentos; Type: DEFAULT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.pagamentos ALTER COLUMN id_pagamentos SET DEFAULT nextval('admin.pagamentos_id_pagamentos_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 17470)
-- Name: usuarios id_usuarios; Type: DEFAULT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.usuarios ALTER COLUMN id_usuarios SET DEFAULT nextval('admin.usuarios_id_usuarios_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 17473)
-- Name: pacotes id_pacotes; Type: DEFAULT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.pacotes ALTER COLUMN id_pacotes SET DEFAULT nextval('site.pacotes_id_pacotes_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 17474)
-- Name: reservas ID_reserva; Type: DEFAULT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas ALTER COLUMN "ID_reserva" SET DEFAULT nextval('site."reservas_ID_reserva_seq"'::regclass);


--
-- TOC entry 4962 (class 0 OID 17415)
-- Dependencies: 222
-- Data for Name: pagamentos; Type: TABLE DATA; Schema: admin; Owner: postgres
--

COPY admin.pagamentos (id_pagamentos, data_pagamento, forma, id_reserva) FROM stdin;
1	2011-02-02	PIX	3
\.


--
-- TOC entry 4964 (class 0 OID 17421)
-- Dependencies: 224
-- Data for Name: usuarios; Type: TABLE DATA; Schema: admin; Owner: postgres
--

COPY admin.usuarios (id_usuarios, usuario, senha, telefone, cpf, permissao) FROM stdin;
2	paulo	12345	3240028922	00000000001	usuario
6	luiz	1234	32991919191	00000000002	admin
\.


--
-- TOC entry 4971 (class 0 OID 17536)
-- Dependencies: 231
-- Data for Name: lancamentos_brutos; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

COPY contabil.lancamentos_brutos (data, historico, conta_debito, conta_credito, valor) FROM stdin;
2026-03-01	Aporte de capital dos sócios	1.1.02	3.1.01	50000.00
2026-03-02	Compra de mercadorias para revenda, a prazo	1.1.04	2.1.01	18000.00
2026-03-03	Pagamento de aluguel do mês	5.1.03	1.1.01	3200.00
2026-03-03	Venda de mercadorias à vista	1.1.01	4.1.01	4500.00
2026-03-03	Baixa do custo da mercadoria vendida	5.1.01	1.1.04	2700.00
2026-03-04	Venda de mercadorias a prazo	1.1.03	4.1.01	6200.00
2026-03-04	Baixa do CMV da venda a prazo	5.1.01	1.1.04	3720.00
2026-03-05	Compra de mercadorias à vista	1.1.04	1.1.02	9000.00
2026-03-05	Pagamento de conta de energia elétrica	5.1.04	1.1.02	850.00
2026-03-06	Recebimento de cliente (venda dia 04)	1.1.02	1.1.03	6200.00
2026-03-07	Pagamento a fornecedor	2.1.01	1.1.02	9000.00
2026-03-08	Venda de mercadorias à vista	1.1.01	4.1.01	5100.00
2026-03-08	Baixa do CMV	5.1.01	1.1.04	3060.00
2026-03-09	Pagamento de salários	5.1.02	1.1.02	7500.00
2026-03-09	Retenção de INSS/FGTS sobre a folha	5.1.02	2.1.03	1650.00
2026-03-10	Pagamento de telefone e internet	5.1.06	1.1.02	320.00
2026-03-10	Compra de mercadorias a prazo	1.1.04	2.1.01	14500.00
2026-03-11	Venda de mercadorias a prazo	1.1.03	4.1.01	8300.00
2026-03-11	Baixa do CMV	5.1.01	1.1.04	4980.00
2026-03-12	Pagamento de tarifas bancárias	5.1.07	1.1.02	95.00
2026-03-12	Combustível para entregas	5.1.08	1.1.01	410.00
2026-03-13	Recebimento de cliente	1.1.02	1.1.03	8300.00
2026-03-14	Venda de mercadorias à vista	1.1.01	4.1.01	3900.00
2026-03-14	Baixa do CMV	5.1.01	1.1.04	2340.00
2026-03-15	Pagamento de água	5.1.05	1.1.02	210.00
2026-03-15	Empréstimo bancário recebido	1.1.02	2.2.01	20000.00
2026-03-16	Compra de veículo para entregas, à vista	1.2.02	1.1.02	22000.00
2026-03-16	Compra de mercadorias a prazo	1.1.04	2.1.01	11200.00
2026-03-17	Venda de mercadorias a prazo	1.1.03	4.1.01	7400.00
2026-03-17	Baixa do CMV	5.1.01	1.1.04	4440.00
2026-03-18	Pagamento a fornecedores	2.1.01	1.1.02	14500.00
2026-03-18	Prestação de serviço de instalação	1.1.02	4.1.02	1800.00
2026-03-19	Venda de mercadorias à vista	1.1.01	4.1.01	4700.00
2026-03-19	Baixa do CMV	5.1.01	1.1.04	2820.00
2026-03-20	Pagamento de parcela do empréstimo	2.2.01	1.1.02	2000.00
2026-03-20	Material de escritório	5.1.09	1.1.01	180.00
2026-03-21	Recebimento de cliente	1.1.02	1.1.03	7400.00
2026-03-21	Venda de mercadorias a prazo	1.1.03	4.1.01	5600.00
2026-03-21	Baixa do CMV	5.1.01	1.1.04	3360.00
2026-03-22	Compra de mercadorias à vista	1.1.04	1.1.01	6000.00
2026-03-23	Pagamento de tarifas bancárias	5.1.07	1.1.02	88.00
2026-03-24	Venda de mercadorias à vista	1.1.01	4.1.01	3300.00
2026-03-24	Baixa do CMV	5.1.01	1.1.04	1980.00
2026-03-25	Pagamento de impostos (Simples Nacional)	2.1.03	1.1.02	2450.00
2026-03-25	Venda de mercadorias à vista	1.1.01	4.1.01	3300.00
2026-03-25	Baixa do CMV	5.1.01	1.1.04	1980.00
2026-03-26	Adiantamento de aluguel	5.1.03	1.1.02	\N
2026-03-27	Compra de mercadorias a prazo	1.1.04	2.1.01	9800.00
2026-03-28	Venda de mercadorias a prazo	1.1.03	4.1.01	6100.00
2026-03-28	Baixa do CMV	5.1.01	1.1.04	3660.00
2026-03-29	Pagamento de salários	5.1.02	1.1.02	7500.00
2026-03-30	Recebimento de cliente	1.1.02	1.1.03	5600.00
2026-03-31	Despesas diversas do mês	5.1.09	\N	150.00
\.


--
-- TOC entry 4970 (class 0 OID 17517)
-- Dependencies: 230
-- Data for Name: plano_contas; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

COPY contabil.plano_contas (codigo, nome_conta, tipo, natureza) FROM stdin;
1.1.01	Caixa	Ativo	Devedora
1.1.02	Bancos - Conta Movimento	Ativo	Devedora
1.1.03	Clientes a Receber	Ativo	Devedora
1.1.04	Estoque de Mercadorias	Ativo	Devedora
1.2.01	Móveis e Utensílios	Ativo	Devedora
1.2.02	Veículos	Ativo	Devedora
2.1.01	Fornecedores a Pagar	Passivo	Credora
2.1.02	Salários a Pagar	Passivo	Credora
2.1.03	Impostos a Recolher	Passivo	Credora
2.2.01	Empréstimos Bancários (LP)	Passivo	Credora
3.1.01	Capital Social	Patrimônio Líquido	Credora
3.1.02	Lucros/Prejuízos Acumulados	Patrimônio Líquido	Credora
4.1.01	Receita de Vendas	Receita	Credora
4.1.02	Receita de Serviços	Receita	Credora
5.1.01	Custo das Mercadorias Vendidas	Despesa	Devedora
5.1.02	Despesas com Salários	Despesa	Devedora
5.1.03	Despesas com Aluguel	Despesa	Devedora
5.1.04	Despesas com Energia Elétrica	Despesa	Devedora
5.1.05	Despesas com Água	Despesa	Devedora
5.1.06	Despesas com Telefone/Internet	Despesa	Devedora
5.1.07	Despesas Bancárias/Tarifas	Despesa	Devedora
5.1.08	Despesas com Combustível	Despesa	Devedora
5.1.09	Despesas Diversas	Despesa	Devedora
\.


--
-- TOC entry 4966 (class 0 OID 17450)
-- Dependencies: 226
-- Data for Name: pacotes; Type: TABLE DATA; Schema: site; Owner: postgres
--

COPY site.pacotes (id_pacotes, nome, destino, "preco ") FROM stdin;
1	Saco do Mamangua	RJ	299.00
2	Serra do Cipo	MG	299.00
\.


--
-- TOC entry 4968 (class 0 OID 17460)
-- Dependencies: 228
-- Data for Name: reservas; Type: TABLE DATA; Schema: site; Owner: postgres
--

COPY site.reservas ("ID_reserva", data_reserva, status, "FK_Usuario", "FK_local") FROM stdin;
3	2011-01-01	teste	2	1
\.


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 223
-- Name: pagamentos_id_pagamentos_seq; Type: SEQUENCE SET; Schema: admin; Owner: postgres
--

SELECT pg_catalog.setval('admin.pagamentos_id_pagamentos_seq', 1, true);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 225
-- Name: usuarios_id_usuarios_seq; Type: SEQUENCE SET; Schema: admin; Owner: postgres
--

SELECT pg_catalog.setval('admin.usuarios_id_usuarios_seq', 6, true);


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 227
-- Name: pacotes_id_pacotes_seq; Type: SEQUENCE SET; Schema: site; Owner: postgres
--

SELECT pg_catalog.setval('site.pacotes_id_pacotes_seq', 2, true);


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservas_ID_reserva_seq; Type: SEQUENCE SET; Schema: site; Owner: postgres
--

SELECT pg_catalog.setval('site."reservas_ID_reserva_seq"', 3, true);


--
-- TOC entry 4798 (class 2606 OID 17476)
-- Name: pagamentos pagamentos_pkey; Type: CONSTRAINT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.pagamentos
    ADD CONSTRAINT pagamentos_pkey PRIMARY KEY (id_pagamentos);


--
-- TOC entry 4800 (class 2606 OID 17478)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuarios);


--
-- TOC entry 4808 (class 2606 OID 17525)
-- Name: plano_contas ID_codigo; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.plano_contas
    ADD CONSTRAINT "ID_codigo" PRIMARY KEY (codigo);


--
-- TOC entry 4802 (class 2606 OID 17484)
-- Name: pacotes pacotes_pkey; Type: CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.pacotes
    ADD CONSTRAINT pacotes_pkey PRIMARY KEY (id_pacotes);


--
-- TOC entry 4806 (class 2606 OID 17486)
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY ("ID_reserva");


--
-- TOC entry 4796 (class 1259 OID 17514)
-- Name: fki_id_reserva; Type: INDEX; Schema: admin; Owner: postgres
--

CREATE INDEX fki_id_reserva ON admin.pagamentos USING btree (id_reserva);


--
-- TOC entry 4803 (class 1259 OID 17487)
-- Name: fki_FK_Usuario; Type: INDEX; Schema: site; Owner: postgres
--

CREATE INDEX "fki_FK_Usuario" ON site.reservas USING btree ("FK_Usuario");


--
-- TOC entry 4804 (class 1259 OID 17488)
-- Name: fki_FK_local; Type: INDEX; Schema: site; Owner: postgres
--

CREATE INDEX "fki_FK_local" ON site.reservas USING btree ("FK_local");


--
-- TOC entry 4814 (class 2620 OID 17554)
-- Name: lancamentos_brutos contas; Type: TRIGGER; Schema: contabil; Owner: postgres
--

CREATE TRIGGER contas BEFORE INSERT ON contabil.lancamentos_brutos FOR EACH ROW EXECUTE FUNCTION contabil.nome_pra_codigo();


--
-- TOC entry 4809 (class 2606 OID 17509)
-- Name: pagamentos id_reserva; Type: FK CONSTRAINT; Schema: admin; Owner: postgres
--

ALTER TABLE ONLY admin.pagamentos
    ADD CONSTRAINT id_reserva FOREIGN KEY (id_reserva) REFERENCES site.reservas("ID_reserva");


--
-- TOC entry 4812 (class 2606 OID 17560)
-- Name: lancamentos_brutos fk_conta_credito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos_brutos
    ADD CONSTRAINT fk_conta_credito FOREIGN KEY (conta_credito) REFERENCES contabil.plano_contas(codigo);


--
-- TOC entry 4813 (class 2606 OID 17555)
-- Name: lancamentos_brutos fk_conta_debito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos_brutos
    ADD CONSTRAINT fk_conta_debito FOREIGN KEY (conta_debito) REFERENCES contabil.plano_contas(codigo);


--
-- TOC entry 4810 (class 2606 OID 17499)
-- Name: reservas FK_Usuario; Type: FK CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT "FK_Usuario" FOREIGN KEY ("FK_Usuario") REFERENCES admin.usuarios(id_usuarios);


--
-- TOC entry 4811 (class 2606 OID 17504)
-- Name: reservas FK_local; Type: FK CONSTRAINT; Schema: site; Owner: postgres
--

ALTER TABLE ONLY site.reservas
    ADD CONSTRAINT "FK_local" FOREIGN KEY ("FK_local") REFERENCES site.pacotes(id_pacotes);


-- Completed on 2026-09-02 14:16:59

--
-- PostgreSQL database dump complete
--

\unrestrict s3BMaKOVwFqZuv2mmK5JHZDvjwmfdI2Zb2YDugCiwiI7EqteRx21McCSrfZDG5X

