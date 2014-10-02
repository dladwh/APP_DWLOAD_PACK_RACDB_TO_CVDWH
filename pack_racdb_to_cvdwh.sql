--------------------------------------------------------
-- Archivo creado  - miércoles-octubre-01-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_RACDB_TO_CVDWH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "APP_DWLOAD"."PACK_RACDB_TO_CVDWH" 
IS
  C_delim_vis CONSTANT VARCHAR2(1) := '|';
--------------------------------------------------------------------------------
  PROCEDURE PR_CLIENTE_ORIGEN(P_out_cur OUT Sys_refcursor);
--------------------------------------------------------------------------------
  PROCEDURE PR_MP_USUARIOS_EXT(P_out_cur OUT Sys_refcursor);
--------------------------------------------------------------------------------
  PROCEDURE PR_MP_USUARIOS_INST(p_out_cur OUT sys_refcursor);
--------------------------------------------------------------------------------
  PROCEDURE PR_MP_USUARIOS_PASE(p_out_cur OUT sys_refcursor);
--------------------------------------------------------------------------------
  PROCEDURE PR_MP_USUARIOS_PAGO(p_out_cur OUT sys_refcursor);
--------------------------------------------------------------------------------
  PROCEDURE REFCURSOR_TO_FILE(
      P_cur IN OUT Sys_refcursor ,
      P_sep IN VARCHAR2 DEFAULT '|' ,
      P_tablename IN VARCHAR2 ,
      P_dir IN VARCHAR2 ,
      P_namefile IN VARCHAR2);
--------------------------------------------------------------------------------
END PACK_RACDB_TO_CVDWH;

/
--------------------------------------------------------
--  DDL for Package Body PACK_RACDB_TO_CVDWH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "APP_DWLOAD"."PACK_RACDB_TO_CVDWH" 
Is
--------------------------------------------------------------------------------
   Procedure PR_CLIENTE_ORIGEN (P_out_cur Out Sys_refcursor) Is
   Begin
      DBMS_APPLICATION_INFO.Set_action (Action_name => 'PR_CLIENTE_ORIGEN');
      Open P_out_cur For
         Select 0,'WEB' from dual
         union
         Select 1,'LITE' from dual
         union
         Select 2,'TOMAPEDIDO' from dual
         union
         Select 3,'CAJA' from dual
         union
         Select 4,'PROMO_C4' from dual
         union
         Select 5,'EQ6MESES' from dual;
   Exception
      When Others Then
         Raise_application_error (-20000, 'PR_CLIENTE_ORIGEN' || SQLERRM);
   End PR_CLIENTE_ORIGEN;
--------------------------------------------------------------------------------
   Procedure PR_MP_USUARIOS_EXT (P_out_cur Out Sys_refcursor) Is
   Begin
      DBMS_APPLICATION_INFO.Set_action (Action_name => 'PR_MP_USUARIOS_EXT');
      Open P_out_cur For
         SELECT id_usuario   AS id_cliente,
          id_usuario_account AS id_cuenta,
          id_usuario_partner AS mail,
          nombre             AS nombre,
          apellido           AS apellido,
          id_usuario_product AS paquete,
          empleado_id        AS empleado_id,
          id_origen          AS id_origen,
          to_char(terminos_aceptados,'YYYYMMDD') AS terminos_aceptados
           FROM mp_usuarios_ext
          WHERE 1 = 1
          AND id_usuario_account IS NOT NULL
          AND USER_PRODUCT_TYPE IS NOT NULL
          AND id_instalacion = 8140 ;
   Exception
      When Others Then
         Raise_application_error (-20000, 'PR_MP_USUARIOS_EXT' || SQLERRM);
   End PR_MP_USUARIOS_EXT;
--------------------------------------------------------------------------------
   procedure PR_MP_USUARIOS_INST(p_out_cur Out  sys_refcursor) is
   begin
        DBMS_APPLICATION_INFO.Set_action (Action_name => 'PR_MP_USUARIOS_INST');
        Open P_out_cur For
        select id_usuario     as id_cliente,
                to_char(fecha_login,'YYYYMMDDHH24MI')    as fecha_login
        from  mp_usuarios_inst
        where id_instalacion = 8140;
   Exception
        When Others Then
        Raise_application_error (-20000, 'PR_MP_USUARIOS_INST' || SQLERRM);
   end PR_MP_USUARIOS_INST;
