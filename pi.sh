#!/bin/sh
# PL/pgSQL で円周率を計算する.

psql <<EOF
CREATE OR REPLACE FUNCTION calc_pi() RETURNS NUMERIC AS '
	DECLARE
		s NUMERIC;
		a NUMERIC;
		p NUMERIC;
		k NUMERIC;
		d NUMERIC;
		N INTEGER;
	BEGIN
		N = 1500;
		a := 0.2;
		s := 0;
		k := 1;
		d := 0.04;

		WHILE trunc(a / k, N) <> 0 LOOP
			IF k % 4 = 1 THEN
				s := s + a / k;
			ELSE
				s := s - a / k;
			END IF;
			k := k + 2;
			a := a * d;
		END LOOP;
		RAISE NOTICE ''k = %'', k;
		
		p := 4 * s;
		s := 0;
		a := 1 / 239::NUMERIC;
		k := 1;
		d := 57121;
 
		WHILE trunc(a / k, N) <> 0  LOOP
			IF k % 4 = 1 THEN
				s := s + a / k;
			ELSE
				s := s - a / k;
			END IF;
			k := k + 2;
			a := a / d;
		END LOOP;
		RAISE NOTICE ''k = %'', k;

		p := p - s;
		p := 4 * p;

		RETURN p;
	END;
' LANGUAGE plpgsql;
EOF
	
psql -c "select calc_pi()"


 
