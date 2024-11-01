--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4 (Debian 15.4-2.pgdg120+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: notify_slot_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_slot_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        PERFORM pg_notify('slot_change', json_build_object(
          'area_id', NEW."AreaID",
          'is_busy', NEW."Busy"
        )::text);
        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.notify_slot_change() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Areas" (
    "idAreas" integer NOT NULL,
    "AreaName" character varying(45) NOT NULL,
    "CityID" integer NOT NULL
);


ALTER TABLE public."Areas" OWNER TO postgres;

--
-- Name: Areas_idAreas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Areas_idAreas_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Areas_idAreas_seq" OWNER TO postgres;

--
-- Name: Areas_idAreas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Areas_idAreas_seq" OWNED BY public."Areas"."idAreas";


--
-- Name: Cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cars" (
    "idCars" integer NOT NULL,
    "RegistrationID" character varying(11) NOT NULL,
    "Model" character varying(45) NOT NULL,
    "OwnerID" integer NOT NULL
);


ALTER TABLE public."Cars" OWNER TO postgres;

--
-- Name: Cars_idCars_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Cars_idCars_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Cars_idCars_seq" OWNER TO postgres;

--
-- Name: Cars_idCars_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Cars_idCars_seq" OWNED BY public."Cars"."idCars";


--
-- Name: Cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cities" (
    "idCities" integer NOT NULL,
    "CityName" character varying(45) NOT NULL,
    "FullAddress" character varying(255) NOT NULL,
    "pictureUrl" character varying(255)
);


ALTER TABLE public."Cities" OWNER TO postgres;

--
-- Name: Cities_idCities_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Cities_idCities_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Cities_idCities_seq" OWNER TO postgres;

--
-- Name: Cities_idCities_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Cities_idCities_seq" OWNED BY public."Cities"."idCities";


--
-- Name: Gates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gates" (
    "idGates" integer NOT NULL,
    "Entrance" boolean DEFAULT false NOT NULL,
    "Fault" boolean DEFAULT false NOT NULL,
    "CityID" integer NOT NULL,
    "CameraIP" character varying(15) NOT NULL,
    "GateIP" character varying(15) NOT NULL
);


ALTER TABLE public."Gates" OWNER TO postgres;

--
-- Name: Gates_idGates_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gates_idGates_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Gates_idGates_seq" OWNER TO postgres;

--
-- Name: Gates_idGates_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gates_idGates_seq" OWNED BY public."Gates"."idGates";


--
-- Name: Notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Notifications" (
    id integer NOT NULL,
    "userId" integer,
    message text NOT NULL,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    title text
);


ALTER TABLE public."Notifications" OWNER TO postgres;

--
-- Name: Notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Notifications_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notifications_id_seq" OWNER TO postgres;

--
-- Name: Notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Notifications_id_seq" OWNED BY public."Notifications".id;


--
-- Name: ParkingLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingLog" (
    "idParkingLog" integer NOT NULL,
    "CarID" integer NOT NULL,
    "SlotID" integer,
    "Entrance" timestamp(6) with time zone NOT NULL,
    "Exit" timestamp(6) with time zone,
    "Violation" boolean NOT NULL,
    "ReservationID" integer,
    "NeedToExitBy" timestamp(6) with time zone
);


ALTER TABLE public."ParkingLog" OWNER TO postgres;

--
-- Name: ParkingLog_idParkingLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ParkingLog_idParkingLog_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ParkingLog_idParkingLog_seq" OWNER TO postgres;

--
-- Name: ParkingLog_idParkingLog_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ParkingLog_idParkingLog_seq" OWNED BY public."ParkingLog"."idParkingLog";


--
-- Name: Reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reservations" (
    "idReservation" integer NOT NULL,
    "UserID" integer NOT NULL,
    "CarID" integer NOT NULL,
    "SlotID" integer NOT NULL,
    "ReservationStart" timestamp(6) with time zone NOT NULL,
    "ReservationEnd" timestamp(6) with time zone NOT NULL,
    "Status" character varying(20) DEFAULT 'pending'::character varying NOT NULL
);


ALTER TABLE public."Reservations" OWNER TO postgres;

--
-- Name: Reservations_idReservation_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Reservations_idReservation_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Reservations_idReservation_seq" OWNER TO postgres;

