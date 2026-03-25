# Suggerimenti per migliorare la configurazione NewVim

> Analisi basata sul confronto con LazyVim v15 e focus su sviluppo agentico (Claude Code + OpenCode).

---

## Stato attuale

La config è solida e ben organizzata: ~36 plugin, lazy.nvim, blink.cmp, conform.nvim, fzf-lua, snacks.nvim, nvim-ufo. Tutto modulare e pulito.

**Gap principali:**

- Nessun plugin AI/agentico installato
- Nessun linter asincrono (solo diagnostics LSP)
- Navigazione rapida assente (no flash/leap)
- Text objects limitati (no mini.ai, no treesitter-textobjects)
- Nessun task runner
- Keymaps Copilot orfani da rimuovere
- Markdown non renderizzato in-buffer

---

## 1. Plugin AI / Agentici

### claudecode.nvim

> **Integrazione diretta di Claude Code in NeoVim via WebSocket MCP.**

Plugin Lua puro, zero dipendenze. Implementa lo stesso protocollo WebSocket dell'estensione VS Code ufficiale. Claude Code vede il file aperto, la posizione del cursore e le selezioni. Quando Claude propone modifiche, apre una diff view nativa — accetti con `<leader>aa`, rifiuti con `<leader>ad`.

**Funzionalità principali:**

- Toggle del terminale Claude Code (`<leader>ac`)
- Invio selezioni/buffer come contesto (`<leader>as`, `<leader>ab`)
- Diff view nativa per accept/reject delle modifiche
- Si integra con neo-tree, snacks terminal, oil.nvim
- Claude vede i diagnostics del tuo editor in tempo reale
- Resume/continue conversazioni precedenti

**Keybindings:**

| Key           | Azione                          |
| ------------- | ------------------------------- |
| `<leader>ac`  | Toggle Claude Code              |
| `<leader>af`  | Focus su Claude                 |
| `<leader>ar`  | Resume conversazione            |
| `<leader>am`  | Seleziona modello               |
| `<leader>ab`  | Aggiungi buffer come contesto   |
| `<leader>as`  | Invia selezione visuale         |
| `<leader>aa`  | Accetta diff                    |
| `<leader>ad`  | Rifiuta diff                    |

**Priorità: ALTISSIMA** — È il ponte tra NeoVim e Claude Code. Senza questo, perdi la consapevolezza del contesto che Claude può avere del tuo editor.

---

### avante.nvim

> **Assistente AI in stile Cursor IDE: chat + editing inline direttamente nel buffer.**

Chat interattivo con l'AI sul codice corrente. Le suggestioni si applicano con un click. Supporta più provider (Claude API diretta, Copilot, OpenAI, ecc.). Ha uno "Zen Mode" che replica l'esperienza CLI-agent dentro NeoVim.

**Funzionalità principali:**

- Chat con l'AI sul file/selezione corrente
- Apply one-click delle modifiche suggerite
- File `avante.md` nella root del progetto per istruzioni persistenti all'AI
- Multi-provider: Anthropic, OpenAI, Copilot, custom
- Supporto per incollare immagini (via img-clip.nvim)
- Rendering markdown delle risposte (via render-markdown.nvim)

**Priorità: ALTA** — Complementare a claudecode.nvim. Avante è per edit rapidi inline ("rinomina questa variabile", "aggiungi error handling qui"), Claude Code è per task complessi multi-file.

---

### Terminale dedicato per OpenCode

> **OpenCode non ha un plugin NeoVim — va integrato via terminale snacks.nvim.**

Dato che usi già snacks.nvim per i terminali, puoi creare un keybinding dedicato (es. `<leader>ao`) che apre OpenCode in un floating terminal specifico. Così lo lanci e ci torni con un tasto, senza configurazioni extra.

**Priorità: ALTA** — Soluzione semplice, un keybinding e hai OpenCode integrato.

---

## 2. Navigazione e Motion

### flash.nvim

> **Navigazione fulminea: label sui risultati di ricerca, motion multi-linea, selezione treesitter.**

Durante `/` o `?`, appaiono label accanto ai risultati — premi un carattere e salti istantaneamente. La modalità treesitter etichetta tutti i nodi sintattici parent per selezione strutturale rapida. Funziona anche cross-window.

**Funzionalità principali:**

- Label sui risultati di ricerca (`/`, `?`) per jump in 1-2 tasti
- Enhanced `f`/`t`/`F`/`T` con supporto multi-linea
- Treesitter mode (`S`): seleziona nodi sintattici (funzione, blocco, classe)
- Jump cross-window
- Dot-repeatable
- Modalità exact, regex, fuzzy

