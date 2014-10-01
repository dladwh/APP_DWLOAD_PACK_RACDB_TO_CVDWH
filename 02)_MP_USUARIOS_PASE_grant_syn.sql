grant select on app_esdc81.mp_usuarios_pase to app_dwload;

create synonym app_dwload.mp_usuarios_pase for app_esdc81.mp_usuarios_pase;

select * from mp_usuarios_pase;