-- Téma: Výstaviště
-- Autoři: Alexandr Valíček (xvalic12), Václav Chadim (xchadi09)

DROP TABLE firma CASCADE CONSTRAINTS;
DROP TABLE expozice CASCADE CONSTRAINTS;
DROP TABLE poplatek CASCADE CONSTRAINTS;
DROP TABLE statistika CASCADE CONSTRAINTS;
DROP TABLE osoba CASCADE CONSTRAINTS;
DROP TABLE navstevnik CASCADE CONSTRAINTS;
DROP TABLE provozovatel CASCADE CONSTRAINTS;
DROP TABLE vstupne CASCADE CONSTRAINTS;
DROP TABLE stat_firem CASCADE CONSTRAINTS;
DROP TABLE stat_expozic CASCADE CONSTRAINTS;

DROP SEQUENCE osoba_seq;
DROP SEQUENCE navstevnik_seq;
DROP SEQUENCE provozovatel_seq;
DROP SEQUENCE firma_seq;
DROP SEQUENCE expozice_seq;
DROP SEQUENCE poplatek_seq;
DROP SEQUENCE statistika_seq;
DROP SEQUENCE vstupne_seq;


--adresa a kontakt jsou rozvedeny 

CREATE SEQUENCE osoba_seq START WITH 1;
CREATE SEQUENCE navstevnik_seq START WITH 1;
CREATE SEQUENCE provozovatel_seq START WITH 1;
CREATE SEQUENCE firma_seq START WITH 1;
CREATE SEQUENCE expozice_seq START WITH 1;
CREATE SEQUENCE poplatek_seq START WITH 1;
CREATE SEQUENCE statistika_seq START WITH 1;
CREATE SEQUENCE vstupne_seq START WITH 1;

CREATE TABLE osoba (
	id_osoby int DEFAULT osoba_seq.NEXTVAL PRIMARY KEY ,
	jmeno nvarchar2(255) NOT NULL,
	prijmeni nvarchar2(255) NOT NULL,
	datum_narozeni DATE NOT NULL,
	ulice nvarchar2(255) NOT NULL,
	domov_cislo int NOT NULL,
	mesto nvarchar2(255) NOT NULL,
	psc number(5) NOT NULL,
	email nvarchar2(255) NOT NULL,
	tel nvarchar2(255) NOT NULL
);

CREATE TABLE navstevnik (
	id_navstevnika int DEFAULT navstevnik_seq.NEXTVAL PRIMARY KEY REFERENCES Osoba(id_osoby),
	vstupenka_id int,
	vstupenka_nazev nvarchar2(255),
	uhrazene_platby int,
	uhrazena_castka int
);

CREATE TABLE provozovatel (
	id_provozovatel int DEFAULT provozovatel_seq.NEXTVAL PRIMARY KEY  REFERENCES osoba(id_osoby)
);

CREATE TABLE firma(
	id_firmy int DEFAULT firma_seq.NEXTVAL PRIMARY KEY,
	nazev nvarchar2(255) NOT NULL,
	obor_cinosti nvarchar2(255) NOT NULL,
	email nvarchar2(255) NOT NULL,
	tel nvarchar2(255) NOT NULL,
	ico number(9) NOT NULL CHECK (ico BETWEEN 100000000 AND 999999999),
	provozovatel int REFERENCES provozovatel(id_provozovatel)
);

CREATE TABLE expozice(
	id_expozice int DEFAULT expozice_seq.NEXTVAL PRIMARY KEY,
	nazev nvarchar2(255) NOT NULL,
	lokace nvarchar2(255) NOT NULL,
	zac_datum TIMESTAMP,
	kon_datum TIMESTAMP,
	firma int REFERENCES firma(id_firmy)
);

CREATE TABLE poplatek(
	id_poplatku int PRIMARY KEY REFERENCES expozice(id_expozice),
	vyse_poplatku int,
	datum_uhrady DATE,
	stav_uhrady int,
	provozovatel int REFERENCES provozovatel(id_provozovatel)
);

CREATE TABLE statistika(
	id_statistiky int DEFAULT statistika_seq.NEXTVAL PRIMARY KEY,
	typ nvarchar2(255),
	provozovatel int REFERENCES provozovatel(id_provozovatel)
);