--
-- Name: Reservations_idReservation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Reservations_idReservation_seq" OWNED BY public."Reservations"."idReservation";


--
-- Name: Slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Slots" (
    "idSlots" integer NOT NULL,
    "Busy" boolean DEFAULT false,
    "BorderRight" integer NOT NULL,
    "Active" boolean DEFAULT true,
    "Fault" boolean DEFAULT false,
    "AreaID" integer NOT NULL,
    "CameraIP" character varying(15),
    "SlotIP" character varying(15)
);


ALTER TABLE public."Slots" OWNER TO postgres;

--
-- Name: Slots_idSlots_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Slots_idSlots_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Slots_idSlots_seq" OWNER TO postgres;

--
-- Name: Slots_idSlots_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Slots_idSlots_seq" OWNED BY public."Slots"."idSlots";


--
-- Name: SubscriptionPlans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SubscriptionPlans" (
    "idSubscriptionPlans" integer NOT NULL,
    "Name" character varying(45) NOT NULL,
    "Price" numeric(10,2) NOT NULL,
    "MaxCars" integer NOT NULL,
    "Features" text[],
    "MaxActiveReservations" integer DEFAULT 0 NOT NULL,
    "StripePriceId" character varying(255)
);


ALTER TABLE public."SubscriptionPlans" OWNER TO postgres;

--
-- Name: SubscriptionPlans_idSubscriptionPlans_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SubscriptionPlans_idSubscriptionPlans_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SubscriptionPlans_idSubscriptionPlans_seq" OWNER TO postgres;

--
-- Name: SubscriptionPlans_idSubscriptionPlans_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SubscriptionPlans_idSubscriptionPlans_seq" OWNED BY public."SubscriptionPlans"."idSubscriptionPlans";


--
-- Name: UserNotifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserNotifications" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "notificationId" integer NOT NULL,
    "isRead" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."UserNotifications" OWNER TO postgres;

--
-- Name: UserNotifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."UserNotifications_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."UserNotifications_id_seq" OWNER TO postgres;

--
-- Name: UserNotifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."UserNotifications_id_seq" OWNED BY public."UserNotifications".id;


--
-- Name: UserSubscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserSubscriptions" (
    "idUserSubscriptions" integer NOT NULL,
    "UserID" integer NOT NULL,
    "SubscriptionPlanID" integer NOT NULL,
    "StartDate" date NOT NULL,
    "EndDate" date NOT NULL,
    "Status" character varying(20) NOT NULL,
    "StripeSessionId" text,
    "SubscriptionId" character varying(255)
);


ALTER TABLE public."UserSubscriptions" OWNER TO postgres;

--
-- Name: UserSubscriptions_idUserSubscriptions_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."UserSubscriptions_idUserSubscriptions_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."UserSubscriptions_idUserSubscriptions_seq" OWNER TO postgres;

--
-- Name: UserSubscriptions_idUserSubscriptions_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."UserSubscriptions_idUserSubscriptions_seq" OWNED BY public."UserSubscriptions"."idUserSubscriptions";


--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    "idUsers" integer NOT NULL,
    "persId" character varying(9) NOT NULL,
    "FirstName" character varying(40) NOT NULL,
    "LastName" character varying(45) NOT NULL,
    "Phone" character varying(20) NOT NULL,
    "Email" character varying(100) NOT NULL,
    "Password" character varying(255) NOT NULL,
    "Role" text DEFAULT 'user'::text NOT NULL,
    "Violations" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- Name: Users_idUsers_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_idUsers_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_idUsers_seq" OWNER TO postgres;

