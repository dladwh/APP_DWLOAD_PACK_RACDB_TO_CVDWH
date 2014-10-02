grant select on app_esdc81.mp_usuarios_pago to app_dwload;

create synonym app_dwload.mp_usuarios_pago for app_esdc81.mp_usuarios_pago;

select * from app_esdc81.mp_usuarios_pago;
/