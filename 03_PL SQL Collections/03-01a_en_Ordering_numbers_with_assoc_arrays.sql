-----------------------------------------------------------------------------
--                  Simple examples of using PL/SQL collections
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
/* Next procedure orders five numbers using function "f_the_N_th_from_5_numbers"
  from two previous scripts 
 This time we'll use an associative array */ 

CREATE OR REPLACE PROCEDURE p_order_5_numbers_with_aa (
    num1 IN NUMBER, 
    num2 IN NUMBER, 
    num3 IN NUMBER, 
    num4 IN NUMBER, 
    num5 IN NUMBER  ) 
AS
    TYPE v_type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER ;
    v_ v_type ;
    v_temp INTEGER ;
    is_ordered BOOLEAN := FALSE ;
BEGIN
    v_ (1) := num1 ;
    v_ (2) := num2 ;
    v_ (3) := num3 ;
    v_ (4) := num4 ;
    v_ (5) := num5 ;

    -- section with associative array ordering 
    WHILE is_ordered = FALSE LOOP
        is_ordered := TRUE ;
        FOR i IN 1..v_.COUNT - 1 LOOP
            IF v_ (i) < v_ (i + 1) THEN
                v_temp := v_ (i) ;
                v_ (i) := v_ (i + 1) ;
                v_ (i + 1) := v_temp ;
                is_ordered := FALSE ;
                EXIT ;
            END IF ;
    		END LOOP ;
  	END LOOP ;

    -- print results
    FOR i IN 1..v_.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE ('Number no. ' || i || ' is ' || v_(i)) ;
    END LOOP ;
END ;
/


-- test the procedure (launch the anonymous block from Oracle SQL Developer)
BEGIN
    p_order_5_numbers_with_aa (  4, 67, 45, 32, 22  ) ;
END ;
/


-----------------------------------------------------------------------------
/*   Generalization:
    Problem: Sort (order) N numbers !
    Solution with associative arrays:
    The procedure receives, as IN parameter, an associative array and oders it
      (no matter how many elements is has) 
    The associative array will be public, so we'll use a package
*/
CREATE OR REPLACE PACKAGE pac_aa
AS
    TYPE t_aa_numbers IS TABLE OF NUMBER INDEX BY PLS_INTEGER ;
    v_aa_numbers t_aa_numbers ;
    PROCEDURE p_order_an_aa (v_aa t_aa_numbers ) ;
END ;
/

-------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_aa 
AS

PROCEDURE p_order_an_aa ( v_aa t_aa_numbers ) 
IS
    v_va t_aa_numbers := v_aa ;
    v_temp INTEGER ;
    is_ordered BOOLEAN := FALSE ;
BEGIN
    -- ordonar the associative array 
    WHILE is_ordered = FALSE LOOP
        is_ordered := TRUE ;
        FOR i IN 1..v_va.COUNT - 1 LOOP
            IF v_va (i) < v_va (i + 1) THEN
                v_temp := v_va (i) ;
                v_va (i) := v_va (i + 1) ;
                v_va (i + 1) := v_temp ;
                is_ordered := FALSE ;
                EXIT ;
            END IF ;
    		END LOOP ;
  	END LOOP ;

    -- display the associative array
    FOR i IN 1..v_va.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE ('(Ranked) number no. ' || i || ' is ' || v_va(i)) ;
    END LOOP ;
END ;
END pac_aa ;
/

-- test (launch the anonymous block from Oracle SQL Developer)
DECLARE 
    v_aa1 pac_aa.t_aa_numbers ;
BEGIN 
    v_aa1 (1) := 1 ;
    v_aa1 (2) := 12 ;
    v_aa1 (3) := 23 ;
    v_aa1 (4) := 45 ;
    v_aa1 (5) := 67 ;
    v_aa1 (6) := 89 ;
    v_aa1 (7) := 3 ;
    pac_aa.p_order_an_aa ( v_aa1 ) ;
END ;
/



