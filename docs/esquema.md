# Desenvolvimento do AutoManager

Versão 2

## 1. Papel e objetivo

Atue como um engenheiro de software sênior, com experiência em Ruby on Rails, Flutter, PostgreSQL, arquitetura de APIs RESTful e desenvolvimento mobile multiplataforma.

O objetivo é projetar e desenvolver o **AutoManager**, um aplicativo de gestão de oficinas mecânicas.

O sistema deve permitir que uma oficina gerencie clientes, veículos, serviços e ordens de serviço, oferecendo diferentes níveis de acesso para clientes, funcionários e administradores.

O projeto possui finalidade acadêmica. Portanto, priorize:

- Código organizado e de fácil manutenção.
- Arquitetura simples, sem complexidade desnecessária.
- Boas práticas de desenvolvimento.
- Segurança básica adequada.
- Interface agradável e intuitiva.
- Funcionalidades efetivamente operacionais.

Não implemente funcionalidades complexas que não estejam previstas neste escopo.

---

# 2. Tecnologias obrigatórias

## Backend

- Linguagem: Ruby.
- Framework: Ruby on Rails.
- Arquitetura: Rails API.
- Banco de dados: PostgreSQL.
- Comunicação: API RESTful.
- Formato de comunicação: JSON.
- Autenticação: JWT.
- Autorização: Pundit.
- Testes: RSpec.
- Documentação: Swagger / OpenAPI.

## Frontend

- Framework: Flutter.
- Linguagem: Dart.
- Gerenciador de dependências: Pub.
- Comunicação com backend: HTTP/REST.
- Gerenciamento de estado: Provider.
- Navegação: GoRouter.
- Armazenamento seguro de credenciais: solução compatível com cada plataforma.

## Plataformas

O frontend deverá funcionar em:

1. Android.
2. iOS.
3. Web.

Utilize uma única base de código Flutter para as três plataformas.

A interface deverá se adaptar aos diferentes tamanhos de tela.

---

# 3. Arquitetura geral

Utilize uma arquitetura cliente-servidor.

O Flutter será responsável pela interface e experiência do usuário.

O Rails será responsável por:

- Autenticação.
- Autorização.
- Regras de negócio.
- Validações.
- Persistência dos dados.
- Exposição dos endpoints REST.
- Controle de acesso às informações.

O PostgreSQL será responsável pelo armazenamento persistente.

Fluxo de comunicação:

Flutter → HTTP/JSON → Rails API → ActiveRecord → PostgreSQL.

O backend não deverá depender de informações de autorização fornecidas pelo frontend. Todas as permissões precisam ser verificadas pelo Rails.

## 3.1 Backend

Organize o Rails de maneira convencional, utilizando:

- Models para representar as entidades.
- Controllers para receber e responder às requisições.
- Services para operações de negócio que justifiquem essa separação.
- Policies para autorização com Pundit.
- Serializers para padronizar as respostas JSON.
- Migrations para gerenciamento do banco de dados.

Utilize versionamento da API:

`/api/v1/`

Mantenha os controllers pequenos e evite concentrar regras de negócio neles.

Não crie camadas ou abstrações desnecessárias.

## 3.2 Banco de dados

Utilize PostgreSQL.

O PostgreSQL oferece suporte a schemas, mas não é necessário criar vários schemas para este projeto.

Utilize inicialmente o schema padrão `public`.

Organize o banco através de tabelas, relacionamentos, chaves estrangeiras, índices e restrições de integridade.

Utilize migrations do Rails.

---

# 4. Perfis de usuário e permissões

O sistema terá três perfis de acesso:

- customer
- employee
- admin

Todos deverão utilizar a mesma estrutura de autenticação.

A diferenciação será realizada pelo atributo `role` da entidade User.

## 4.1 Cliente (customer)

O cliente poderá acessar somente suas próprias informações.

Permissões:

- Realizar cadastro.
- Efetuar login.
- Consultar e editar seus dados pessoais.
- Cadastrar veículos próprios.
- Consultar seus veículos.
- Consultar ordens de serviço vinculadas aos seus veículos.
- Acompanhar o andamento dos serviços.
- Consultar o histórico de serviços.
- Consultar os detalhes de uma ordem de serviço.

O cliente não poderá:

- Consultar dados de outros clientes.
- Alterar ordens de serviço.
- Modificar o status de uma ordem.
- Gerenciar funcionários.
- Acessar funcionalidades administrativas.