**Keybindings:**

| Key      | Azione                               |
| -------- | ------------------------------------ |
| `s`      | Flash jump (search + label)          |
| `S`      | Flash treesitter (seleziona nodo)    |
| `r`      | Remote flash (operator-pending)      |
| `<C-s>`  | Toggle flash durante search          |

**Priorità: MEDIA** — Quando fai review del codice generato dall'AI, la navigazione rapida è cruciale. Flash ti porta ovunque in 2-3 tasti.

---

## 3. Text Objects e Editing strutturale

### mini.ai

> **Text objects `a`/`i` (around/inside) estesi e personalizzabili con integrazione treesitter.**

Tutti i text objects built-in più quelli custom. Con treesitter: `vaf` seleziona tutta la funzione, `vac` tutta la classe, `vaa` il parametro. Supporta "next" (`an`/`in`) e "last" (`al`/`il`) per targettare oggetti non sotto il cursore.

**Funzionalità principali:**

- Text objects per funzioni, classi, parametri, tag HTML, blocchi
- Varianti next/last: opera su oggetti adiacenti senza muovere il cursore
- `g[`/`g]` per saltare ai bordi del text object
- Dot-repeatable, compatibile con count
- Definizioni custom via pattern Lua

**Keybindings (esempi):**

| Key     | Azione                           |
| ------- | -------------------------------- |
| `vaf`   | Seleziona around function        |
| `vif`   | Seleziona inner function         |
| `vac`   | Seleziona around class           |
| `vaa`   | Seleziona around parameter       |
| `vanf`  | Seleziona prossima funzione      |

**Priorità: MEDIA** — Perfetto per selezionare contesto preciso da inviare a Claude (`<leader>as` dopo `vaf`). Un motion e hai tutta la funzione selezionata.

---

### nvim-treesitter-textobjects

> **Navigazione e selezione strutturale basata sul parse tree: salta tra funzioni, classi, parametri.**

Complementare a mini.ai ma focalizzato sulla navigazione. Salta alla prossima/precedente funzione, classe, parametro. Swap di nodi adiacenti. Peek della definizione senza saltare.

**Funzionalità principali:**

- **Select:** `@function.inner/outer`, `@class.inner/outer`, `@parameter.inner/outer`, `@loop.inner`, `@conditional.outer`
- **Move:** Jump a inizio/fine di funzione/classe (popola jumplist)
- **Swap:** Scambia parametri, funzioni o qualsiasi nodo adiacente
- **Peek:** Preview della posizione senza saltare
- Movimenti ripetibili con `;`/`,`

**Keybindings tipici:**

| Key           | Azione                          |
| ------------- | ------------------------------- |
| `]m` / `[m`   | Prossima/precedente funzione    |
| `]M` / `[M`   | Fine prossima/precedente funz.  |
| `]c` / `[c`   | Prossima/precedente classe      |
| `<leader>a`   | Swap parametro avanti           |
| `<leader>A`   | Swap parametro indietro         |

**Priorità: MEDIA** — `]m`/`[m` per saltare tra funzioni durante review di codice AI è indispensabile. Lo swap dei parametri è comodo quando l'AI li mette nell'ordine sbagliato.

---

## 4. Search & Replace

### grug-far.nvim

> **UI completa per find-and-replace multi-file con ripgrep, ast-grep, diff preview e editing inline.**

Non è un semplice search-replace. Usa ripgrep per regex e ast-grep per matching strutturale (AST). Mostra diff preview in tempo reale, permette di editare i risultati inline e sincronizzare le modifiche ai file sorgente.

**Funzionalità principali:**

- Ricerca live debounced mentre digiti
- Diff preview before/after del replacement
- Editing inline dei risultati con sync-back ai file
- ast-grep: trasformazioni strutturali (non solo testo)
- Scoping: buffer corrente, lista buffer, quickfix
- History delle ricerche (auto/manual save)
- Selezione visuale come range di ricerca (`:GrugFarWithin`)

**Keybinding tipico:** `<leader>sr` — apre Search & Replace

**Priorità: MEDIA** — Dopo che l'AI fa modifiche, spesso serve follow-up refactoring. Il motore ast-grep è particolarmente potente: fa trasformazioni a livello di codice, non di testo.

---

## 5. Linting

### nvim-lint

> **Linter asincrono che riporta risultati tramite `vim.diagnostic` nativo.**

200+ linter preconfigurati (ESLint, Ruff, ShellCheck, golangci-lint...). Esecuzione asincrona, non blocca l'editing. I risultati appaiono come diagnostics nativi (virtual text, segni, underline).

