grant select on app_esdc81.usuario_dispositivo to app_dwload;

create synonym app_dwload.usuario_dispositivo for app_esdc81.usuario_dispositivo;

select * from app_esdc81.mp_usuarios_pago;