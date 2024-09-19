SET SERVEROUTPUT ON;

DECLARE
    vId cliente.id%type;
    vRazSocial cliente.razao_social%type;
    CURSOR cCliente IS select id, razao_social from cliente;
BEGIN
    OPEN cCliente;
    LOOP
        FETCH cCliente INTO vId, vRazSocial;
    EXIT WHEN cCliente%NOTFOUND;
    
    dbms_output.put_line('ID = ' || vId || ', RAZAO = ' || vRazSocial);
    
    END LOOP;
    CLOSE cCliente;

END;


SET SERVEROUTPUT ON;
DECLARE
    vNome tab_fetch.nome%type;
    vValor tab_fetch.valor%type;
    vValorAcumulado float :=0;
    CURSOR cValor IS select tab_fetch.nome , tab_fetch.valor from tab_fetch where mod(id,2) =0;
BEGIN
     OPEN cValor;
     FETCH cValor INTO  vNome, vValor;
    
    LOOP
    
        vValorAcumulado := vValorAcumulado+vValor;
    EXIT WHEN vValorAcumulado >= 30;    
      FETCH cValor INTO  vNome, vValor;       
      
    END LOOP;

    CLOSE cValor;
    
    dbms_output.put_line(' VALOR DO PRODUTO = ' || vNome );    

END;

create or replace PROCEDURE SOMA_VENDAS_CURSOR 
(p_VENDA_LIMITE IN produto_venda_exercicio.valor_total%type, p_ID_RETORNO OUT produto_venda_exercicio.id%type)
IS
   v_ID produto_venda_exercicio.id%type := 1;
   v_VALOR_TOTAL produto_venda_exercicio.valor_total%type;
   v_VENDA_TOTAL produto_venda_exercicio.valor_total%type := 0;
   CURSOR cur_VENDA IS SELECT ID FROM PRODUTO_VENDA_EXERCICIO;
BEGIN
   OPEN cur_VENDA;
   LOOP
      FETCH cur_VENDA INTO v_ID;
      SELECT VALOR_TOTAL INTO v_VALOR_TOTAL FROM PRODUTO_VENDA_EXERCICIO WHERE ID = v_ID;
      v_VENDA_TOTAL := v_VENDA_TOTAL + v_VALOR_TOTAL;
      IF v_VENDA_TOTAL >= p_VENDA_LIMITE THEN
         EXIT;
      END IF;
      EXIT WHEN cur_VENDA%NOTFOUND;
   END LOOP;
   CLOSE cur_VENDA;
   p_ID_RETORNO := v_ID;
END;

SET SERVEROUTPUT ON;
DECLARE
   v_NUM INTEGER;
BEGIN
   SOMA_VENDAS_CURSOR(20000, v_NUM);
   dbms_output.put_line(v_NUM);
END;

create or replace PROCEDURE SOMA_VENDAS_CURSOR_WHILE 
(p_VENDA_LIMITE IN produto_venda_exercicio.valor_total%type, p_ID_RETORNO OUT produto_venda_exercicio.id%type)
IS
   v_ID produto_venda_exercicio.id%type := 1;
   v_VALOR_TOTAL produto_venda_exercicio.valor_total%type;
   v_VENDA_TOTAL produto_venda_exercicio.valor_total%type := 0;
   CURSOR cur_VENDA IS SELECT ID FROM PRODUTO_VENDA_EXERCICIO;
BEGIN
   OPEN cur_VENDA;
   FETCH cur_VENDA INTO v_ID;
   WHILE ((v_VENDA_TOTAL < p_VENDA_LIMITE) AND cur_VENDA%FOUND) LOOP
      SELECT VALOR_TOTAL INTO v_VALOR_TOTAL FROM PRODUTO_VENDA_EXERCICIO WHERE ID = v_ID;
      v_VENDA_TOTAL := v_VENDA_TOTAL + v_VALOR_TOTAL;
      IF v_VENDA_TOTAL < p_VENDA_LIMITE THEN
         FETCH cur_VENDA INTO v_ID;
      END IF ;
   END LOOP;
   CLOSE cur_VENDA;
   p_ID_RETORNO := v_ID;
END;

SET SERVEROUTPUT ON;
DECLARE
   v_NUM INTEGER;
BEGIN
   SOMA_VENDAS_CURSOR_WHILE(20000, v_NUM);
   dbms_output.put_line(v_NUM);
END;


create or replace PROCEDURE SOMA_VENDAS_CURSOR_FOR 
(p_VENDA_LIMITE IN produto_venda_exercicio.valor_total%type, p_ID_RETORNO OUT produto_venda_exercicio.id%type)
IS
   v_ID produto_venda_exercicio.id%type := 1;
   v_VALOR_TOTAL produto_venda_exercicio.valor_total%type;
   v_VENDA_TOTAL produto_venda_exercicio.valor_total%type := 0;
   CURSOR cur_VENDA IS SELECT ID FROM PRODUTO_VENDA_EXERCICIO;
BEGIN
   FOR linha_cur_VENDA IN cur_VENDA LOOP
      v_ID := linha_cur_VENDA.ID;
      SELECT VALOR_TOTAL INTO v_VALOR_TOTAL FROM PRODUTO_VENDA_EXERCICIO WHERE ID = v_ID;
      v_VENDA_TOTAL := v_VENDA_TOTAL + v_VALOR_TOTAL;
      IF v_VENDA_TOTAL >= p_VENDA_LIMITE THEN
         EXIT;
      END IF;
   END LOOP;
   p_ID_RETORNO := v_ID;
END;

SET SERVEROUTPUT ON;
DECLARE
   v_NUM INTEGER;
BEGIN
   SOMA_VENDAS_CURSOR_FOR(20000, v_NUM);
   dbms_output.put_line(v_NUM);
END;