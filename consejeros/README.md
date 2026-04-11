# Consejeros — Perfiles de las 8 sillas del consejo

Cada archivo JSON define un consejero con su personalidad, dominio y configuracion de bot de Telegram.

## Lado operativo (izquierda)

| Silla | Rol | Archivo | Bot |
|-------|-----|---------|-----|
| 1 | CEO | `ceo.json` | @AdmiraNext_CEO_bot |
| 2 | CFO | `cfo.json` | @AdmiraNext_CFO_bot |
| 3 | COO | `coo.json` | @AdmiraNext_COO_bot |
| 4 | CTO | `cto.json` | @AdmiraNext_CTO_bot |

## Lado creativo (derecha)

| Silla | Rol | Archivo | Bot |
|-------|-----|---------|-----|
| 5 | CCO | `cco.json` | @AdmiraNext_CCO_bot |
| 6 | CSO | `cso.json` | @AdmiraNext_CSO_bot |
| 7 | CXO | `cxo.json` | @AdmiraNext_CXO_bot |
| 8 | CDO | `cdo.json` | @AdmiraNext_CDO_bot |

## Parejas coetaneas

- CEO <-> CSO (direccion + estrategia)
- CFO <-> CDO (caja + datos/metricas)
- COO <-> CXO (operaciones + experiencia)
- CTO <-> CCO (tecnologia + mercado/marca)

## Configuracion

Cada bot necesita su token de Telegram (crear via @BotFather).
Los tokens se configuran en el `.env` de Yarig.Telegram:

```
BOT_TOKEN_CEO=token_del_bot_ceo
BOT_TOKEN_CFO=token_del_bot_cfo
...
```

Arranque: `python -m src.consejeros_runner` desde Yarig.Telegram.
