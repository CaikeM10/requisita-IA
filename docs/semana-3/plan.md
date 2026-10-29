# Plan - Relato, revisão estruturada e exportação

Projeto: RequisitaIA. Referência: [Specify](specify.md). Backlog: [Tasks](tasks.md).
Status: planejamento proposto; aprovação da dupla pendente. Nenhuma funcionalidade ou teste é declarado concluído.

## 1. Base verificada e arquitetura proposta
A main consultada em 27/10/2026 contém Next.js com Pages Router, TypeScript, React, NextAuth v4, páginas de login e acesso protegido, CSS e o comando npm run check. A implementação desta iteração preservará essa base.

Criar pages/levantamento.tsx com proteção por getServerSideProps e getServerSession, reutilizando lib/auth.ts. Inserir o acesso ao levantamento na página autenticada existente. O formulário usará estado React local e componentes em components/levantamento/. O fluxo não necessita de nova API nem de banco. O conteúdo será perdido ao sair ou recarregar, com aviso visível.

Definir tipos em lib/levantamento/types.ts: documento com título, relato, requisitos com critérios e perguntas. A validação pura em lib/levantamento/validation.ts retornará erros por campo, inclusive em listas. A serialização em lib/levantamento/markdown.ts produzirá texto determinístico em UTF-8, com identificadores calculados pela ordem atual. Usar IDs internos estáveis para edição das listas, separados da numeração exportada.

A prévia será renderizada em pre como texto. O download será criado no navegador por Blob e URL temporária, liberada após uso, sem transmitir o relato. Revisão começa desmarcada e volta a esse estado em toda mudança de conteúdo; o botão de exportação exige tanto validação quanto revisão atual.

## 2. Ordem de execução
1. João Pedro e Caike revisam e aprovam o recorte e os critérios. Conferir a versão instalada e os guias locais do Next.js indicados por AGENTS.md antes de escrever código.
2. Criar tipos, validadores e serializador com testes por node:test; usar um executor TypeScript compatível, preferencialmente o Node disponível, ou propor uma dependência de desenvolvimento se necessária. A escolha e eventual alteração de dependências exigem revisão; não presumir que a execução TypeScript já está configurada.
3. Criar a rota protegida e o link de acesso, sem alterar o fluxo de login.
4. Construir formulário e listas com limites, erros acessíveis e operações de adição, edição e remoção.
5. Integrar prévia, invalidação da revisão e download.
6. Executar testes e verificação de tipos/build, registrar cenários manuais, atualizar instruções e abrir PR para revisão humana. Não realizar merge pelo agente.

## 3. Matriz de validação
| Requisitos | Verificação planejada |
| --- | --- |
| RF01 | Acesso direto sem sessão redireciona; com sessão abre editor; logout impede novo acesso. |
| RF02-RF04 | Testes dos limites mínimo/máximo, espaços, listas vazias, remoção/reordenação resultante e mensagens por campo. |
| RF05 | Exportar desabilitado antes da revisão; editar qualquer campo remove a confirmação; prévia mostra o estado atual. |
| RF06 | Testes do Markdown com acentos e caracteres especiais, numeração, critérios associados e perguntas vazias; abrir download e comparar seu conteúdo. HTML/script aparece como texto e não executa. |
| RF07 | Inspeção do código e da rede confirma ausência de armazenamento e envio externo; recarga perde o rascunho e aviso permanece claro. |
| Qualidade | npm run check, testes automatizados e operação manual por teclado sem mensagens de erro inesperadas. |

## 4. Riscos e tratamento
- Perda de dados: aviso de memória temporária antes do preenchimento; persistência permanece fora do escopo.
- Confusão com IA: tela e documentação identificam preenchimento manual; não usar texto que prometa geração automática.
- Markdown ambíguo: tratar caracteres estruturais e quebras de linha no serializador e testar entradas contendo marcadores, HTML e acentos; não incorporar renderizador HTML.
- Regressão de login: reutilizar configuração e testar proteção/logout. Credenciais locais não entram nos testes versionados.
- Escopo crescente: pedidos de IA, banco ou novos formatos viram iterações futuras, não tarefas desta entrega.
- Governança: responsáveis propostos são João Pedro na interface e Caike na validação/serialização; divisão depende do aceite de ambos. Quem não conduziu a mudança revisa o PR.

## 5. Conclusão e limites
A funcionalidade só será considerada pronta pela definição da Specify e pela Constitution. Esta semana entrega documentos para a implementação da semana 4; os testes listados são planejados, não resultados observados. Nenhuma contratação, migration ou acesso a dados reais é necessário.
