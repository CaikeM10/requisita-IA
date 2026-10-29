# Specify - Relato, revisão estruturada e exportação

Projeto: RequisitaIA. Dupla: João Pedro Mota Saldanha de Freitas e Pedro Caike Marinho Feitosa.
Versão: proposta de 27/10/2026 para a implementação da semana 4.
Status: aguardando revisão e aprovação explícita dos dois integrantes. Nenhum aceite é presumido.
Governança: [Constitution](../CONSTITUTION.md).

## 1. Problema e objetivo
Pedidos informais dificultam organizar o escopo de pequenos sistemas. Esta iteração entrega a base de revisão e exportação: registrar o relato e transformar itens preenchidos pelo próprio usuário em um documento Markdown organizado. A geração automática por IA continua como objetivo futuro, não como recurso desta entrega.

## 2. Usuário e fluxo
Estudante ou desenvolvedor autenticado entra em /levantamento, informa título e relato, adiciona requisitos com critérios de aceite e perguntas de esclarecimento, revisa o resultado e baixa um arquivo .md. A autenticação Google existente será reutilizada, sem mudança do seu contrato.

## 3. Requisitos e critérios de aceite
| ID | Comportamento e critério verificável |
| --- | --- |
| RF01 | /levantamento exige sessão no servidor. Acesso sem sessão redireciona para / e não entrega o editor protegido. |
| RF02 | Título obrigatório de 3 a 100 caracteres e relato de 20 a 5.000 caracteres, após trim. Entradas inválidas exibem erro junto ao campo e impedem exportação; o texto digitado é preservado. |
| RF03 | Adicionar, editar e remover até 20 requisitos, cada um com descrição de 1 a 500 caracteres e de 1 a 5 critérios de aceite de 1 a 300 caracteres. Deve existir ao menos um requisito válido para exportar. Identificadores RF-001, RF-002 etc. seguem a ordem visível na exportação. |
| RF04 | Adicionar, editar e remover até 10 perguntas de esclarecimento de 1 a 300 caracteres. A lista pode ficar vazia; nesse caso o documento informa que nenhuma pergunta foi registrada. A interface identifica que os itens são preenchidos pelo usuário, sem alegar geração por IA. |
| RF05 | Exibir prévia em texto do Markdown e exigir confirmação explícita de revisão antes de habilitar o download. Qualquer edição do título, relato, requisito, critério ou pergunta invalida a confirmação anterior. |
| RF06 | Ao exportar conteúdo válido e revisado, baixar requisitaia-requisitos.md em UTF-8, com título, relato original, requisitos e seus critérios, e perguntas. Acentos e alterações finais devem estar presentes. Nenhum item digitado pode ser executado como HTML ou código. |
| RF07 | Informar que os dados ficam apenas na memória da página e serão perdidos ao recarregar ou sair. Não usar banco, localStorage, cookies ou logs para guardar o conteúdo e não fazer chamadas a modelos externos nesta iteração. |

## 4. Restrições
Usar Next.js com Pages Router, React, TypeScript e CSS da base existente. Não migrar o roteador nem atualizar dependências sem aprovação. Renderizar a prévia como texto, sem dangerouslySetInnerHTML. Limites numéricos são os desta spec. Não registrar relatos no console ou em telemetria. Testar com dados fictícios. Rótulos, mensagens, navegação por teclado e foco visível devem permitir operar o formulário. Campos inválidos devem ter associação acessível à mensagem de erro.

## 5. Fora do escopo
Geração automática por IA; seleção ou contratação de provedor; persistência e histórico; integração com a tabela do laboratório; edição colaborativa; anexos; importação; PDF/Word; recuperação após recarga; implantação em produção; alteração do login existente. Não haverá simulação apresentada como IA real.

## 6. Definição de pronto
RF01 a RF07 atendidos; testes automatizados de validação e serialização aprovados; cenários manuais de acesso protegido, revisão, download e teclado registrados; npm run check aprovado; diff sem segredos; documentação de execução e limitações atualizada; revisão humana e merge conforme a Constitution. Antes do merge, registrar o estado real como proposta, implementado ou aguardando revisão. Os testes e a implementação ainda não foram executados nesta semana de planejamento.

## 7. Rastreabilidade
O [Plan](plan.md) descreve a solução de RF01-RF07 e as [Tasks](tasks.md) dividem sua implementação. Toda mudança de recorte ou critério exige aprovação conjunta antes do desenvolvimento afetado.