--pro N:M vztah
CREATE TABLE stat_firem (
	id_firmy int REFERENCES firma(id_firmy),
	id_statistiky int REFERENCES statistika(id_statistiky),
	PRIMARY KEY (id_firmy, id_statistiky)
);
--pro N:M vztah
CREATE TABLE stat_expozic (
	id_expozice int REFERENCES expozice(id_expozice),
	id_statistiky int REFERENCES statistika(id_statistiky),
	PRIMARY KEY (id_expozice, id_statistiky)
);


CREATE TABLE vstupne (
	id_vstupne int DEFAULT vstupne_seq.NEXTVAL PRIMARY KEY,
	nazev nvarchar2(255),
	popis nvarchar2(255),
		
	zac_platnost TIMESTAMP,
	kon_platnost TIMESTAMP,
	
	id_expozice int REFERENCES expozice(id_expozice),
	id_navstevnik int REFERENCES navstevnik(id_navstevnika)
);

--OSOBY
INSERT INTO osoba (jmeno, prijmeni, datum_narozeni, ulice, domov_cislo, mesto, psc, email, tel)
VALUES ('John', 'Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'lol', 5, 'Horni^Dolni', 25252, 'lol@sd.cz', '+420 999 999 999');

INSERT INTO osoba (jmeno, prijmeni, datum_narozeni, ulice, domov_cislo, mesto, psc, email, tel)
VALUES ('John', 'Hoe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'lol', 5, 'Horni Dolni', 25252, 'lol@sd.cz', '+420 999 999 999');

INSERT INTO osoba (jmeno, prijmeni, datum_narozeni, ulice, domov_cislo, mesto, psc, email, tel)
VALUES ('John', 'Foe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'lol', 5, 'Horni$Dolni', 25252, 'lol@sd.cz', '+420 999 999 999');

INSERT INTO osoba (jmeno, prijmeni, datum_narozeni, ulice, domov_cislo, mesto, psc, email, tel)
VALUES ('Anna', 'Gold', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'somewhere', 5, 'Hamburg', 12066, 'annagold@gmail.com', '+420 555 999 999');

--PROVOZOVATEL
INSERT INTO provozovatel (id_provozovatel)
VALUES (1);

--FIRMY
INSERT INTO firma (nazev, obor_cinosti, email, tel, ico, provozovatel)
VALUES ('RockyBalboa', 'Fast&Furious car dealership', 'rocky@example.com', '+540 525 521 551', 123456789, 1);

INSERT INTO firma (nazev, obor_cinosti, email, tel, ico, provozovatel)
VALUES ('Terminator', 'Robotics and AI', 'terminator@example.com', '+540 525 521 552', 987654321, 1);

--EXPOZICE
INSERT INTO expozice (nazev, lokace, zac_datum, kon_datum, firma)
VALUES ('Autumn Tech Expo', 'Conference Center', TO_TIMESTAMP('2024-09-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-18 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 1);

INSERT INTO expozice (nazev, lokace, zac_datum, kon_datum, firma)
VALUES ('Spring Fashion Show', 'Expo Hall A', TO_TIMESTAMP('2024-03-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-08 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 2);

-- NÁVŠTĚVNÍCI
INSERT INTO navstevnik (id_navstevnika, vstupenka_id, vstupenka_nazev, uhrazene_platby, uhrazena_castka)
VALUES (1, 1, 'VIP Pass', 1, 5000);

INSERT INTO navstevnik (id_navstevnika, vstupenka_id, vstupenka_nazev, uhrazene_platby, uhrazena_castka)
VALUES (2, 2, 'General Admission', 1, 2500);

INSERT INTO navstevnik (id_navstevnika, vstupenka_id, vstupenka_nazev, uhrazene_platby, uhrazena_castka)
VALUES (3, 2, 'General Admission', 0, 2500);

INSERT INTO navstevnik (id_navstevnika, vstupenka_id, vstupenka_nazev, uhrazene_platby, uhrazena_castka)
VALUES (4, 2, 'General Admission', 0, 2500);

--POPLATEK
INSERT INTO poplatek(ID_poplatku, vyse_poplatku, datum_uhrady, stav_uhrady, provozovatel)
VALUES (1, 2500,TO_DATE('2024-05-15', 'YYYY-MM-DD'), 1 ,1);

INSERT INTO poplatek(ID_poplatku, vyse_poplatku, datum_uhrady, stav_uhrady, provozovatel)
VALUES (2, 2800,TO_DATE('2024-05-15', 'YYYY-MM-DD'), 0, 1);

--STATISTIKA
INSERT INTO statistika(ID_statistiky, typ, provozovatel)
VALUES (1, 'Sbirani dat o firmach a jejich expozicich na vystavisti',1);

INSERT INTO stat_expozic(id_expozice, id_statistiky)
VALUES (1, 1);

INSERT INTO stat_firem(id_firmy,ID_statistiky)
VALUES (1, 1);

--VSTUPNE
INSERT INTO vstupne (nazev, popis, zac_platnost, kon_platnost, id_expozice, id_navstevnik)
VALUES ('VIP', 'Přístup všude', TO_TIMESTAMP('2024-09-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-17 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 1, 1);

INSERT INTO vstupne (nazev, popis, zac_platnost, kon_platnost, id_expozice, id_navstevnik)
VALUES ('Standard', 'Přístup do hlavní haly', TO_TIMESTAMP('2024-03-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-08 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 2, 2);


-- pro ukazku triggeru
--INSERT INTO vstupne (nazev, popis, zac_platnost, kon_platnost, id_expozice, id_navstevnik)
--VALUES ('Standard', 'Přístup do hlavní haly', TO_TIMESTAMP('2024-03-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-09 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 2, 2);


-- Query


-- 1: Najděte všechny návštěvníky s jejich uhrazenými vstupnými
-- Propojuje návštěvníky s jejich platbami za vstupenky, abychom viděli, kdo zaplatil a kolik
SELECT n.jmeno, n.prijmeni, v.uhrazena_castka
FROM navstevnik v
JOIN osoba n ON v.id_navstevnika = n.id_osoby
WHERE v.uhrazene_platby = 1;

-- 2: Seznam všech firem a jejich příslušných výstav
-- Která firma se účastní jaké výstavy
SELECT f.nazev AS "Název firmy", e.nazev AS "Název výstavy"
FROM firma f
JOIN expozice e ON f.id_firmy = e.firma;

-- 3: Ukázat detaily návštěvníků a typy jejich vstupenek pro konkrétní výstavu
-- Spojením tří tabulek zjistíme, kteří návštěvníci se účastní určité výstavy a jaké mají typy vstupenek
SELECT o.jmeno, o.prijmeni, v.vstupenka_nazev, e.nazev AS "Výstava"
FROM navstevnik v
JOIN osoba o ON v.id_navstevnika = o.id_osoby
JOIN vstupne vt ON vt.id_navstevnik = v.id_navstevnika
JOIN expozice e ON vt.id_expozice = e.id_expozice
WHERE e.nazev = 'Autumn Tech Expo';

-- 4: Počet výstav na firmu
-- Používá GROUP BY k počítání, kolik výstav je spojeno s každou firmou
SELECT f.nazev, COUNT(e.id_expozice) AS "Počet výstav"
FROM firma f
JOIN expozice e ON f.id_firmy = e.firma
GROUP BY f.nazev;

-- 5: Agregace celkových příjmů z poplatků na výstavách
-- Sčítá poplatky zaplacené za každou výstavu, seskupené podle názvu výstav
SELECT e.nazev AS "Výstava", SUM(p.vyse_poplatku) AS "Celkové poplatky"
FROM expozice e
JOIN poplatek p ON e.id_expozice = p.id_poplatku
GROUP BY e.nazev;

-- 6: Najít všechny návštěvníky, kteří si zakoupili vstupenku na jakoukoliv výstavu s poplatkem nad určitou částku
-- EXISTS pro filtraci návštěvníků na základě existence určitých plateb za výstavy
SELECT DISTINCT o.jmeno, o.prijmeni
FROM osoba o
JOIN navstevnik n ON o.id_osoby = n.id_navstevnika
WHERE EXISTS (
    SELECT 1
    FROM vstupne v
    JOIN expozice e ON v.id_expozice = e.id_expozice
    JOIN poplatek p ON e.id_expozice = p.id_poplatku
    WHERE n.id_navstevnika = v.id_navstevnik AND p.vyse_poplatku > 2000
);

-- 7: Seznam všech firem účastnících se na stejné výstavě jako 'Terminator'
-- Používá IN s poddotazem k nalezení firem na stejných výstavách jako specifická firma
SELECT DISTINCT f.nazev
FROM firma f
JOIN expozice e ON f.id_firmy = e.firma
WHERE e.id_expozice IN (
    SELECT e.id_expozice
    FROM expozice e
    JOIN firma f ON e.firma = f.id_firmy
    WHERE f.nazev = 'Terminator'
);

--				  TRIGGERY

-- č.1: kontrola zda je vstupné v rozmezí doby konání expozice
CREATE OR REPLACE TRIGGER kontrola_vstupneho
BEFORE INSERT OR UPDATE ON vstupne
    FOR EACH ROW
	DECLARE
   	zacatek_expozice TIMESTAMP;
   	konec_expozice TIMESTAMP;    
BEGIN
    SELECT  zac_datum, kon_datum INTO zacatek_expozice, konec_expozice
    FROM expozice
    WHERE id_expozice = :new.id_expozice;
    IF (:new.zac_platnost < zacatek_expozice OR :new.kon_platnost > konec_expozice) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Vstupné je vypsáno mimo dobu expozice!');
   	END IF;
END;
/

-- č.2: kontrola zda je provedena platba před přiřazením vstupenky

CREATE OR REPLACE TRIGGER kontrola_uhrazenych_plateb
BEFORE INSERT ON vstupne
FOR EACH ROW
DECLARE
  pocet_uhrazenych_platby INT;
BEGIN
  SELECT COUNT(*)
  INTO pocet_uhrazenych_platby
  FROM navstevnik
  WHERE id_navstevnika = :new.id_navstevnik AND uhrazene_platby > 0;

  IF pocet_uhrazenych_platby = 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Každý návštěvník musí mít alespoň jednu uhrazenou platbu před přidělením vstupenky.');
  END IF;
END;
/

-- PROCEDURY

-- č.1: změna emailu
CREATE OR REPLACE PROCEDURE zmena_emailu(p_id_osoby int, p_novy_email nvarchar2)
AS
BEGIN
  UPDATE osoba
  SET email = p_novy_email
  WHERE id_osoby = p_id_osoby;
END;
/

-- č.2: zda je platba uhrazena
CREATE OR REPLACE PROCEDURE overeni_platby(p_id_poplatku int)
AS
  stav_platby int;
BEGIN
  SELECT stav_uhrady INTO stav_platby FROM poplatek WHERE id_poplatku = p_id_poplatku;
  IF stav_platby = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Platba byla uhrazena.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Platba nebyla uhrazena.');
  END IF;
END;
/

--         Index a explain plan 

-- Vybrat zakazniky, kteri maji objednanou vstupenku na expedici X ale vstupenku jeste nezaplatili
EXPLAIN PLAN FOR
    SELECT n.jmeno, n.prijmeni, v.uhrazene_platby
    FROM navstevnik v
    JOIN osoba n ON v.id_navstevnika = n.id_osoby
    JOIN vstupne vt ON vt.id_navstevnik = v.id_navstevnika
    JOIN expozice e ON e.id_expozice = vt.id_expozice
    WHERE v.uhrazene_platby = 1
    GROUP BY n.jmeno,n.prijmeni, v.uhrazene_platby;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Vytvoreni indexu na sloupci "uhrazene_platby" tabulky "navstevnik"
CREATE INDEX uhrazene_platby_index on navstevnik (uhrazene_platby);

EXPLAIN PLAN FOR
    SELECT n.jmeno, n.prijmeni, v.uhrazene_platby
    FROM navstevnik v
    JOIN osoba n ON v.id_navstevnika = n.id_osoby
    JOIN vstupne vt ON vt.id_navstevnik = v.id_navstevnika
    JOIN expozice e ON e.id_expozice = vt.id_expozice
    WHERE v.uhrazene_platby = 1
    GROUP BY n.jmeno,n.prijmeni, v.uhrazene_platby;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX uhrazene_platby_index;

-- Materializovaný pohled

CREATE INDEX idx_vstupne_expozice ON vstupne(id_expozice);

-- EXPLAIN PLAN ukázka
EXPLAIN PLAN FOR
SELECT * FROM vstupne WHERE id_expozice = 1;


GRANT SELECT, INSERT, UPDATE ON firma TO druhy_clen;
GRANT SELECT, INSERT ON expozice TO druhy_clen;

CREATE MATERIALIZED VIEW druhy_clen_exp_pohled
REFRESH COMPLETE ON DEMAND
AS SELECT e.nazev, COUNT(v.id_navstevnika) AS pocet_navstevniku
FROM expozice e
JOIN vstupne v ON e.id_expozice = v.id_expozice
GROUP BY e.nazev;

-- Ukázka použití pohledu
SELECT * FROM druhy_clen_exp_pohled;
