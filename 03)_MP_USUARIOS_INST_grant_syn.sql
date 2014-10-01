grant select on app_esdc81.mp_usuarios_inst to app_dwload;

create synonym app_dwload.mp_usuarios_inst for app_esdc81.mp_usuarios_inst;

select * from mp_usuarios_inst;