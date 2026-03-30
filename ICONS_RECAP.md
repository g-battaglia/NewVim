# Recap Icone (e come sono state configurate)

Nel nostro setup abbiamo rimosso tutte le icone Nerd Font che potevano causare problemi (come i fastidiosi "quadratini" `□` al posto dell'icona mancante nel font del terminale) e le abbiamo sostituite con **caratteri ASCII** semplici e puliti.

Questa è la legenda di ciò che vedrai nel tuo editor:

## 1. Diagnostica (Errori e Warning)
Queste icone appaiono nella **colonna di sinistra** (sign column) e vicino ai testi quando ci sono problemi nel codice:
* **`E`** (Rosso) → **Errore** (Error)
* **`W`** (Giallo/Arancio) → **Avviso** (Warning)
* **`H`** (Blu chiaro/Azzurro) → **Suggerimento** (Hint)
* **`I`** (Azzurro/Bianco) → **Informazione** (Info)

*Per leggere il dettaglio di un Errore/Warning:* premi **`gl`** o **`<leader>cd`** quando il cursore è su quella riga!

## 2. Git (Modifiche ai file)
Queste icone appaiono nella **colonna di sinistra** per indicare lo stato delle modifiche rispetto al branch Git:
* **`+`** (Verde) → Riga o File aggiunto
* **`~`** (Giallo/Arancio) → Riga o File modificato
* **`-`** (Rosso) → Riga o File eliminato
* **`?`** (Grigio) → File non tracciato (Untracked)

*Per esplorare i commit e le differenze:* premi **`<leader>gH`** (History globale su Diffview) oppure **`<leader>gc`** (Lista dei commit con Fzf-Lua).

## 3. Todo Comments
Se scrivi dei commenti speciali nel codice, verranno evidenziati e mostreranno questi simboli nella colonna di sinistra:
* **`T`** (Azzurro) → `TODO:`
* **`F`** (Rosso) → `FIX:`, `FIXME:`, `BUG:`
* **`W`** (Arancione) → `WARN:`, `WARNING:`
* **`H`** (Giallo scuro) → `HACK:`
* **`P`** (Viola/Rosa) → `PERF:`, `OPTIM:`
* **`N`** (Verde/Azzurro) → `NOTE:`, `INFO:`
* **`t`** (Verde scuro) → `TEST:`

## 4. Debugger (DAP)
Quando metti dei Breakpoint per il debug, vedrai questi simboli a sinistra:
* **`B`** (Rosso) → Breakpoint normale
* **`C`** (Giallo) → Breakpoint condizionale
* **`>`** (Verde) → Riga in cui è attualmente fermo il debugger
* **`!`** (Rosso Scuro) → Breakpoint rifiutato/non valido

## 5. Snacks Dashboard e Menu
I vari picker del menu iniziale:
* **`F`** → Find File
* **`S`** → Search Text / Restore Session
* **`R`** → Recent Files
* **`N`** → New File
* **`C`** → Config
* **`L`** → Lazy (gestore plugin)
* **`Q`** → Quit

## 6. Autocompletamento (Tipi di completamento)
I menu a tendina dell'autocompletamento (Blink o Cmp) usano delle abbreviazioni invece delle icone:
* `C ` (Class)
* `f ` (Field)
* `fn` (Function)
* `m ` (Method)
* `kw` (Keyword)
* `sn` (Snippet)
* `x ` (Variable)
* `...` e molti altri codici corti, tutti usando 1-2 lettere invece di Nerd Fonts!