**Funzionalità principali:**

- Trigger su BufWritePost, BufReadPost, InsertLeave (configurabile)
- Debounce 100ms
- Configurazione per-filetype con fallback
- Definizioni linter custom con parser (SARIF, errorformat, pattern)
- I diagnostics alimentano la consapevolezza di Claude via claudecode.nvim

**Priorità: MEDIA** — Il codice AI può avere problemi sottili che i linter catturano oltre all'LSP. I diagnostics extra vengono visti anche da Claude, che può auto-fixarli.

---

## 6. UI e Contesto

### nvim-treesitter-context

> **Header sticky in cima alla finestra che mostra la funzione/classe/blocco corrente mentre scrolli.**

Mostra la firma della funzione, la dichiarazione della classe o il loop in cui ti trovi, pinned in cima alla finestra. Configurabile per numero massimo di righe.

**Perché serve:** Quando navighi file grandi modificati dall'AI, sai sempre "in che funzione sono" senza scrollare su. Supporta 70+ linguaggi.

**Priorità: MEDIA**

---

### tiny-inline-diagnostic.nvim

> **Diagnostics inline belli e leggibili al posto del virtual text default di NeoVim.**

8 preset di stile (modern, classic, minimal, powerline, ghost...). Rendering multilinea, mostra la source del diagnostico (quale LSP l'ha riportato), codici errore, informazioni correlate. Gestione overflow (wrap, truncate, single-line).

**Perché serve:** Il virtual text default di NeoVim tronca i messaggi lunghi. Quando l'AI genera codice con errori, serve vedere il diagnostico completo con la source per comunicarlo precisamente a Claude.

**Priorità: BASSA-MEDIA**

---

### dropbar.nvim

> **Breadcrumb winbar cliccabile con dropdown menu, backed da LSP + treesitter + path.**

Mostra il percorso del simbolo corrente nella winbar (es. `file > class > method > if-block`). Ogni componente è cliccabile e apre un dropdown con i simboli fratelli. Modalità pick da tastiera con shortcut.

**Perché serve:** Complemento a treesitter-context — questo ti dice "dove sei nella gerarchia", context ti dice "cosa c'è sopra di te". I dropdown permettono di saltare tra metodi fratelli senza cercare.

**Priorità: BASSA-MEDIA**

---

### render-markdown.nvim

> **Rendering markdown in-buffer: headings, code blocks, tabelle, checkbox, callout, LaTeX.**

Renderizza solo il range visibile (performance). Modale: vista renderizzata in normal mode, raw in insert mode. Anti-conceal: mostra il testo raw solo sulla riga del cursore.

**Funzionalità principali:**

- Headings con icone, colori, bordi
- Code blocks con icona linguaggio e syntax highlighting
- Tabelle con bordi configurabili
- Callout GitHub/Obsidian
- LaTeX → unicode
- Integrazione diretta con avante.nvim (dipendenza opzionale)
- Preset: Obsidian, LazyVim

**Perché serve:** Le risposte di Claude e i file `avante.md` sono markdown. Render-markdown li rende leggibili in-buffer — tabelle vere, code blocks colorati, LaTeX renderizzato. Se usi avante.nvim, questo plugin è quasi obbligatorio.

**Priorità: MEDIA** (ALTA se installi avante.nvim)

---

## 7. Produttività e Workflow

### harpoon v2

> **File marks rapidi per i 3-5 file su cui lavori attivamente, con switch istantaneo via numero.**

Segna i file in una lista persistente per-progetto. Switch istantaneo: `<C-h>` file 1, `<C-t>` file 2, ecc. Menu rapido per vedere/riordinare. Persistente tra sessioni.

**Perché serve:** Durante una sessione agentica, rimbalzi sempre tra gli stessi file (il file che Claude sta editando, il test, il config, i tipi). Harpoon elimina l'overhead del fuzzy finder — un tasto per file.

**Priorità: BASSA-MEDIA**

---

### overseer.nvim

> **Task runner e job manager con UI per definire, eseguire e monitorare task in background.**

Supporta make, npm, cargo, `.vscode/tasks.json`. Panel UI per task attivi. Diagnostics integration. Workflow multi-stage con dipendenze tra task. Rerun on save.

**Perché serve:** Chiude il loop agentico: Claude scrive codice → tu runni il task → vedi gli errori → li mandi a Claude. Senza overseer, devi aprire terminali manuali.

**Priorità: BASSA-MEDIA**

---

### lazydev.nvim

> **Caricamento lazy delle type annotations Lua per LuaLS — completamento veloce per config NeoVim.**

Carica solo i tipi dei moduli che effettivamente `require()` nei file aperti. Molto più veloce che caricare tutto. Rimpiazza il deprecato neodev.nvim. Integrazione con blink.cmp.

**Perché serve:** Stai configurando NeoVim in Lua. Senza lazydev, LuaLS o carica tutto (lento) o non sa nulla dei tuoi plugin. Quando Claude edita la tua config, lazydev assicura diagnostics corretti.

**Priorità: BASSA-MEDIA**

---

### inc-rename.nvim

> **LSP rename con preview in tempo reale — vedi tutti gli usi aggiornarsi mentre digiti il nuovo nome.**

Preview incrementale usando `inccommand` di NeoVim. Multi-file con preview buffer. Si integra con noice.nvim e dressing.nvim.

**Perché serve:** L'AI a volte usa nomi generici o inconsistenti. Inc-rename ti fa fixare il naming in tutto il progetto con feedback visivo live.

**Priorità: BASSA**

---

### edgy.nvim

> **Layout manager per finestre sidebar/panel: organizza automaticamente i pannelli nelle posizioni designate.**

Sposta automaticamente le finestre (incluse quelle floating) in posizioni edge configurate (left, right, top, bottom). Funziona con neo-tree, trouble, overseer, terminali.

**Perché serve:** Con Claude Code in un terminale split + file explorer + overseer + trouble, le finestre diventano caotiche. Edgy blocca ogni pannello nella sua posizione.

**Priorità: BASSA**

---

## 8. Moduli snacks.nvim da abilitare

Usi già snacks.nvim ma probabilmente solo dashboard + terminal. Moduli utili da attivare:

| Modulo        | Cosa fa                                                        |
| ------------- | -------------------------------------------------------------- |
| **bigfile**   | Disabilita feature pesanti su file grandi (utile con output AI)|
| **lazygit**   | LazyGit in floating window per review commit AI                |
| **scratch**   | Buffer scratch persistenti per esperimenti rapidi con Claude   |
| **dim**       | Dimma il codice fuori scope — focus su ciò che discuti con AI  |
| **indent**    | Guide indent e scope                                           |
| **quickfile** | Rendering rapido prima che i plugin carichino                  |
| **words**     | Auto-show referenze LSP, navigazione rapida tra esse           |
| **gitbrowse** | Apri file/commit nel browser                                   |
| **rename**    | Rename file con aggiornamento LSP                              |
| **scope**     | Scope detection + text objects + jumping                       |

---

## 9. Cleanup

- **Rimuovere keymaps Copilot orfani** (`<C-]>`, `<C-[>`, `<C-}>`, `<C-{>`) in `keymaps.lua`
- **Considerare migrazione a lspconfig v2** (`vim.lsp.config` + `vim.lsp.enable`) se su Neovim 0.11+
- **Abilitare format-on-save togglabile** (`<leader>uf`) — utile quando l'AI genera codice

---

## Riepilogo per priorità

| Priorità       | Plugin                                | Categoria          |
| -------------- | ------------------------------------- | ------------------ |
| **ALTISSIMA**  | claudecode.nvim                       | AI/Agentico        |
| **ALTA**       | avante.nvim                           | AI/Agentico        |
| **ALTA**       | Terminale dedicato OpenCode           | AI/Agentico        |
| **MEDIA**      | flash.nvim                            | Navigazione        |
| **MEDIA**      | mini.ai                               | Text Objects       |
| **MEDIA**      | nvim-treesitter-textobjects           | Text Objects       |
| **MEDIA**      | grug-far.nvim                         | Search & Replace   |
| **MEDIA**      | nvim-lint                             | Linting            |
| **MEDIA**      | nvim-treesitter-context               | UI/Contesto        |
| **MEDIA**      | render-markdown.nvim                  | UI/Markdown        |
| **MEDIA**      | Moduli snacks.nvim extra              | Utility            |
| **BASSA-MEDIA**| tiny-inline-diagnostic.nvim           | UI/Diagnostics     |
| **BASSA-MEDIA**| dropbar.nvim                          | UI/Breadcrumb      |
| **BASSA-MEDIA**| harpoon v2                            | Produttività       |
| **BASSA-MEDIA**| overseer.nvim                         | Task Runner        |
| **BASSA-MEDIA**| lazydev.nvim                          | DX Lua             |
| **BASSA**      | inc-rename.nvim                       | Refactoring        |
| **BASSA**      | edgy.nvim                             | Layout             |
