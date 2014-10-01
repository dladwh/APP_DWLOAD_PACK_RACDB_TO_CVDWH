SET SERVEROUTPUT ON;
CLEAR BUFFER
SET ECHO OFF
SET TERMOUT ON
SET FEED ON
CLEAR SCREEN

set timing on
--alter session set time_zone = 'Mexico/General';

  declare
     cur_salida sys_refcursor;
  begin

     APP_DWLOAD.PACK_RACDB_TO_CVDWH.PR_CLIENTE_ORIGEN (P_OUT_CUR=>cur_salida );
     APP_DWLOAD.PACK_RACDB_TO_CVDWH.REFCURSOR_TO_FILE(P_cur => cur_salida, P_sep => ',', P_tablename => 'EXT_CLIENTE_ORIGEN', P_dir => 'EXTERNAL_TABLES', P_namefile => 'CLIENTE_ORIGEN.txt');

     APP_DWLOAD.PACK_RACDB_TO_CVDWH.PR_MP_USUARIOS_EXT (P_OUT_CUR=>cur_salida );
     APP_DWLOAD.PACK_RACDB_TO_CVDWH.REFCURSOR_TO_FILE(P_cur => cur_salida, P_sep => ',', P_tablename => 'EXT_MP_USUARIOS_EXT', P_dir => 'EXTERNAL_TABLES', P_namefile => 'MP_USUARIOS_EXT.txt');

     APP_DWLOAD.PACK_RACDB_TO_CVDWH.PR_MP_USUARIOS_INST (P_OUT_CUR=>cur_salida );
     APP_DWLOAD.PACK_RACDB_TO_CVDWH.REFCURSOR_TO_FILE(P_cur => cur_salida, P_sep => ',', P_tablename => 'EXT_MP_USUARIOS_INST', P_dir => 'EXTERNAL_TABLES', P_namefile => 'MP_USUARIOS_INST.txt');

     APP_DWLOAD.PACK_RACDB_TO_CVDWH.PR_MP_USUARIOS_PASE(P_OUT_CUR=>cur_salida );
     APP_DWLOAD.PACK_RACDB_TO_CVDWH.REFCURSOR_TO_FILE(P_cur => cur_salida, P_sep => ',', P_tablename => 'EXT_MP_USUARIOS_PASE', P_dir => 'EXTERNAL_TABLES', P_namefile => 'MP_USUARIOS_PASE.txt');

  end;
  /