# M-Navier-Stokes

Arquivos de teste isolados do programa Navier–Stokes (passo A2, estimativa `weightedIBP_est` e fechamento de Campanato), em Lean 4 com Mathlib `v4.32.1`.

## Conteúdo

| Arquivo | O que é |
|---|---|
| `A2/TestA2-1.lean` | harness da issue #28 (A2.1): usa as camadas `G1.WeakDiffusionIBP` e `G1.XiEpsLocalizedRealization` e deixa explícitas as obrigações analíticas que faltam (`TestA2WeightedIBPObligations`) |
| `A2/TestA2-2.lean` | A2.2: estruturas de dados do fechamento de Campanato e a implicação algébrica `testA2_2_closure_implies_gamma_half` |
| `Material/Closure.lean` | interface `Closure` para as estimativas |
| `.github/workflows/check-a2-1.yml` | workflow que compila `A2/TestA2-1.lean` |

## Status

- O `lakefile.lean` declara a biblioteca `G1` em `srcDir := "Core"`, mas a pasta `Core/` não está neste repositório. Os arquivos importam `G1.*` e **não compilam sozinhos**; dependem do repositório onde a camada G1 vive.
- No Livro de Provas do MVEI (2026-11-11) o projeto aparece como "falhou" ("G1: some modules have bad imports"), com 0 teoremas lidos no kernel.
- Nenhum `sorry` nos três arquivos; as partes não provadas estão como hipóteses explícitas em estruturas (`...Obligations`, `...Inputs`).
- Nada aqui afirma regularidade global de Navier–Stokes; o problema continua aberto.
