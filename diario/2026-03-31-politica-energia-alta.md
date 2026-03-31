# Diario - 2026-03-31

## Proyecto

AdmiraNext Team

## Trabajo realizado

- Se ha integrado la politica de energia base del DreamTeam en el flujo de alta: hasta `4` horas enchufado y `1` hora en bateria.
- La regla queda documentada en `welcomePack` y reflejada tambien en `onboarding`.
- El `bootstrap .command` de alta aplica automaticamente `sudo pmset -c sleep 240` y `sudo pmset -b sleep 60` en Macs nuevos.

## Estado actual

- La politica de energia ya no depende de memoria informal ni de pasos manuales fuera del flujo de alta.
- El formulario de `AdmiraNext-Team` y su bootstrap muestran la misma regla para mantener coherencia entre documentacion y ejecucion.