--------------------------------------------------------------------------------
   procedure PR_MP_USUARIOS_PASE(p_out_cur Out  sys_refcursor) is
   begin
        DBMS_APPLICATION_INFO.Set_action (Action_name => 'PR_MP_USUARIOS_PASE');
        Open P_out_cur For
        select id_usuario          as id_cliente, 
                id_pase             as id_pase, 
                username            as username,
                to_char(fecha_alta,'YYYYMMDD') as fecha_alta, 
                to_char(fecha_modificacion,'YYYYMMDD')  as fecha_modificacion, 
                to_char(baja_logica,'YYYYMMDDHH24MI')         as baja_logica
        from  mp_usuarios_pase;
   Exception
        When Others Then
        Raise_application_error (-20000, 'PR_MP_USUARIOS_PASE' || SQLERRM);
      
   end PR_MP_USUARIOS_PASE;
--------------------------------------------------------------------------------
   PROCEDURE PR_MP_USUARIOS_PAGO(p_out_cur OUT sys_refcursor) is
   begin
        DBMS_APPLICATION_INFO.Set_action (Action_name => 'PR_MP_USUARIOS_PAGO');
        Open P_out_cur For
        select id_usuario as id_cliente, 
                pin        as pin, 
                estado     as estado
        from  MP_USUARIOS_PAGO;
   Exception
        When Others Then
        Raise_application_error (-20000, 'PR_MP_USUARIOS_PASE' || SQLERRM);
      
   end PR_MP_USUARIOS_PAGO;
--------------------------------------------------------------------------------
   Procedure REFCURSOR_TO_FILE (
      P_cur        In Out   Sys_refcursor
    , P_sep        in       varchar2 default '|'
    , P_tablename  in       varchar2
    , P_dir        In       Varchar2
    , P_namefile   In       Varchar2)
   Is
      C_cur        Sys_refcursor;
      V_desc       DBMS_SQL.Desc_tab;
      V_cols       Binary_integer;
      V_cursor     Binary_integer;
      V_data       Varchar2 (32767);
      V_varchar2   Varchar2 (4000);
      V_number     Number;
      V_date       Date;
      V_current    Pls_integer;
      File         UTL_FILE.File_type;
   Begin
      V_cursor   := DBMS_SQL.To_cursor_number (P_cur);
      DBMS_SQL.Describe_columns (V_cursor, V_cols, V_desc);
      For I In 1 .. V_cols
      Loop
         If V_desc (I).Col_type = 2 Then
            DBMS_SQL.Define_column (V_cursor, I, V_number);
         Elsif V_desc (I).Col_type = 12 Then
            DBMS_SQL.Define_column (V_cursor, I, V_date);
         Else
            DBMS_SQL.Define_column (V_cursor, I, V_varchar2, 4000);
         End If;
      End Loop;
      File       := UTL_FILE.Fopen ('EXTERNAL_TABLES', P_namefile, 'W', 4096);
      V_current  := 0;
      While DBMS_SQL.Fetch_rows (V_cursor) > 0
      Loop
         V_current  := V_current + 1;
         V_data     := Null;
         For I In 1 .. V_cols
         Loop
            If V_desc (I).Col_type = 2 Then
               DBMS_SQL.COLUMN_VALUE (V_cursor, I, V_number);
               V_data  := V_data || Ltrim (LPAD (V_number, V_desc (I).Col_max_len + 1) );
            Elsif V_desc (I).Col_type = 12 Then
               DBMS_SQL.COLUMN_VALUE (V_cursor, I, V_date);
               V_data  := V_data || Rtrim (RPAD (V_date, 22) );
            Else
               DBMS_SQL.COLUMN_VALUE (V_cursor, I, V_varchar2);
               V_data  := V_data || '"' || Rtrim (RPAD (V_varchar2, V_desc (I).Col_max_len + 1) ) || '"';
            End If;
            V_data  := V_data || P_sep ;
         End Loop;
         V_data := 'D'||','||substr(V_data,1,length(V_data)-1);
         UTL_FILE.Put_line (File, V_data);
      End Loop;
      DBMS_SQL.Close_cursor (V_cursor);
      UTL_FILE.Put_line (File, 'T'|| ','|| to_char(trunc(sysdate),'YYYYMMDD')|| ','|| to_char(trunc(sysdate,'MONTH'),'YYYYMMDD')|| ','|| LPAD(V_current,7,'0')|| ',' || P_tablename);
      UTL_FILE.Fclose (File);
   End REFCURSOR_TO_FILE;
--------------------------------------------------------------------------------
End PACK_RACDB_TO_CVDWH;

/
