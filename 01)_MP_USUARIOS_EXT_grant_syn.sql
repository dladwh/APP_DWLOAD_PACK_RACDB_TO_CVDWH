grant select on app_esdc81.mp_usuarios_ext to app_dwload;

create synonym app_dwload.mp_usuarios_ext for app_esdc81.mp_usuarios_ext;

select * from mp_usuarios_ext;