Clientes não criam ordens de serviço; apenas consultam as ordens vinculadas aos
seus veículos. Uma ordem fica visível ao cliente imediatamente após seu cadastro.

## 4.2 Funcionário (employee)

O funcionário terá acesso operacional ao sistema.

Permissões:

- Efetuar login.
- Consultar clientes.
- Cadastrar clientes.
- Editar clientes.
- Consultar veículos.
- Cadastrar veículos para clientes.
- Editar veículos.
- Consultar catálogo de serviços.
- Cadastrar serviços.
- Editar serviços.
- Abrir ordens de serviço.
- Editar ordens de serviço.
- Atualizar o status das ordens.
- Consultar histórico dos veículos.
- Consultar ordens de serviço da oficina.

O funcionário não poderá:

- Cadastrar outros funcionários.
- Excluir ou desativar funcionários.
- Alterar seu próprio perfil de acesso.
- Promover outro usuário para administrador.
- Gerenciar permissões de usuários.

Funcionários e administradores poderão criar ordens de serviço. Administradores
também possuem registro em `employees` e herdam todas as permissões operacionais
dos funcionários.

## 4.3 Administrador (admin)

O administrador terá todas as permissões do funcionário, além das funções administrativas.

Permissões adicionais:

- Cadastrar funcionários.
- Consultar funcionários.
- Editar funcionários.
- Desativar funcionários.
- Reativar funcionários.
- Gerenciar credenciais de acesso.
- Consultar informações dos funcionários.

Somente administradores poderão gerenciar os acessos dos funcionários.

Não permita que um usuário comum consiga se tornar administrador por meio de cadastro, alteração de perfil ou manipulação de requisições.

O primeiro administrador deverá ser criado por um procedimento controlado de inicialização do sistema.

## 4.4 Autorização

Utilize Pundit para implementar as permissões no backend.

Crie policies específicas para os principais recursos.

Regras importantes:

- O cliente só acessa registros associados à sua própria conta.
- O funcionário acessa os dados operacionais da oficina.
- O administrador possui acesso operacional e administrativo.
- Todas as verificações devem ocorrer no backend.
- Não confie apenas na ocultação de botões ou telas no Flutter.

---

# 5. Página pública

O sistema deverá possuir uma página inicial pública, acessível sem autenticação.

Essa página funcionará como apresentação comercial da oficina.

No Flutter Web, deverá ser uma landing page responsiva.

Nas versões Android e iOS, deverá existir uma tela pública equivalente, permitindo acessar a apresentação da oficina e a autenticação.

## 5.1 Header

Elementos:

- Logotipo da oficina.
- Início.
- Serviços.
- Sobre nós.
- Contato.
- Botão Entrar.

## 5.2 Banner principal

Apresentar uma imagem de uma oficina mecânica moderna.

Texto sugerido:

"Seu veículo merece o melhor cuidado."

Subtítulo:

"Serviços automotivos com qualidade, transparência e confiança."

Botões:

- Conheça nossos serviços.
- Acessar minha conta.

## 5.3 Serviços oferecidos

Apresentar os principais serviços da oficina:

- Troca de óleo.
- Revisão preventiva.
- Manutenção de freios.
- Suspensão.
- Alinhamento.
- Balanceamento.
- Troca de bateria.
- Diagnóstico automotivo.

Os serviços deverão ser carregados da API sempre que apropriado.

## 5.4 Sobre a oficina

Apresentar informações institucionais, diferenciais e proposta de valor.

## 5.5 Contato

Apresentar:

- Telefone.
- E-mail.
- Endereço.
- Horário de funcionamento.

## 5.6 Rodapé

Apresentar informações institucionais e links de navegação.

Importante: não é necessário desenvolver um CMS. As informações institucionais podem inicialmente ser configuradas de forma simples.

---

# 6. Autenticação

Implemente uma tela de login compartilhada entre os três perfis.

Após a autenticação, o backend deverá informar o perfil do usuário.

O Flutter deverá direcionar o usuário para a área correspondente.

Fluxo:

1. Usuário acessa a tela de login.
2. Informa e-mail e senha.
3. Flutter envia as credenciais ao Rails.
4. Rails valida as credenciais.
5. Rails retorna os dados necessários e o token de autenticação.
6. Flutter identifica o perfil.
7. Usuário é direcionado à área correspondente.

Crie as seguintes funcionalidades:

- Login.
- Logout.
- Cadastro público de clientes.
- Consulta do usuário autenticado.
- Tratamento de sessão expirada.
- Recuperação de senha ficará fora do MVP.

Utilize uma biblioteca de autenticação consolidada e compatível com a versão do Rails escolhida.

Não implemente algoritmos próprios de criptografia ou armazenamento de senhas.

Use armazenamento adequado para cada plataforma:

- Android: armazenamento protegido pelo sistema.
- iOS: Keychain.
- Web: estratégia compatível com o navegador, evitando armazenar credenciais sensíveis em localStorage.

Utilize tokens JWT com expiração curta. No logout, o Flutter deverá descartar o
token localmente; não haverá refresh token nem lista persistente de revogação no MVP.

---

# 7. Módulos funcionais

## 7.1 Clientes

Permitir o gerenciamento dos clientes da oficina.

Campos:

- Nome completo.
- E-mail.
- Telefone.
- CPF (opcional).
- Endereço (obrigatório).
- Data de cadastro.

Funcionalidades:

- Listar clientes.
- Cadastrar cliente.
- Consultar detalhes.
- Editar cadastro.
- Consultar veículos associados.
- Consultar histórico de ordens de serviço.

O e-mail deverá possuir validação de formato.

Evite cadastros duplicados quando houver identificadores suficientes para identificar o mesmo cliente.

## 7.2 Veículos

Cada cliente poderá possuir vários veículos.

Campos:

- Cliente proprietário.
- Marca.
- Modelo.
- Ano.
- Placa.
- Cor.
- Observações (opcional).

Funcionalidades:

- Listar veículos.
- Cadastrar veículo.
- Consultar detalhes.
- Editar veículo.
- Consultar histórico de manutenção.
- Consultar ordens de serviço associadas.

A placa deverá possuir validação e índice de unicidade conforme a regra de negócio definida.

## 7.3 Serviços

Representa o catálogo de serviços oferecidos pela oficina.

Exemplos:

- Troca de óleo.
- Alinhamento.
- Balanceamento.
- Troca de pastilhas de freio.
- Revisão completa.
- Troca de bateria.
- Manutenção de suspensão.

Campos:

- Nome.
- Descrição.
- Preço padrão.
- Duração estimada (opcional).
- Ativo.

Funcionalidades:

- Listar serviços.
- Consultar detalhes.
- Cadastrar serviço.
- Editar serviço.
- Ativar ou desativar serviço.

Funcionários e administradores poderão gerenciar o catálogo.

Clientes poderão consultar os serviços ativos.

Serviços associados a ordens antigas não deverão perder suas informações caso sejam desativados.

## 7.4 Ordens de serviço (OS)

Este será o principal módulo operacional do sistema.

Uma ordem de serviço representa o atendimento de um veículo pela oficina.

Campos:

- Número da ordem de serviço.
- Veículo.
- Data de entrada.
- Descrição do problema relatado pelo cliente.
- Diagnóstico do mecânico.
- Observações.
- Previsão de conclusão.
- Data de conclusão.
- Funcionário responsável.
- Status.
- Valor total.

Funcionalidades:

- Abrir ordem de serviço.
- Consultar ordens.
- Editar ordem.
- Atualizar diagnóstico.
- Associar serviços.
- Atualizar status.
- Consultar detalhes.
- Consultar histórico das mudanças de status.

Somente funcionários e administradores poderão criar ou alterar ordens de serviço.
A ordem poderá ser cancelada somente nos estados `open`, `queued` ou `diagnosing`.
Os estados `completed`, `delivered` e `canceled` são finais e não podem ser reabertos.

## 7.5 Itens da ordem de serviço

Uma ordem poderá conter vários serviços.

Campos:

- Ordem de serviço.
- Serviço.
- Quantidade.
- Valor unitário.
- Observação.

O valor unitário deverá ser copiado do preço do catálogo no momento da inclusão do serviço.

Dessa maneira, alterações posteriores no preço do catálogo não modificarão ordens antigas.

O valor total da ordem deverá ser calculado com base nos itens associados, evitando divergências entre os valores.

Os itens poderão ser adicionados, editados ou removidos enquanto a ordem estiver
em `open`, `queued` ou `diagnosing`. A partir de `in_progress`, os itens ficam
bloqueados. Os valores serão expressos em reais brasileiros, com duas casas
decimais; preços não podem ser negativos e a quantidade deve ser um número inteiro
maior que zero. Não haverá descontos, impostos ou pagamentos no MVP.

