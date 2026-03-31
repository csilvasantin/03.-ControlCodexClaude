# 2026-03-31 · Fix de Pages para URLs faciles

AdmiraNext Team

## Trabajo realizado

- Detectado fallo real en GitHub Pages: las URLs `control.html`, `equipo.html` y `admin.html` existian en el repo pero no se copiaban al artefacto `_site`.
- Actualizado el workflow de Pages para incluir esos alias en el despliegue.
- Subida la version visible a `v2.3.2`.
- Subida la version del paquete a `0.3.2`.

## Resultado esperado

- URL publica corta de control:
  - `https://csilvasantin.github.io/AdmiraNext-Team/control.html`
- URL publica corta de equipo:
  - `https://csilvasantin.github.io/AdmiraNext-Team/equipo.html`
- URL publica corta de consejo:
  - `https://csilvasantin.github.io/AdmiraNext-Team/admin.html`
