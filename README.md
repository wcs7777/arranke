<h1 align="center" border-bottom="none">Arranke</h1>
<h2 align="center" border-bottom="none"><em>Sistema de anúncio de carros</em></h2>

## Tabela de conteúdos
1. [Sobre o projeto](#sobre-o-projeto)
2. [Tecnologias](#tecnologias)
3. [Funcionalidades](#funcionalidades)
4. [Demonstração](#demonstração)
5. [Como rodar](#como-rodar)
5. [Autor](#autor)

***

## Sobre o projeto
REST API para um sistema de anúncio de carros, tanto para vendedores individuais quanto para garagens.

***

## Propósito
O projeto foi feito em **2021** para a aula de **Laboratório de Engenharia de Software** do curso de **Análise e Desenvolvimento de Sistemas**.

***

## Funcionalidades
A documentação completa está em [rest-api-documentation.txt](rest-api-documentation.txt).
Resumo da REST API:
- `POST /login` login do usuário no sistema
- `POST /logout` logout do usuário no sistema
- `GET /authenticated` verificar se o usuário está autenticado no sistema
- `POST /password-recovery/code` redefinir senha - gerar código (cria o código para recuperação de senha e envia para o email do usuário)
- `PUT /password-recovery/code` redefinir senha - conferir código (verifica se o código enviado corresponde com o código gerado)
- `PUT /password-recovery/new-password` redefinir senha - redefinir senha (altera a senha do usuário)
- `POST /user` criar usuario (usado para criar ofertante)
- `GET /user` recuperar informações do usuário para atualizar (autenticado)
- `PUT /user` atualizar usuario (autenticado)
- `DELETE /user` remover usuario (autenticado)
- `PUT /user/new-password` atualizar a senha de todos os tipos de usuário (autenticado)
- `POST /individual` criar vendedor individual
- `GET /individual` recuperar informações do vendedor individual para atualizar (autenticado como vendedor individual)
- `PUT /individual` atualizar vendedor individual (autenticado como vendedor individual)
- `DELETE /individual` remover vendedor individual e seus carros (autenticado como vendedor individual)
- `POST /garage` criar garagem
- `GET /garage` recuperar informações da garagem para atualizar (autenticado como garagem)
- `PUT /garage` atualizar garagem (autenticado como garagem)
- `DELETE /garage` remover garagem e seus carros(autenticado como garagem)
- `GET /car-properties` recuperar características - usado para criar e atualizar anúncio e para na tela para visualizar os carros como opções de filtro (marcas, cores, combustíveis, direções, câmbios, freios, trações e acessórios)
- `GET /makes/:id/models` recuperar modelos - usado para criar e atualizar anúncio e para na tela para visualizar os carros como opções de filtro (marcas, cores, combustíveis, direções, câmbios, freios, trações e acessórios)
- `POST /advertisements` criar anúncio do carro (autenticado como vendedor)
- `GET /advertisements/:id` recuperar informações do anúncio do carro para o vendedor visualizar os detalhes ou atualizar (autenticado como vendedor)
- `PUT /advertisements/:id` atualizar anúncio do carro (autenticado como vendedor)
- `DELETE /advertisements/:id` remover anúncio (autenticado como vendedor)
- `GET /advertisements` recuperar anuncios (autenticado como vendedor)
- `GET /offers` ver todas as ofertas (autenticado - vendedor)
- `GET /offers/:id` ver oferta (autenticado - vendedor)
- `GET /advertisements/:id/offers` ver ofertas de um anúncio (autenticado - vendedor)
- `POST /cars/:id:/offers` criar oferta para um carro (autenticado)
- `GET /cars` ver carros
- `GET /cars/:id` ver carro
- `GET /garages` ver garagens
- `GET /garages/:id` ver garagem (carros)
- `PUT /unique` validar se um campo de um recurso é único
- `GET /cars?filters` filtrar carros
- `GET /garages?filters` filtrar garagens


***

## Tecnologias
- [Node.js][1]
- [Express][1]
- [MySQL][3]

***

## Como rodar
Para testar o projeto é necessário criar o banco de dados com o arquivo em [database/all-with-test-data-bundle.sql](database/all-with-test-data-bundle.sql), ou [database/all-bundle.sql](database/all-bundle.sql) caso não queira popular as tabelas com dados para teste.  
Também é necessário criar um .env na pasta backend seguindo o arquivo [backend/.env.example](backend/.env.example) e instalar os pacotes com `npm install` ou `yarn install`.  
O comando para iniciar o sistema é `npm run start` caso esteja utilizando um sistema operacional Linux, ou `npm run start:windows` caso esteja utilizando um sistema operacional Windows.

***

## Demonstração
[![Demonstração do sistema](https://img.youtube.com/vi/psHXbyForWo/hqdefault.jpg)](https://www.youtube.com/watch?v=psHXbyForWo)

***

## Autor
Willian Carlos
<wcs7777git@gmail.com>
<https://www.linkedin.com/in/williancarlosdasilva/>

[1]: https://nodejs.org/en/
[2]: https://expressjs.com/
[3]: https://www.mysql.com/
