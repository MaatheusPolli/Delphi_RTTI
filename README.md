# Delphi_RTTI — Persistência com RTTI e Custom Attributes

Estudo em Delphi (VCL), de 2021, sobre como usar **RTTI** e **Custom Attributes** para eliminar o SQL repetido das telas de cadastro. A classe de domínio é anotada, e o código monta INSERT, UPDATE, DELETE e SELECT e valida os campos automaticamente.

> Projeto de estudo.

## Exemplo

```pascal
[ATabela('CLIENTE')]
TCliente = class
public
  [ACampo('CODIGO'), APK]
  property Codigo: Integer read FCodigo write FCodigo;

  [ACampo('NOME'), ANotNull]
  property Nome: String read FNome write FNome;

  [ACampo('IDADE'), ANotNull]
  property Idade: Double read FIdade write FIdade;
end;
```

A tela de cadastro não escreve SQL. Ela entrega o objeto para `un_persistenciaDados`, que lê os atributos por RTTI.

## Projetos

| Pasta | Conteúdo |
|-------|----------|
| `RTTI/` | Estudo básico (`ProjetoEstudoRTTI.dpr`): atributos customizados, validação (`Un_validaCustom.pas`) e factory de cliente |
| `Cadastro Com RTTI/` | Cadastro de clientes completo (`CadastroRTTI.dpr`) com MySQL via dbExpress |

### Units principais (`Cadastro Com RTTI/`)

| Unit | Responsabilidade |
|------|------------------|
| `Un_CustomAttributes.pas` | Atributos `ATabela`, `ACampo`, `APK`, `ANotNull` |
| `Un_Helper.RTTI.pas` | Helpers para ler propriedades e atributos |
| `un_persistenciaDados.pas` | Geração de INSERT, UPDATE, DELETE e SELECT |
| `Un_Validador.pas` | Validação de campos por atributo |
| `un_cliente.pas` | Entidade `TCliente` anotada |
| `un_frmCadRTTI.pas/.dfm` | Tela de cadastro |
| `Banco de Dados/banco_rtti - Criar.sql` | Script de criação do banco |

## Como rodar

1. Crie o banco `banco_rtti` no MySQL usando o script em `Cadastro Com RTTI/Banco de Dados/`.
2. Ajuste a conexão (host, usuário e senha) no componente de conexão de `un_frmCadRTTI.dfm`.
3. Abra `CadastroRTTI.dproj` no Delphi (10.x ou mais novo) e execute. As DLLs `dbxmys.dll` e `libmysql.dll` precisam estar ao lado do executável.

## Pendências conhecidas

- O SQL é montado por concatenação de valores. Ele precisa ser trocado por parâmetros (risco de SQL injection).
- O repositório versiona arquivos compilados (`*.dcu`, `*.identcache`) e DLLs.

## Tecnologias

Delphi (VCL), RTTI (`System.Rtti`), dbExpress e MySQL.

## Licença

Este projeto usa **licença dupla**. O texto completo está em [LICENSE](LICENSE).

- **Uso pessoal, educacional e não comercial:** livre, nos termos da licença MIT (mantenha o aviso de copyright).
- **Uso comercial:** exige licença comercial. Isso inclui usar em produto ou serviço comercial, vender acesso ou derivados, usar em atividades com fins lucrativos e implantar em empresas.

Contato para licença comercial: ma.polli@hotmail.com