## 7.6 Status da ordem de serviço

Implemente os seguintes status:

1. open — Aberta.
2. queued — Na fila, aguardando disponibilidade de mecânico.
3. diagnosing — Em diagnóstico.
4. in_progress — Em execução.
5. completed — Concluída.
6. delivered — Entregue.
7. canceled — Cancelada.

O Flutter deverá apresentar os status em português.

Implemente validações para impedir transições inválidas de estado.

Exemplo de fluxo:

A ordem deve seguir o fluxo `open → queued → diagnosing → in_progress → completed → delivered`.
Também são permitidas as transições `open → canceled`, `queued → canceled` e
`diagnosing → canceled`. Não haverá etapa de aprovação do cliente: o cadastro da
ordem pelo funcionário representa a aceitação do atendimento.

A ordem poderá ser cancelada quando permitido pelas regras de negócio.

Clientes poderão visualizar o status, mas somente funcionários e administradores poderão alterá-lo.

O histórico registrará somente mudanças de status, contendo status anterior, novo
status, usuário responsável e data/hora da alteração.

---

# 8. Dashboard e telas internas

## 8.1 Dashboard público

Apresentação da oficina, catálogo de serviços e informações de contato.

## 8.2 Dashboard do cliente

Apresentar:

- Nome do cliente.
- Quantidade de veículos cadastrados.
- Ordens de serviço em andamento.
- Últimas ordens de serviço.
- Atalhos para consultar veículos.
- Atalhos para consultar histórico.

## 8.3 Dashboard do funcionário

Apresentar:

- Quantidade de ordens abertas.
- Ordens em diagnóstico.
- Ordens em execução.
- Ordens concluídas recentemente.
- Últimas ordens cadastradas.
- Atalho para cadastrar cliente.
- Atalho para cadastrar veículo.
- Atalho para abrir ordem de serviço.

## 8.4 Dashboard do administrador

Apresentar as informações operacionais do funcionário e também:

- Quantidade de funcionários ativos.
- Atalho para gerenciar funcionários.
- Acesso administrativo.

Os números deverão ser obtidos da API, sem dados fictícios na versão funcional.

---

# 9. Estrutura de dados inicial

Crie as seguintes entidades:

## users

- id
- name
- email
- encrypted_password (ou estrutura equivalente da biblioteca de autenticação)
- role
- active
- created_at
- updated_at

Valores possíveis para role:

- customer
- employee
- admin

## customers

- id
- user_id
- phone
- cpf
- address
- created_at
- updated_at

`phone` e `address` são obrigatórios para clientes.

## employees

- id
- user_id
- phone
- address (obrigatório)
- admission_date
- created_at
- updated_at

`phone` e `address` são obrigatórios para funcionários.

## vehicles

- id
- customer_id
- brand
- model
- year
- plate
- color
- observations
- created_at
- updated_at

## services

- id
- name
- description
- price
- estimated_duration
- active
- created_at
- updated_at

## service_orders

- id
- vehicle_id
- employee_id
- order_number
- problem_description
- diagnosis
- observations
- status
- entry_date
- estimated_completion_date
- completion_date
- created_at
- updated_at

## service_order_items

- id
- service_order_id
- service_id
- quantity
- unit_price
- observations
- created_at
- updated_at

`unit_price` e `price` são valores em BRL, não negativos, com duas casas
decimais. `quantity` é inteiro maior que zero. O total da ordem é derivado da
soma dos itens, com duas casas decimais, e não é uma entrada independente.

Utilize relacionamentos ActiveRecord apropriados.

Defina chaves estrangeiras, índices, validações e restrições no banco.

Adapte a estrutura quando necessário para garantir integridade e consistência.

Não armazene informações redundantes sem justificativa.

---

# 10. API RESTful

Utilize versionamento `/api/v1`.

Organize os endpoints seguindo convenções REST.

Exemplos de endpoints:

## Autenticação

- POST /api/v1/auth/login
- DELETE /api/v1/auth/logout
- GET /api/v1/auth/me
- POST /api/v1/auth/register

## Clientes

- GET /api/v1/customers
- POST /api/v1/customers
- GET /api/v1/customers/:id
- PATCH /api/v1/customers/:id
- DELETE /api/v1/customers/:id

## Funcionários

- GET /api/v1/employees
- POST /api/v1/employees
- GET /api/v1/employees/:id
- PATCH /api/v1/employees/:id
- DELETE /api/v1/employees/:id

