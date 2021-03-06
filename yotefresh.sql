PGDMP     ;        
             z         	   yotefresh    13.4    13.4 M    '           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            (           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            )           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            *           1262    25763 	   yotefresh    DATABASE     m   CREATE DATABASE yotefresh WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
    DROP DATABASE yotefresh;
                postgres    false            ?           1247    25879    status    TYPE     R   CREATE TYPE public.status AS ENUM (
    'success',
    'pending',
    'failed'
);
    DROP TYPE public.status;
       public          postgres    false            ?            1259    25836 	   addresses    TABLE     ?  CREATE TABLE public.addresses (
    address_id integer NOT NULL,
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    mobile_phone_number character varying(50) NOT NULL,
    alternate_phone_number character varying(50),
    county character varying(50) NOT NULL,
    town character varying(50) NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL,
    delivery_address character varying(255)
);
    DROP TABLE public.addresses;
       public         heap    postgres    false            ?            1259    25834    addresses_address_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.addresses_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.addresses_address_id_seq;
       public          postgres    false    207            +           0    0    addresses_address_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;
          public          postgres    false    206            ?            1259    25907    cart    TABLE     ?   CREATE TABLE public.cart (
    cart_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false            ?            1259    25905    cart_cart_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.cart_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.cart_cart_id_seq;
       public          postgres    false    215            ,           0    0    cart_cart_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.cart_cart_id_seq OWNED BY public.cart.cart_id;
          public          postgres    false    214            ?            1259    25779 	   customers    TABLE        CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.customers;
       public         heap    postgres    false            ?            1259    25777    customers_customer_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.customers_customer_id_seq;
       public          postgres    false    201            -           0    0    customers_customer_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;
          public          postgres    false    200            ?            1259    25850    default_addresses    TABLE     ?   CREATE TABLE public.default_addresses (
    default_address_id integer NOT NULL,
    customer_id integer NOT NULL,
    address_id integer NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL
);
 %   DROP TABLE public.default_addresses;
       public         heap    postgres    false            ?            1259    25986    default_address_view    VIEW     ?  CREATE VIEW public.default_address_view AS
 SELECT a.default_address_id,
    a.address_id,
    a.customer_id,
    addresses.first_name,
    addresses.last_name,
    addresses.mobile_phone_number,
    addresses.alternate_phone_number,
    addresses.delivery_address,
    addresses.county,
    addresses.town
   FROM (public.default_addresses a
     JOIN public.addresses USING (address_id));
 '   DROP VIEW public.default_address_view;
       public          postgres    false    207    207    207    207    207    207    207    207    209    209    209            ?            1259    25848 (   default_addresses_default_address_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.default_addresses_default_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.default_addresses_default_address_id_seq;
       public          postgres    false    209            .           0    0 (   default_addresses_default_address_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.default_addresses_default_address_id_seq OWNED BY public.default_addresses.default_address_id;
          public          postgres    false    208            ?            1259    25817 	   favorites    TABLE     ?   CREATE TABLE public.favorites (
    favorite_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.favorites;
       public         heap    postgres    false            ?            1259    25815    favorites_favorite_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.favorites_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.favorites_favorite_id_seq;
       public          postgres    false    205            /           0    0    favorites_favorite_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.favorites_favorite_id_seq OWNED BY public.favorites.favorite_id;
          public          postgres    false    204            ?            1259    25792    products    TABLE     h  CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(50) NOT NULL,
    price integer NOT NULL,
    price_type character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    stock integer NOT NULL,
    image character varying(255) NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.products;
       public         heap    postgres    false            ?            1259    25948    favorites_view    VIEW     H  CREATE VIEW public.favorites_view AS
 SELECT favorites.favorite_id,
    favorites.product_id,
    favorites.customer_id,
    products.product_name,
    products.price,
    products.price_type,
    products.category,
    products.stock,
    products.image
   FROM (public.favorites
     JOIN public.products USING (product_id));
 !   DROP VIEW public.favorites_view;
       public          postgres    false    205    203    203    203    203    203    203    203    205    205            ?            1259    25887    orders    TABLE     G  CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    payment_id integer NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL,
    shipping_date date,
    is_shipped boolean DEFAULT false NOT NULL,
    amount_payable integer NOT NULL,
    shipping_cost integer NOT NULL
);
    DROP TABLE public.orders;
       public         heap    postgres    false            ?            1259    25885    orders_order_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.orders_order_id_seq;
       public          postgres    false    213            0           0    0    orders_order_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;
          public          postgres    false    212            ?            1259    34332    orders_view    VIEW     H  CREATE VIEW public.orders_view AS
 SELECT c.order_id,
    o.customer_id,
    c.product_id,
    p.product_name,
    p.price,
    p.category,
    p.stock,
    p.image,
    c.quantity
   FROM ((public.cart c
     JOIN public.products p ON ((c.product_id = p.product_id)))
     JOIN public.orders o ON ((o.order_id = c.order_id)));
    DROP VIEW public.orders_view;
       public          postgres    false    213    203    203    213    215    215    215    203    203    203    203            ?            1259    25790    products_product_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          postgres    false    203            1           0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          postgres    false    202            ?            1259    25871    stk    TABLE     V  CREATE TABLE public.stk (
    payment_id integer NOT NULL,
    merchantrequestid character varying(100) NOT NULL,
    checkoutrequestid character varying(100) NOT NULL,
    resultcode integer NOT NULL,
    resultdesc character varying(255) NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL,
    callbackmetadata json NOT NULL
);
    DROP TABLE public.stk;
       public         heap    postgres    false            ?            1259    25869    stk_payment_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.stk_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.stk_payment_id_seq;
       public          postgres    false    211            2           0    0    stk_payment_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.stk_payment_id_seq OWNED BY public.stk.payment_id;
          public          postgres    false    210            d           2604    25839    addresses address_id    DEFAULT     |   ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);
 C   ALTER TABLE public.addresses ALTER COLUMN address_id DROP DEFAULT;
       public          postgres    false    207    206    207            m           2604    25910    cart cart_id    DEFAULT     l   ALTER TABLE ONLY public.cart ALTER COLUMN cart_id SET DEFAULT nextval('public.cart_cart_id_seq'::regclass);
 ;   ALTER TABLE public.cart ALTER COLUMN cart_id DROP DEFAULT;
       public          postgres    false    214    215    215            ^           2604    25782    customers customer_id    DEFAULT     ~   ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);
 D   ALTER TABLE public.customers ALTER COLUMN customer_id DROP DEFAULT;
       public          postgres    false    200    201    201            f           2604    25853 $   default_addresses default_address_id    DEFAULT     ?   ALTER TABLE ONLY public.default_addresses ALTER COLUMN default_address_id SET DEFAULT nextval('public.default_addresses_default_address_id_seq'::regclass);
 S   ALTER TABLE public.default_addresses ALTER COLUMN default_address_id DROP DEFAULT;
       public          postgres    false    208    209    209            b           2604    25820    favorites favorite_id    DEFAULT     ~   ALTER TABLE ONLY public.favorites ALTER COLUMN favorite_id SET DEFAULT nextval('public.favorites_favorite_id_seq'::regclass);
 D   ALTER TABLE public.favorites ALTER COLUMN favorite_id DROP DEFAULT;
       public          postgres    false    204    205    205            j           2604    25890    orders order_id    DEFAULT     r   ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);
 >   ALTER TABLE public.orders ALTER COLUMN order_id DROP DEFAULT;
       public          postgres    false    213    212    213            `           2604    25795    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    203    202    203            h           2604    25874    stk payment_id    DEFAULT     p   ALTER TABLE ONLY public.stk ALTER COLUMN payment_id SET DEFAULT nextval('public.stk_payment_id_seq'::regclass);
 =   ALTER TABLE public.stk ALTER COLUMN payment_id DROP DEFAULT;
       public          postgres    false    211    210    211                      0    25836 	   addresses 
   TABLE DATA           ?   COPY public.addresses (address_id, customer_id, first_name, last_name, mobile_phone_number, alternate_phone_number, county, town, creation_date, delivery_address) FROM stdin;
    public          postgres    false    207   ?c       $          0    25907    cart 
   TABLE DATA           V   COPY public.cart (cart_id, order_id, product_id, quantity, creation_date) FROM stdin;
    public          postgres    false    215   	d                 0    25779 	   customers 
   TABLE DATA           Z   COPY public.customers (customer_id, username, email, password, creation_date) FROM stdin;
    public          postgres    false    201   Ad                 0    25850    default_addresses 
   TABLE DATA           g   COPY public.default_addresses (default_address_id, customer_id, address_id, creation_date) FROM stdin;
    public          postgres    false    209   ?e                 0    25817 	   favorites 
   TABLE DATA           X   COPY public.favorites (favorite_id, customer_id, product_id, creation_date) FROM stdin;
    public          postgres    false    205   ?e       "          0    25887    orders 
   TABLE DATA           ?   COPY public.orders (order_id, customer_id, payment_id, creation_date, shipping_date, is_shipped, amount_payable, shipping_cost) FROM stdin;
    public          postgres    false    213   ?e                 0    25792    products 
   TABLE DATA           v   COPY public.products (product_id, product_name, price, price_type, category, stock, image, creation_date) FROM stdin;
    public          postgres    false    203   6f                  0    25871    stk 
   TABLE DATA           ?   COPY public.stk (payment_id, merchantrequestid, checkoutrequestid, resultcode, resultdesc, creation_date, callbackmetadata) FROM stdin;
    public          postgres    false    211   ?g       3           0    0    addresses_address_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.addresses_address_id_seq', 3, true);
          public          postgres    false    206            4           0    0    cart_cart_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.cart_cart_id_seq', 3, true);
          public          postgres    false    214            5           0    0    customers_customer_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_customer_id_seq', 5, true);
          public          postgres    false    200            6           0    0 (   default_addresses_default_address_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.default_addresses_default_address_id_seq', 1, true);
          public          postgres    false    208            7           0    0    favorites_favorite_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.favorites_favorite_id_seq', 10, true);
          public          postgres    false    204            8           0    0    orders_order_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.orders_order_id_seq', 3, true);
          public          postgres    false    212            9           0    0    products_product_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_product_id_seq', 15, true);
          public          postgres    false    202            :           0    0    stk_payment_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.stk_payment_id_seq', 3, true);
          public          postgres    false    210            |           2606    25842    addresses addresses_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);
 B   ALTER TABLE ONLY public.addresses DROP CONSTRAINT addresses_pkey;
       public            postgres    false    207            ?           2606    25913    cart cart_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (cart_id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    215            p           2606    25789    customers customers_email_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);
 G   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_email_key;
       public            postgres    false    201            r           2606    25785    customers customers_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
 B   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
       public            postgres    false    201            t           2606    25787     customers customers_username_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_username_key UNIQUE (username);
 J   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_username_key;
       public            postgres    false    201            ~           2606    25858 3   default_addresses default_addresses_customer_id_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.default_addresses
    ADD CONSTRAINT default_addresses_customer_id_key UNIQUE (customer_id);
 ]   ALTER TABLE ONLY public.default_addresses DROP CONSTRAINT default_addresses_customer_id_key;
       public            postgres    false    209            ?           2606    25856 (   default_addresses default_addresses_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.default_addresses
    ADD CONSTRAINT default_addresses_pkey PRIMARY KEY (default_address_id);
 R   ALTER TABLE ONLY public.default_addresses DROP CONSTRAINT default_addresses_pkey;
       public            postgres    false    209            z           2606    25823    favorites favorites_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (favorite_id);
 B   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_pkey;
       public            postgres    false    205            ?           2606    25894    orders orders_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    213            v           2606    25798    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    203            x           2606    25800 "   products products_product_name_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_name_key UNIQUE (product_name);
 L   ALTER TABLE ONLY public.products DROP CONSTRAINT products_product_name_key;
       public            postgres    false    203            ?           2606    25877    stk stk_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.stk
    ADD CONSTRAINT stk_pkey PRIMARY KEY (payment_id);
 6   ALTER TABLE ONLY public.stk DROP CONSTRAINT stk_pkey;
       public            postgres    false    211            ?           2606    25843     addresses fk_addresses_customers    FK CONSTRAINT     ?   ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_addresses_customers FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
 J   ALTER TABLE ONLY public.addresses DROP CONSTRAINT fk_addresses_customers;
       public          postgres    false    207    201    2930            ?           2606    25914    cart fk_cart_orders    FK CONSTRAINT     z   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT fk_cart_orders FOREIGN KEY (order_id) REFERENCES public.orders(order_id);
 =   ALTER TABLE ONLY public.cart DROP CONSTRAINT fk_cart_orders;
       public          postgres    false    215    2948    213            ?           2606    25919    cart fk_cart_products    FK CONSTRAINT     ?   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT fk_cart_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);
 ?   ALTER TABLE ONLY public.cart DROP CONSTRAINT fk_cart_products;
       public          postgres    false    203    215    2934            ?           2606    25864 0   default_addresses fk_default_addresses_addresses    FK CONSTRAINT     ?   ALTER TABLE ONLY public.default_addresses
    ADD CONSTRAINT fk_default_addresses_addresses FOREIGN KEY (address_id) REFERENCES public.addresses(address_id);
 Z   ALTER TABLE ONLY public.default_addresses DROP CONSTRAINT fk_default_addresses_addresses;
       public          postgres    false    207    2940    209            ?           2606    25859 0   default_addresses fk_default_addresses_customers    FK CONSTRAINT     ?   ALTER TABLE ONLY public.default_addresses
    ADD CONSTRAINT fk_default_addresses_customers FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
 Z   ALTER TABLE ONLY public.default_addresses DROP CONSTRAINT fk_default_addresses_customers;
       public          postgres    false    2930    201    209            ?           2606    25829     favorites fk_favorites_customers    FK CONSTRAINT     ?   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT fk_favorites_customers FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
 J   ALTER TABLE ONLY public.favorites DROP CONSTRAINT fk_favorites_customers;
       public          postgres    false    2930    201    205            ?           2606    25824    favorites fk_favorites_products    FK CONSTRAINT     ?   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT fk_favorites_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);
 I   ALTER TABLE ONLY public.favorites DROP CONSTRAINT fk_favorites_products;
       public          postgres    false    2934    205    203            ?           2606    25900    orders fk_orders_customers    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT fk_orders_customers;
       public          postgres    false    213    201    2930            ?           2606    25895    orders fk_orders_stk    FK CONSTRAINT     |   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_stk FOREIGN KEY (payment_id) REFERENCES public.stk(payment_id);
 >   ALTER TABLE ONLY public.orders DROP CONSTRAINT fk_orders_stk;
       public          postgres    false    211    2946    213               x   x?3?4?L?(?,.?L???L,?/?4705?4556????M,??Sp?,?(?t?I?/J-Qpvr?4202?54?50??N?S???,?2?7,?0?F?&? ?2?*-HT?M???????? P9,?      $   (   x?3?4?4b##C]C]CC.#N#t!cNct?=... !A	7         L  x?m?Ko?@??5???̀???ը\DQj??Vd???P??7Ѧ5?????79?	{?VQ&|K
??AX??#(??涺??????0?????g* ?^y?.	?D??	0"??I-?Cn?A1?????)N_k?=??'E8\e;?K?;7??EF"?0???8$ɝʞݎ??%?3$&?}^?t?[P麜aΌN?`?H?	??zv-?y}}??c?1?{?H
T?k`????N?σ?v?s???????z????&?t)?ZzQn?P??
юZ???Ӈ\???B??Q,?@?m?:{?????r?\?A??<?&P?5?&s5~.| ?e?????            x?3?4B##C]C]c?=... &ID            x?34?4B##C]C]?=... *?u      "   0   x?3?4B##C]C]CC???4N#NC.#?8Vc??1V?=... 0?B         R  x?}?Ar?0еr?^ F?l'9DoЍ	Ƥ;?:??+(e?????_???m6.xP?k?p?!?~?@?Y???F???} ??V?+T???G??n7????em4??1?qL???/7?B?H??F???J!Y=??;m>B??蹬??Q?%Qa?յ_?)?,Q?]i??v?J?6^???CXNH\??m?t?̶o???Ii?eI̤?R֒8?1??ئx=?X?FUY?2?)unJr?|"U??n&	>????S???V?|?ZV???MO??"+&?+f?\?8-[h?Dap?t?Rk??O?j?2k *??uJ?Z[?%??$A0??w?G?Do??(????.          ,  x?͒MO?@????h?df????? ?xQC?:?&m?n?1??n{?F?.?6????y2?`???'e?]??r<[""?E?5??G???$???׊}%>?똽???Wq?z????4?.B=<؊??31?ߊ??X?Q???RtĝK??@????Ն??ᘓM9??'.????|Dj|ybI?"#??<?viQ?ܻ?L???+???ႚ??i%??u???V}Ъ? ??qR`tm?HE??cZI=?2?t4????X?f?kL6GF?ԗ?? ?%?)?jr?g?}?5lD?U????Ata     