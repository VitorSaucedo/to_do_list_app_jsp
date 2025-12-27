# 📝 Todo List - Gerenciador de Tarefas

![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0.1-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

Sistema web de gerenciamento de tarefas desenvolvido com Spring Boot, permitindo que usuários criem, atualizem e organizem suas tarefas diárias de forma simples e eficiente.

## 🚀 Demo

**[🔗 Acesse a aplicação aqui](https://to-do-list-app-jsp-1.onrender.com)**

> ⚠️ **Nota**: A aplicação pode demorar ~30 segundos para carregar na primeira vez (plano gratuito do Render).

## ✨ Funcionalidades

- ✅ Autenticação de usuários (registro e login)
- ✅ Criar, editar e excluir tarefas
- ✅ Marcar tarefas como concluídas
- ✅ Filtrar tarefas por status (todas, pendentes, finalizadas)
- ✅ Visualização organizada por data de criação
- ✅ Interface responsiva e intuitiva
- ✅ Segurança com Spring Security
- ✅ Senhas criptografadas com BCrypt

## 🛠️ Tecnologias Utilizadas

### Backend
- **Java 21** - Linguagem de programação
- **Spring Boot 4.0.1** - Framework principal
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Hibernate** - ORM
- **Maven** - Gerenciamento de dependências
- **Lombok** - Redução de boilerplate

### Banco de Dados
- **Neon** - Hosting do PostgreSQL (serverless)

### Frontend
- **JSP (JavaServer Pages)** - Template engine
- **JSTL** - Tag library para JSP
- **HTML5/CSS3** - Estrutura e estilo
- **JavaScript** - Interatividade

### Deploy
- **Render** - Hosting da aplicação
- **Docker** - Containerização
- **GitHub** - Versionamento de código

## 📋 Pré-requisitos

Para rodar o projeto localmente, você precisa ter instalado:

- [Java JDK 21+](https://www.oracle.com/java/technologies/downloads/#java21)
- [Maven 3.8+](https://maven.apache.org/download.cgi)
- [Git](https://git-scm.com/)
- [PostgreSQL 17+](https://www.postgresql.org/download/)

## 🔧 Instalação e Execução Local

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/todolist.git
cd todolist
```

### 2. Configure o banco de dados

#### Usando PostgreSQL local

Crie um banco de dados:

```bash
psql -U postgres
CREATE DATABASE todolist_db;
\q
```

Crie um arquivo `.env` na raiz do projeto:

```env
DATABASE_URL=jdbc:postgresql://localhost:5432/todolist_db
DB_USERNAME=postgres
DB_PASSWORD=sua_senha
```

### 3. Execute o projeto

```bash
# Usando Maven Wrapper
./mvnw spring-boot:run

# Ou usando Maven instalado
mvn spring-boot:run
```

### 4. Acesse a aplicação

Abra o navegador em: **http://localhost:8080**

## 🐳 Executar com Docker

### Build da imagem

```bash
docker build -t todolist-app .
```

### Executar container

```bash
# Com PostgreSQL
docker run -p 8080:8080 \
  -e DATABASE_URL=jdbc:postgresql://host.docker.internal:5432/todolist_db \
  -e SPRING_PROFILES_ACTIVE=prod \
  todolist-app
```

## 📁 Estrutura do Projeto

```
todolist/
├── src/
│   ├── main/
│   │   ├── java/com/vitorsaucedo/todolist/
│   │   │   ├── config/           # Configurações (Security, etc)
│   │   │   ├── controllers/      # Controladores MVC
│   │   │   ├── dtos/              # Data Transfer Objects
│   │   │   ├── entities/          # Entidades JPA
│   │   │   ├── exceptions/        # Exceções customizadas
│   │   │   ├── repositories/      # Repositórios JPA
│   │   │   └── services/          # Lógica de negócio
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   │
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           ├── jsp/           # Páginas JSP
│   │           └── web.xml
│   └── test/                      # Testes unitários
├── Dockerfile
├── pom.xml
├── .gitignore
└── README.md
```

## 🔐 Segurança

- Senhas criptografadas com **BCrypt**
- Proteção CSRF configurável
- Sessões gerenciadas pelo Spring Security
- Headers de segurança configurados
- Validação de dados no backend
- Proteção contra SQL Injection (JPA)

## 📊 Banco de Dados

### Modelo de Dados

#### Tabela: `tb_users`
| Campo    | Tipo         | Descrição              |
|----------|--------------|------------------------|
| id       | BIGSERIAL    | Chave primária         |
| login    | VARCHAR(255) | Nome de usuário (único)|
| password | VARCHAR(255) | Senha criptografada    |

#### Tabela: `tb_tasks`
| Campo         | Tipo          | Descrição                    |
|---------------|---------------|------------------------------|
| id            | BIGSERIAL     | Chave primária               |
| name          | VARCHAR(255)  | Nome da tarefa               |
| description   | VARCHAR(1000) | Descrição detalhada          |
| is_finished   | BOOLEAN       | Status de conclusão          |
| creation_date | TIMESTAMP     | Data de criação              |
| user_id       | BIGINT        | FK para usuário (dono)       |

## 📝 Roadmap

- [ ] Adicionar categorias/tags para tarefas
- [ ] Implementar prioridades (alta, média, baixa)
- [ ] Sistema de notificações
- [ ] Dark mode
- [ ] Export de tarefas (PDF/CSV)
- [ ] Testes automatizados completos

## 🐛 Problemas Conhecidos

- Primeira requisição no Render pode demorar ~30s (plano gratuito)
- Banco Neon fica inativo após 7 dias sem uso (plano gratuito)

## ⚙️ Configurações Importantes

### JSP Configuration

Para garantir que as páginas JSP sejam servidas corretamente, verifique as seguintes configurações no `application.properties`:

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

### Dependências JSP no pom.xml

```xml
<!-- JSP Support -->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
    <scope>provided</scope>
</dependency>

<!-- JSTL -->
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
</dependency>
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👤 Autor

**Vitor Saucedo**

- GitHub: [@vitorsaucedo](https://github.com/vitorsaucedo)
- LinkedIn: [Vitor Saucedo](https://linkedin.com/in/vitorsaucedo)

## 🙏 Agradecimentos

- [Spring Framework](https://spring.io/)
- [Neon](https://neon.tech) - Hosting do PostgreSQL
- [Render](https://render.com) - Hosting da aplicação

---

⭐ Se este projeto te ajudou, considere dar uma estrela!

**Desenvolvido com ❤️ para fins educacionais**