Apenas administradores poderão gerenciar funcionários.

Funcionários e usuários serão desativados logicamente, sem exclusão física.

## Veículos

- GET /api/v1/vehicles
- POST /api/v1/vehicles
- GET /api/v1/vehicles/:id
- PATCH /api/v1/vehicles/:id
- DELETE /api/v1/vehicles/:id

Clientes e veículos que possuam vínculos não poderão ser excluídos fisicamente.

## Serviços

- GET /api/v1/services
- POST /api/v1/services
- GET /api/v1/services/:id
- PATCH /api/v1/services/:id
- DELETE /api/v1/services/:id

A exclusão de serviços será tratada como desativação. Serviços já associados a
ordens de serviço continuarão preservados no histórico.

## Ordens de serviço

- GET /api/v1/service_orders
- POST /api/v1/service_orders
- GET /api/v1/service_orders/:id
- PATCH /api/v1/service_orders/:id
## Itens da ordem

- POST /api/v1/service_orders/:service_order_id/items
- PATCH /api/v1/service_orders/:service_order_id/items/:id
- DELETE /api/v1/service_orders/:service_order_id/items/:id

Ordens de serviço não poderão ser excluídas fisicamente. A remoção de itens será
permitida somente antes do estado `in_progress`.

O backend deverá retornar códigos HTTP adequados:

- 200: sucesso.
- 201: recurso criado.
- 204: sucesso sem conteúdo.
- 401: não autenticado.
- 403: sem autorização.
- 404: recurso não encontrado.
- 422: erro de validação.

Padronize as respostas JSON e as mensagens de erro.

Implemente paginação e filtros simples nas listagens quando necessário.

---

# 11. Interface e identidade visual

Crie uma identidade visual profissional, moderna e relacionada ao setor automotivo.

Direção visual sugerida:

- Azul-marinho como cor principal.
- Laranja como cor de destaque.
- Branco e cinza como cores de apoio.
- Ícones simples.
- Cards com informações bem organizadas.
- Tipografia legível.
- Navegação intuitiva.

Não utilize uma interface excessivamente carregada.

## Responsividade

No Flutter:

- Android e iOS: navegação inferior ou menus adaptados a dispositivos móveis.
- Web: navegação lateral ou superior quando houver espaço.
- Telas de cadastro: formulários responsivos.
- Listagens: cards no mobile e tabelas ou listas adaptativas no desktop.

Implemente:

- Indicadores de carregamento.
- Mensagens de sucesso.
- Mensagens de erro.
- Estados vazios.
- Confirmação antes de operações destrutivas.
- Validação dos formulários.

Todas as telas deverão consumir dados reais da API.

Não utilize dados estáticos como substituição das funcionalidades implementadas.

---

# 12. Segurança e integridade

Implemente os seguintes cuidados:

- Senhas armazenadas com hash seguro.
- Autenticação obrigatória em endpoints privados.
- Autorização centralizada com Pundit.
- Proteção contra acesso aos dados de outros clientes.
- Validação dos parâmetros recebidos.
- Proteção contra atribuição indevida de atributos sensíveis.
- Controle de acesso à gestão de funcionários.
- Restrições de integridade no PostgreSQL.
- Tokens JWT com expiração curta; no logout, o cliente descarta o token localmente.
- Segredos armazenados em variáveis de ambiente.
- CORS configurado para as origens autorizadas.

Nunca permita que o frontend determine o próprio nível de acesso.

Não permita exclusão ou desativação do último administrador ativo sem um procedimento seguro para manter a administração do sistema.

---

# 13. Testes

## Backend

Utilize RSpec.

Implemente testes para:

- Modelos e validações.
- Autenticação.
- Policies de autorização.
- Endpoints REST.
- Relacionamentos.
- Regras de negócio das ordens de serviço.
- Cálculo do valor total.
- Transições de status.
- Isolamento dos dados dos clientes.

Dê atenção especial aos testes de autorização.

Exemplo:

Um cliente não pode consultar uma ordem de serviço pertencente a outro cliente, mesmo que conheça o ID.

Um funcionário não pode cadastrar outro funcionário.

Um administrador pode executar as operações do funcionário e gerenciar funcionários.

## Frontend

Utilize o pacote `flutter_test`.

Implemente testes básicos para:

- Componentes principais.
- Formulários.
- Navegação.
- Login.
- Redirecionamento conforme perfil.
- Estados de carregamento e erro.