--
-- Name: Users_idUsers_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_idUsers_seq" OWNED BY public."Users"."idUsers";


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: test_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_table (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.test_table OWNER TO postgres;

--
-- Name: test_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_table_id_seq OWNER TO postgres;

--
-- Name: test_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_table_id_seq OWNED BY public.test_table.id;


--
-- Name: Areas idAreas; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Areas" ALTER COLUMN "idAreas" SET DEFAULT nextval('public."Areas_idAreas_seq"'::regclass);


--
-- Name: Cars idCars; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cars" ALTER COLUMN "idCars" SET DEFAULT nextval('public."Cars_idCars_seq"'::regclass);


--
-- Name: Cities idCities; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cities" ALTER COLUMN "idCities" SET DEFAULT nextval('public."Cities_idCities_seq"'::regclass);


--
-- Name: Gates idGates; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gates" ALTER COLUMN "idGates" SET DEFAULT nextval('public."Gates_idGates_seq"'::regclass);


--
-- Name: Notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications" ALTER COLUMN id SET DEFAULT nextval('public."Notifications_id_seq"'::regclass);


--
-- Name: ParkingLog idParkingLog; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingLog" ALTER COLUMN "idParkingLog" SET DEFAULT nextval('public."ParkingLog_idParkingLog_seq"'::regclass);


--
-- Name: Reservations idReservation; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservations" ALTER COLUMN "idReservation" SET DEFAULT nextval('public."Reservations_idReservation_seq"'::regclass);


--
-- Name: Slots idSlots; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Slots" ALTER COLUMN "idSlots" SET DEFAULT nextval('public."Slots_idSlots_seq"'::regclass);


--
-- Name: SubscriptionPlans idSubscriptionPlans; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubscriptionPlans" ALTER COLUMN "idSubscriptionPlans" SET DEFAULT nextval('public."SubscriptionPlans_idSubscriptionPlans_seq"'::regclass);


--
-- Name: UserNotifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserNotifications" ALTER COLUMN id SET DEFAULT nextval('public."UserNotifications_id_seq"'::regclass);


--
-- Name: UserSubscriptions idUserSubscriptions; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserSubscriptions" ALTER COLUMN "idUserSubscriptions" SET DEFAULT nextval('public."UserSubscriptions_idUserSubscriptions_seq"'::regclass);


--
-- Name: Users idUsers; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN "idUsers" SET DEFAULT nextval('public."Users_idUsers_seq"'::regclass);


--
-- Name: test_table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_table ALTER COLUMN id SET DEFAULT nextval('public.test_table_id_seq'::regclass);


--
-- Data for Name: Areas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Areas" ("idAreas", "AreaName", "CityID") FROM stdin;
1	Area 1	1
3	Area 3	3
2	Area 2	2
\.


--
-- Data for Name: Cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Cars" ("idCars", "RegistrationID", "Model", "OwnerID") FROM stdin;
6	LMN9101	Ford Mustang	1
4	9641782	Toyota Camry	1
9	9641783	Tesla	30
10	12480396	Subaru	30
5	12480397	Honda Accord	1
\.


--
-- Data for Name: Cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Cities" ("idCities", "CityName", "FullAddress", "pictureUrl") FROM stdin;
2	Tokyo	1-1 Chiyoda	https://images.pexels.com/photos/2506923/pexels-photo-2506923.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2
3	Seattle	456 Pike St	https://images.pexels.com/photos/19740006/pexels-photo-19740006/free-photo-of-skyscrapers-on-coast-in-seattle.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2
7	Tel Aviv	Ha-Yarkon 791	https://images.pexels.com/photos/2002604/pexels-photo-2002604.jpeg
1	Los Angeles	123 Sunset Blvd	https://images.pexels.com/photos/2263683/pexels-photo-2263683.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2
\.


--
-- Data for Name: Gates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gates" ("idGates", "Entrance", "Fault", "CityID", "CameraIP", "GateIP") FROM stdin;
4	f	t	3	192.168.2.104	192.168.2.204
1	t	f	1	192.168.1.4	192.168.1.22
2	f	f	1	192.168.1.5	192.168.1.3
3	t	f	2	192.168.2.103	192.168.2.203
\.


--
-- Data for Name: Notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Notifications" (id, "userId", message, "isRead", "createdAt", title) FROM stdin;
43	\N	tst	f	2024-10-20 17:23:06.076	tst
44	\N	la	f	2024-10-20 17:23:22.989	la 
\.


--
-- Data for Name: ParkingLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ParkingLog" ("idParkingLog", "CarID", "SlotID", "Entrance", "Exit", "Violation", "ReservationID", "NeedToExitBy") FROM stdin;
40	4	4	2024-10-20 10:00:00+03	\N	f	\N	2024-10-21 10:00:00+03
\.


--
-- Data for Name: Reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reservations" ("idReservation", "UserID", "CarID", "SlotID", "ReservationStart", "ReservationEnd", "Status") FROM stdin;
55	30	10	19	2024-10-08 10:00:00+03	2024-10-08 13:00:00+03	pending
\.


--
-- Data for Name: Slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Slots" ("idSlots", "Busy", "BorderRight", "Active", "Fault", "AreaID", "CameraIP", "SlotIP") FROM stdin;
19	f	1	t	f	1	192.168.1.6	192.168.1.7
6	f	8	t	f	2	192.168.1.103	192.168.1.203
14	f	2	t	f	2	192.168.1.202	192.168.10.202
15	f	3	t	f	3	192.168.1.203	192.168.10.203
16	f	4	t	f	2	192.168.1.204	192.168.10.204
4	f	4	t	f	1	192.168.1.101	192.168.1.201
17	t	5	t	f	3	192.168.1.205	192.168.10.205
\.


--
-- Data for Name: SubscriptionPlans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SubscriptionPlans" ("idSubscriptionPlans", "Name", "Price", "MaxCars", "Features", "MaxActiveReservations", "StripePriceId") FROM stdin;
1	Single	50.00	1	{"1 car allowed","Up to 2 active reservations"}	2	price_1PxvriRsSJ7763049KF0V1vu
2	Family	100.00	2	{"2 cars allowed","Up to 6 active reservations"}	6	price_1PxvsDRsSJ77630499P7Q9Lc
3	Enterprise	500.00	15	{"15 cars allowed","Up to 10 active reservations","Enterprise-level parking access","24/7 customer support","Premium booking features"}	10	price_1PxvstRsSJ776304gCtt1GkY
\.


--
-- Data for Name: UserNotifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserNotifications" (id, "userId", "notificationId", "isRead") FROM stdin;
58	24	43	f
59	29	43	f
60	30	43	f
62	31	43	f
63	1	44	t
61	1	43	t
\.


--
-- Data for Name: UserSubscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserSubscriptions" ("idUserSubscriptions", "UserID", "SubscriptionPlanID", "StartDate", "EndDate", "Status", "StripeSessionId", "SubscriptionId") FROM stdin;
12	24	2	2024-09-30	2025-09-30	active	cs_test_a1VkKsrxbOhkGznJN2qJDZYOqKPebVdW23vVNlk5zOCE7HeP2ZY7nEhn8I	sub_1Q4kVBRsSJ776304QvpZQjwJ
13	29	1	2024-09-30	2025-09-30	active	cs_test_a1rVcyiVB9EFYLEQ1ysTYb5StxqVfiiSEP8o1Iq5xWfxJDywlJM3NKfwFy	sub_1Q4mJ1RsSJ776304QMW7o6Q9
17	31	2	2024-10-08	2025-10-08	active	cs_test_a1SHC75F89gzwCi7wbtFipC6eAZGN4fGTKe5m03Yj8BrSjLnEI75tI07ot	sub_1Q7WRORsSJ776304KBfiLJK2
15	30	3	2024-10-01	2025-10-01	active	cs_test_a1KMYAtBlFZ74nV6cgICp8AoK5z0wcLf6N17lOvMPBRDmXShQ605PomRNS	sub_1Q53IhRsSJ776304IRAnCW7z
11	1	3	2024-09-12	2025-09-12	active	cs_test_a1c0xKRK6nWjJ3AB821wr2liNI65SbauFuoG1y7o38K5sm5KafOdUnD6qO	\N
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" ("idUsers", "persId", "FirstName", "LastName", "Phone", "Email", "Password", "Role", "Violations") FROM stdin;
1	123123123	ishay 	zag	040438876	ishay7@gmail.com	$2b$10$cg.itXpM5y/9n.ollKOYoO9k1Kpi8Zl/hANehvWiKAY7KuZUb1zdy	admin	1
24	111111111	daniel	dan	1111231123	daniel@gmail.com	$2b$10$SP0m6q3czBPNHsiTWLuZke/BjKOwf3Sv4JgkhzP7CADMz.Y3v4Igy	user	0
29	000000000	test	test	0980980098	test@gmail.com	$2b$10$4N0165u/l2upsYfu2FLaEuGrfZJKvWQBI9UDtXCijWWR0NU.0JanW	user	0
30	012012012	eitan	cher	0239287283	eitan@gmail.com	$2b$10$IBlBSt8B6bPaJPoB55HYXu5A7wVUVIF3B/S42J4EHnjaHhCIovXpS	user	0
31	111000111	tmp	tmp	0988787786	tmp@gmail.com	$2b$10$vnASyC4/0afjb6AAubCpbepVFNSRgFNyH6C94LYZMqlVDy62j6EQe	user	0
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
d7389dc0-acf8-4211-8c22-ea059b9315a5	80376a2d9a2dc6f66a706a17f4bf2ada73bf7befca3ef37809b54e2a0c0cdbe4	2024-09-11 22:51:59.568843+03	20240828095408_add_role_to_users_default_to_slots	\N	\N	2024-09-11 22:51:59.56598+03	1
f927420a-7562-40df-adb0-17a42d8b0ec3	cbe64dc1aaedcd7840ef4006e9a0da013b4f040b4f710f41bf4e6596e1db5bfa	2024-09-11 22:51:59.518204+03	20240818161802_add_unique_email	\N	\N	2024-09-11 22:51:59.495965+03	1
63d26cf3-3ed3-4ce4-b82d-96dac0430c77	2f99b593cef6ea7940c4e0b627e8d13571e9a0f11f080d237a782a3bd5a312c3	2024-09-11 22:51:59.5273+03	20240818164258_update_pers_id_type	\N	\N	2024-09-11 22:51:59.518867+03	1
581cb18e-1938-4197-9abb-f908c6c9d1b8	4398b96ae35860c014855f83fe4110ef496c7ad746158ebb80b50458b8323342	2024-09-11 22:51:59.53203+03	20240818165254_per_id_varchar_9	\N	\N	2024-09-11 22:51:59.528641+03	1
3b905d72-1281-4dff-95d0-8c65c0491dfb	449594f1a49e3c5a5bf94fe1499285dee5cea7c65752290f3df1375c07c0f5ed	2024-09-11 22:51:59.57242+03	20240828103145_remove_borders_and_slot_fields	\N	\N	2024-09-11 22:51:59.569473+03	1
8aa7b392-cc20-4200-a426-e9f71cd4049e	437bede022d9e61d511045b9749c1da2d868a3c8375522ca2237d11f3c268fb1	2024-09-11 22:51:59.533493+03	20240820162303_add_stripe_session_id	\N	\N	2024-09-11 22:51:59.532561+03	1
81635272-828f-4f4c-82eb-6a13c33887df	7a3c742353474c7afc12ca3ccb0807f0457b4145491aa52033617a42424b0d1b	2024-09-11 22:51:59.539963+03	20240823133206_rename_areas_to_cities_add_address	\N	\N	2024-09-11 22:51:59.534118+03	1
7ffbad24-3266-4472-92cd-3ca00ba88bab	4f7d21efab59fdb4a0e10489d563018feb9cba82ccb2025fa812c11cefe3da26	2024-09-11 22:51:59.545336+03	20240824075313_add_areas_table	\N	\N	2024-09-11 22:51:59.540789+03	1
4ba79a9f-0d70-41fc-b083-6f8188be8541	f3026d5949a084d4b4976727e837151e1543d1b25b016576387cf73021bce3ca	2024-09-11 22:51:59.576572+03	20240901151742_cascade_delete_update	\N	\N	2024-09-11 22:51:59.573362+03	1
58bb218b-b9d0-4b73-bc2a-c83cd3fc6777	88ec9181197cc82406e0aba3c8ac7708cc9c03f38c1b5ca9eb93583d46a8632d	2024-09-11 22:51:59.547241+03	20240824084509_add_max_active_reservations	\N	\N	2024-09-11 22:51:59.546067+03	1
d47a4c74-75f3-4a7b-bc0a-d8ea9bdd9b8c	76fca3d7fc92607489e5ff84f34217884e8845b3a25c83011d1bff16018635eb	2024-09-11 22:51:59.554532+03	20240824101246_update_reservation_models_and_relations	\N	\N	2024-09-11 22:51:59.548204+03	1
528a0656-a2e6-49e8-b3f7-d25819d64add	7211add8fe83a371dc34425bdd8b711634411964b86c82212336393cf3688a8e	2024-09-22 21:35:40.838844+03	20240922183540_make_slotid_exit_needtoexitby_nullable	\N	\N	2024-09-22 21:35:40.827632+03	1
2eefbb63-86e8-47cc-98bd-605724b453fb	c3b3c76f5bbb0cd30aa9e6529f4691c479abd896e13bfeefad3a7f1cdff0b7bb	2024-09-11 22:51:59.556982+03	20240824182520_remove_status_field	\N	\N	2024-09-11 22:51:59.555566+03	1
f95c7fe6-9ed3-4684-a6dd-436edfbb1c1f	105e4cdb54c720afc2655d4f99e544d97bc209de414c596c19dfac0a2a5c481c	2024-09-11 22:51:59.828595+03	20240901201713_add_gate_and_camera_ip_to_gates	\N	\N	2024-09-11 22:51:59.825766+03	1
49cf8955-00ff-4fed-9e0b-ed2f8c27713f	7468e346fa5d1dc5396632728ea73c776983efe33da37e0e20fe28117e6ddf8f	2024-09-11 22:51:59.559728+03	20240824190454_link_log_and_reservations_added_violations	\N	\N	2024-09-11 22:51:59.557562+03	1
1013d78a-ffb9-4628-8d0f-db092a711941	3a1ea99376c9e66738b8991eb39b2ca12a2eb32d5614630668de524b622b8681	2024-09-11 22:51:59.563047+03	20240824191050_add_status_back_to_reservations	\N	\N	2024-09-11 22:51:59.560528+03	1
f19daaee-d1a3-4932-aa65-4b3afb2780e5	06bc70cd55f7dc984c74c71d6291e3b0053b863c74d30dd57c43b29988815638	2024-09-11 22:51:59.565418+03	20240825190529_add_parking_log_times	\N	\N	2024-09-11 22:51:59.563931+03	1
340804ff-0183-4f19-b05d-7ca857eb1481	9479945180ca993081c43aa48d3d388ce1646917add12eeee3893ceec8bc9614	2024-10-17 20:26:38.129132+03	20241017172638_add_user_notifications	\N	\N	2024-10-17 20:26:38.123611+03	1
1d1ab711-06b3-4fb0-86e5-8b3e26651248	e7d73036f177ea518020a3cbbe785623355e4edbebe79fa7eb1137c923bd64ea	2024-09-11 22:51:59.835809+03	20240901202125_add_camera_ip_slot_ip_to_slots	\N	\N	2024-09-11 22:51:59.829851+03	1
3dabc070-c7f8-4334-a1be-75fdcb141231	800a72e4973290538be5e118b40ab86e1d9ea702693bb833f2af600162e16f9d	2024-09-24 21:02:08.151194+03	20240924180208_update_parking_log	\N	\N	2024-09-24 21:02:08.145217+03	1
c659cfca-aeef-4349-80b3-465236e31d86	5715d91bfa3c3c634baf0a9dfecad8437afd679985cb9e63eb8b31b6431bd7f4	2024-09-11 22:51:59.839+03	20240904090722_make_slotip_and_cameraip_nullable	\N	\N	2024-09-11 22:51:59.837091+03	1
6110843c-a258-46b9-badc-c0cf2cde54ab	5b94b80998a2de86b09c1ef74a223de76f013c5f3beaa5dbc807da774ca0f174	2024-09-11 22:56:05.187522+03	20240911195605_fix_column_names	\N	\N	2024-09-11 22:56:05.182347+03	1
b89bfbc3-a722-420a-9f5f-862ec03f6944	c8c1ca91ae8a007fc163a4177d9e2a5813c55f7873369b7c824874e254448c43	2024-09-11 23:11:10.404321+03	20240911201110_add_stripe_ids	\N	\N	2024-09-11 23:11:10.402245+03	1
f972cecd-7623-4796-8de1-0835c1093620	b42f642f6d46f311f5d709cf7410eca9b00bca1ab015bcf78a485909052f4649	2024-10-12 14:07:34.596542+03	20241012110734_add_default_false_to_entrance_fault	\N	\N	2024-10-12 14:07:34.59309+03	1
c3a7b7b7-0f1b-4be5-9df0-c1645e82c5f2	623f32be1130154a11978384c803a0c19c60ff629bba4cf8cd3003a5bb0fd383	2024-09-12 13:03:49.707333+03	20240912100349_add_subscription_id_to_user_subscriptions	\N	\N	2024-09-12 13:03:49.704352+03	1
8221ad7a-94fe-4b96-bb09-07661edc50e9	19f6b396d3560d8edb5ef9ac0f6894950b3e33f86c1e9ff5bce8c5ae6f0f5747	2024-10-16 20:20:39.657086+03	20241016172039_add_notifications_relation	\N	\N	2024-10-16 20:20:39.648334+03	1
0bbc47bf-b6e7-4432-b53d-e45f3e5a32ff	14ac071e0f704d634421f98594a8092c73d5d4566a4036390d64a77839ee7a29	2024-10-18 13:33:20.579347+03	20241018103320_add_optional_title_to_notifications	\N	\N	2024-10-18 13:33:20.57769+03	1
b5d8b639-fbe9-425d-a7ed-d9560f068383	f9597c838a2d2a887f060688e00934a0a55321c5a6a12bcae0c39a609995ff50	2024-10-17 15:05:03.672731+03	20241017120503_notifications_nullable_userid	\N	\N	2024-10-17 15:05:03.669772+03	1
\.


--
-- Data for Name: test_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_table (id, name) FROM stdin;
\.


--
-- Name: Areas_idAreas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Areas_idAreas_seq"', 13, true);


--
-- Name: Cars_idCars_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Cars_idCars_seq"', 12, true);


--
-- Name: Cities_idCities_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Cities_idCities_seq"', 7, true);


--
-- Name: Gates_idGates_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gates_idGates_seq"', 9, true);


--
-- Name: Notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Notifications_id_seq"', 44, true);


--
-- Name: ParkingLog_idParkingLog_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ParkingLog_idParkingLog_seq"', 40, true);


--
-- Name: Reservations_idReservation_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Reservations_idReservation_seq"', 58, true);


--
-- Name: Slots_idSlots_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Slots_idSlots_seq"', 30, true);


--
-- Name: SubscriptionPlans_idSubscriptionPlans_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SubscriptionPlans_idSubscriptionPlans_seq"', 3, true);


--
-- Name: UserNotifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserNotifications_id_seq"', 63, true);


--
-- Name: UserSubscriptions_idUserSubscriptions_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserSubscriptions_idUserSubscriptions_seq"', 17, true);


--
-- Name: Users_idUsers_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_idUsers_seq"', 31, true);


--
-- Name: test_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_table_id_seq', 1, false);


--
-- Name: Areas Areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Areas"
    ADD CONSTRAINT "Areas_pkey" PRIMARY KEY ("idAreas");


--
-- Name: Cars Cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cars"
    ADD CONSTRAINT "Cars_pkey" PRIMARY KEY ("idCars");


--
-- Name: Cities Cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cities"
    ADD CONSTRAINT "Cities_pkey" PRIMARY KEY ("idCities");


--
-- Name: Gates Gates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gates"
    ADD CONSTRAINT "Gates_pkey" PRIMARY KEY ("idGates");


--
-- Name: Notifications Notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY (id);


--
-- Name: ParkingLog ParkingLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingLog"
    ADD CONSTRAINT "ParkingLog_pkey" PRIMARY KEY ("idParkingLog");


--
-- Name: Reservations Reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservations"
    ADD CONSTRAINT "Reservations_pkey" PRIMARY KEY ("idReservation");


--
-- Name: Slots Slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Slots"
    ADD CONSTRAINT "Slots_pkey" PRIMARY KEY ("idSlots");


--
-- Name: SubscriptionPlans SubscriptionPlans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubscriptionPlans"
    ADD CONSTRAINT "SubscriptionPlans_pkey" PRIMARY KEY ("idSubscriptionPlans");


--
-- Name: UserNotifications UserNotifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserNotifications"
    ADD CONSTRAINT "UserNotifications_pkey" PRIMARY KEY (id);


--
-- Name: UserSubscriptions UserSubscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserSubscriptions"
    ADD CONSTRAINT "UserSubscriptions_pkey" PRIMARY KEY ("idUserSubscriptions");


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("idUsers");


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: test_table test_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_table
    ADD CONSTRAINT test_table_pkey PRIMARY KEY (id);


--
-- Name: Areas_AreaName_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Areas_AreaName_key" ON public."Areas" USING btree ("AreaName");


--
-- Name: Cars_RegistrationID_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Cars_RegistrationID_key" ON public."Cars" USING btree ("RegistrationID");


--
-- Name: Cities_CityName_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Cities_CityName_key" ON public."Cities" USING btree ("CityName");


--
-- Name: Gates_CameraIP_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gates_CameraIP_key" ON public."Gates" USING btree ("CameraIP");


--
-- Name: Gates_GateIP_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gates_GateIP_key" ON public."Gates" USING btree ("GateIP");


--
-- Name: Slots_CameraIP_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Slots_CameraIP_key" ON public."Slots" USING btree ("CameraIP");


--
-- Name: Slots_SlotIP_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Slots_SlotIP_key" ON public."Slots" USING btree ("SlotIP");


--
-- Name: SubscriptionPlans_Name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "SubscriptionPlans_Name_key" ON public."SubscriptionPlans" USING btree ("Name");


--
-- Name: UserNotifications_userId_notificationId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserNotifications_userId_notificationId_key" ON public."UserNotifications" USING btree ("userId", "notificationId");


--
-- Name: UserSubscriptions_UserID_Status_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserSubscriptions_UserID_Status_key" ON public."UserSubscriptions" USING btree ("UserID", "Status");


--
-- Name: Users_Email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Users_Email_key" ON public."Users" USING btree ("Email");


--
-- Name: Slots slot_change_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER slot_change_trigger AFTER INSERT OR UPDATE ON public."Slots" FOR EACH ROW EXECUTE FUNCTION public.notify_slot_change();


--
-- Name: Areas Areas_CityID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Areas"
    ADD CONSTRAINT "Areas_CityID_fkey" FOREIGN KEY ("CityID") REFERENCES public."Cities"("idCities") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Cars Cars_OwnerID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cars"
    ADD CONSTRAINT "Cars_OwnerID_fkey" FOREIGN KEY ("OwnerID") REFERENCES public."Users"("idUsers");


--
-- Name: Gates Gates_CityID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gates"
    ADD CONSTRAINT "Gates_CityID_fkey" FOREIGN KEY ("CityID") REFERENCES public."Cities"("idCities") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Notifications Notifications_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notifications"
    ADD CONSTRAINT "Notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"("idUsers") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ParkingLog ParkingLog_CarID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingLog"
    ADD CONSTRAINT "ParkingLog_CarID_fkey" FOREIGN KEY ("CarID") REFERENCES public."Cars"("idCars") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ParkingLog ParkingLog_ReservationID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingLog"
    ADD CONSTRAINT "ParkingLog_ReservationID_fkey" FOREIGN KEY ("ReservationID") REFERENCES public."Reservations"("idReservation") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ParkingLog ParkingLog_SlotID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingLog"
    ADD CONSTRAINT "ParkingLog_SlotID_fkey" FOREIGN KEY ("SlotID") REFERENCES public."Slots"("idSlots") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Reservations Reservations_CarID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservations"
    ADD CONSTRAINT "Reservations_CarID_fkey" FOREIGN KEY ("CarID") REFERENCES public."Cars"("idCars") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Reservations Reservations_SlotID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservations"
    ADD CONSTRAINT "Reservations_SlotID_fkey" FOREIGN KEY ("SlotID") REFERENCES public."Slots"("idSlots") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Reservations Reservations_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservations"
    ADD CONSTRAINT "Reservations_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public."Users"("idUsers") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Slots Slots_AreaID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Slots"
    ADD CONSTRAINT "Slots_AreaID_fkey" FOREIGN KEY ("AreaID") REFERENCES public."Areas"("idAreas") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserSubscriptions SubscriptionPlan_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserSubscriptions"
    ADD CONSTRAINT "SubscriptionPlan_fk" FOREIGN KEY ("SubscriptionPlanID") REFERENCES public."SubscriptionPlans"("idSubscriptionPlans");


--
-- Name: UserNotifications UserNotifications_notificationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserNotifications"
    ADD CONSTRAINT "UserNotifications_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES public."Notifications"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserNotifications UserNotifications_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserNotifications"
    ADD CONSTRAINT "UserNotifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"("idUsers") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserSubscriptions User_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserSubscriptions"
    ADD CONSTRAINT "User_fk" FOREIGN KEY ("UserID") REFERENCES public."Users"("idUsers") ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

