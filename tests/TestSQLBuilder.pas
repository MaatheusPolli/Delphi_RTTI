unit TestSQLBuilder;

interface

uses
  System.SysUtils, System.Rtti, DUnitX.TestFramework,
  Un_CustomAttributes, un_cliente, un_sqlBuilder;

type
  // Classe com nome de tabela invalido: o builder deve recusar
  [ATabela('CLI; DROP TABLE x')]
  TClienteTabelaInvalida = class
  private
    FCodigo: Integer;
  public
    [ACampo('CODIGO'), APK]
    property Codigo: Integer read FCodigo write FCodigo;
  end;

  // Classe sem [APK]: o builder deve recusar update e delete
  [ATabela('SEM_PK')]
  TSemPK = class
  private
    FNome: String;
  public
    [ACampo('NOME')]
    property Nome: String read FNome write FNome;
  end;

  [TestFixture]
  TTestSQLBuilder = class
  private
    function ClienteExemplo: TCliente;
  public
    [Test] procedure Insert_GeraSQLComParametros;
    [Test] procedure Insert_ValorNaoEntraNoTexto;
    [Test] procedure Insert_TentativaDeInjecaoFicaNoParametro;
    [Test] procedure Update_UsaChavePrimariaNoWhere;
    [Test] procedure Delete_SoTemParametroDaChave;
    [Test] procedure Select_SemCondicao;
    [Test] procedure Select_ComCondicao;
    [Test] procedure NomeTabelaInvalida_LancaErro;
    [Test] procedure SemPK_LancaErroNoDelete;
    [Test] procedure PropriedadeSemACampo_NaoVaiParaOSQL;
  end;

implementation

function TTestSQLBuilder.ClienteExemplo: TCliente;
begin
  Result := TCliente.Create;
  Result.Codigo := 5;
  Result.Nome   := 'Ana';
  Result.Idade  := 30;
  Result.Peso   := 60.5;
end;

procedure TTestSQLBuilder.Insert_GeraSQLComParametros;
var
  C: TCliente;
  Params: TParametrosSQL;
  SQL: String;
begin
  C := ClienteExemplo;
  try
    SQL := TSQLBuilder.Insert(C, Params);

    Assert.IsTrue(SQL.StartsWith('INSERT INTO CLIENTE('));
    Assert.IsTrue(SQL.Contains('CODIGO'));
    Assert.IsTrue(SQL.Contains(':NOME'));
    Assert.AreEqual(4, Length(Params));
    Assert.AreEqual('Ana', Params[1].Valor.AsString);
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Insert_ValorNaoEntraNoTexto;
var
  C: TCliente;
  Params: TParametrosSQL;
  SQL: String;
begin
  C := ClienteExemplo;
  try
    SQL := TSQLBuilder.Insert(C, Params);
    Assert.IsFalse(SQL.Contains('Ana'), 'valor do cliente apareceu no SQL');
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Insert_TentativaDeInjecaoFicaNoParametro;
var
  C: TCliente;
  Params: TParametrosSQL;
  SQL: String;
begin
  C := ClienteExemplo;
  try
    C.Nome := 'x''); DROP TABLE CLIENTE;--';
    SQL := TSQLBuilder.Insert(C, Params);

    Assert.IsFalse(SQL.Contains('DROP'), 'injecao chegou ao texto do SQL');
    Assert.AreEqual('x''); DROP TABLE CLIENTE;--', Params[1].Valor.AsString);
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Update_UsaChavePrimariaNoWhere;
var
  C: TCliente;
  Params: TParametrosSQL;
  SQL: String;
begin
  C := ClienteExemplo;
  try
    SQL := TSQLBuilder.Update(C, Params);

    Assert.IsTrue(SQL.StartsWith('UPDATE CLIENTE SET '));
    Assert.IsTrue(SQL.Contains('NOME=:NOME'));
    Assert.IsTrue(SQL.Contains('WHERE CODIGO=:CODIGO;'));
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Delete_SoTemParametroDaChave;
var
  C: TCliente;
  Params: TParametrosSQL;
  SQL: String;
begin
  C := ClienteExemplo;
  try
    SQL := TSQLBuilder.Delete(C, Params);

    Assert.AreEqual('DELETE FROM CLIENTE WHERE CODIGO=:CODIGO;', SQL);
    Assert.AreEqual(1, Length(Params));
    Assert.AreEqual(5, Params[0].Valor.AsInteger);
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Select_SemCondicao;
var
  C: TCliente;
begin
  C := TCliente.Create;
  try
    Assert.AreEqual('SELECT * FROM CLIENTE', TSQLBuilder.Select(C));
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.Select_ComCondicao;
var
  C: TCliente;
begin
  C := TCliente.Create;
  try
    Assert.AreEqual('SELECT * FROM CLIENTE WHERE IDADE > 18',
      TSQLBuilder.Select(C, 'IDADE > 18'));
  finally
    C.Free;
  end;
end;

procedure TTestSQLBuilder.NomeTabelaInvalida_LancaErro;
var
  Obj: TClienteTabelaInvalida;
  Params: TParametrosSQL;
begin
  Obj := TClienteTabelaInvalida.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        TSQLBuilder.Insert(Obj, Params);
      end, EArgumentException);
  finally
    Obj.Free;
  end;
end;

procedure TTestSQLBuilder.SemPK_LancaErroNoDelete;
var
  Obj: TSemPK;
  Params: TParametrosSQL;
begin
  Obj := TSemPK.Create;
  try
    Assert.WillRaise(
      procedure
      begin
        TSQLBuilder.Delete(Obj, Params);
      end, EInvalidOperation);
  finally
    Obj.Free;
  end;
end;

procedure TTestSQLBuilder.PropriedadeSemACampo_NaoVaiParaOSQL;
var
  Obj: TSemPK;
  Params: TParametrosSQL;
  SQL: String;
begin
  // TSemPK tem [ACampo] mas sem [APK]; Insert nao exige PK
  Obj := TSemPK.Create;
  try
    Obj.Nome := 'Teste';
    SQL := TSQLBuilder.Insert(Obj, Params);
    Assert.AreEqual('INSERT INTO SEM_PK(NOME) VALUES (:NOME);', SQL);
  finally
    Obj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSQLBuilder);

end.
