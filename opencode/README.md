# Opencode Overlay - Dotfiles Integration

Este directorio contiene **tus personalizaciones** de opencode que se mergean sobre la configuración base instalada por [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai).

## Como funciona

`gentle-ai` instala y actualiza la configuración base en `~/.config/opencode/`. Este overlay te permite:

1. **Añadir skills personalizados** sin perder los de gentle-ai
2. **Sobreescribir configuraciones** específicas de `opencode.json`
3. **Añadir agentes personalizados** adicionales a los SDD
4. **Extender `AGENTS.md`** con tus propias reglas

## Estructura

```
opencode/
├── overlay.json          # Overrides de configuración (merge con opencode.json)
├── skills/               # Tus skills personalizados (se añaden a los existentes)
│   └── ejemplo/
│       └── SKILL.md
├── agents/               # Tus agentes personalizados
│   └── mi-agente.md
├── AGENTS.md             # Reglas adicionales (se concatenan al existente)
└── README.md             # Este archivo
```

## Uso

### Sincronizar (aplicar overlay)

```bash
# Manual
~/dotfiles/scripts/opencode-sync.sh

# O desde el directorio de dotfiles
./scripts/opencode-sync.sh
```

### Qué hace el sync

1. **Backup**: Crea backup de `~/.config/opencode/` (solo archivos que van a modificarse)
2. **Merge JSON**: Combina `overlay.json` con `~/.config/opencode/opencode.json`
3. **Skills**: Copia tus skills de `skills/` a `~/.config/opencode/skills/`
4. **Agents**: Añade tus agentes de `agents/` al `opencode.json`
5. **AGENTS.md**: Concatena tu `AGENTS.md` al existente (marcado con comentarios)

### Después de actualizar gentle-ai

Cada vez que `gentle-ai` se actualiza (vía `gentle-ai sync` o re-instalación), corre:

```bash
~/dotfiles/scripts/opencode-sync.sh
```

Para re-aplicar tus personalizaciones.

## Reglas de Merge

### overlay.json

- Se mergea a nivel de claves de primer nivel
- Tus claves **sobreescriben** las de gentle-ai
- Para arrays (como `mcp.servers`), se reemplaza completamente
- Usa `null` para eliminar una clave del base

### skills/

- Se copian directorios completos
- Si un skill ya existe en gentle-ai, se **sobreescribe** con tu versión
- Usa nombres únicos para evitar conflictos

### agents/

- Se añaden al objeto `agent` de `opencode.json`
- Si el nombre coincide con uno existente, se **sobreescribe**

### AGENTS.md

- Se añade al final del archivo existente
- Envuelto en comentarios de demarcación:
  ```markdown
  <!-- dotfiles-overlay:start -->
  ## Mis Reglas Adicionales
  ...
  <!-- dotfiles-overlay:end -->
  ```

## Ejemplos

### Añadir un MCP personalizado

`overlay.json`:
```json
{
  "mcp": {
    "mi-mcp": {
      "type": "local",
      "command": ["/usr/local/bin/mi-mcp"]
    }
  }
}
```

### Añadir un skill personalizado

Crear `skills/mi-skill/SKILL.md` con las instrucciones del agente.

### Añadir un agente personalizado

Crear `agents/mi-agente.md` con la definición del agente.

## Notas

- **No commitees** `~/.config/opencode/` en este repo - eso lo gestiona gentle-ai
- **Sí commitees** este directorio `opencode/` con tus personalizaciones
- El script de sync es idempotente - puedes correrlo múltiples veces