---

# 14. Funcionalidades fora do escopo

Não implemente nesta primeira versão:

- Integração com WhatsApp.
- Pagamentos online.
- Integração bancária.
- Emissão de notas fiscais.
- Integração com sistemas externos de consulta veicular.
- Rastreamento GPS.
- Aplicativo separado para funcionários.
- Controle avançado de estoque.
- Gestão de fornecedores.
- Sistema de múltiplas oficinas.
- Permissões dinâmicas e configuráveis.
- Inteligência artificial.

Essas funcionalidades poderão ser consideradas em versões futuras.

---

# 15. Organização e execução do desenvolvimento

O desenvolvimento deverá ocorrer de forma incremental.

Não tente implementar todo o sistema em uma única etapa.

Antes de começar:

1. Analise os arquivos e a estrutura existente do projeto.
2. Identifique se os repositórios já existem.
3. Verifique as versões instaladas das ferramentas.
4. Identifique possíveis incompatibilidades.
5. Apresente uma proposta de organização do projeto.
6. Apresente o modelo inicial de dados.
7. Apresente o planejamento das etapas.

Caso o projeto esteja vazio, crie a estrutura inicial.

## Fases sugeridas

### Fase 1 — Fundação

- Criar Rails API.
- Configurar PostgreSQL.
- Configurar Flutter.
- Preparar comunicação HTTP.
- Criar estrutura inicial.
- Configurar testes.

### Fase 2 — Backend e autenticação

- Implementar User.
- Implementar autenticação.
- Implementar JWT.
- Implementar Pundit.
- Implementar os três perfis.
- Criar testes de autorização.

### Fase 3 — Cadastros

- Clientes.
- Funcionários.
- Veículos.
- Serviços.

### Fase 4 — Ordens de serviço

- Abertura de OS.
- Associação de serviços.
- Cálculo dos valores.
- Atualização de status.
- Consulta do histórico.

### Fase 5 — Frontend público

- Identidade visual.
- Home page.
- Apresentação dos serviços.
- Contato.
- Login.

### Fase 6 — Frontend autenticado

- Dashboard do cliente.
- Dashboard do funcionário.
- Dashboard do administrador.
- Telas de cadastro.
- Listagens.
- Detalhes das ordens de serviço.

### Fase 7 — Integração e validação

- Integrar todas as telas com a API.
- Testar os três perfis.
- Verificar segurança.
- Corrigir problemas de responsividade.
- Executar testes automatizados.
- Documentar a execução do projeto.

---

# 16. Regras de desenvolvimento

Siga estas orientações durante todo o desenvolvimento:

1. Priorize simplicidade e legibilidade.
2. Não introduza dependências sem necessidade.
3. Não duplique regras de negócio entre frontend e backend.
4. O backend é a fonte de verdade dos dados e das permissões.
5. Não implemente funcionalidades fora do escopo sem justificativa.
6. Utilize convenções do Rails e do Flutter.
7. Escreva nomes de classes, métodos, variáveis e tabelas em inglês, seguindo as convenções dos frameworks.
8. Escreva comentários e documentação em português.
9. Não deixe funcionalidades simuladas ou botões sem ação.
10. Não utilize dados fictícios na versão funcional, exceto em seeds de desenvolvimento.
11. Mantenha testes automatizados para as principais regras de negócio.
12. Documente as configurações necessárias para executar o projeto.

Quando encontrar decisões arquiteturais ambíguas, escolha a alternativa mais simples que preserve integridade, segurança e facilidade de manutenção.

Não crie abstrações antecipadamente para possíveis funcionalidades futuras.

---

# 17. Resultado esperado

Ao final, o AutoManager deverá ser um aplicativo funcional, com:

- Página pública de apresentação da oficina.
- Cadastro e login de clientes.
- Login de funcionários.
- Login de administradores.
- Controle de acesso por perfil.
- Cadastro e gerenciamento de clientes.
- Cadastro e gerenciamento de veículos.
- Cadastro e gerenciamento de serviços.
- Abertura e gerenciamento de ordens de serviço.
- Acompanhamento do andamento dos reparos.
- Dashboard adequado a cada perfil.
- API RESTful documentada.
- Banco PostgreSQL estruturado.
- Testes automatizados básicos.
- Compatibilidade com Android, iOS e Web.

**Diretriz principal: desenvolver um sistema acadêmico funcional, organizado e tecnicamente consistente, evitando complexidade desnecessária.**
