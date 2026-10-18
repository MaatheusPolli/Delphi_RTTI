unit TestValidador;

interface

uses
  System.Classes, DUnitX.TestFramework,
  un_cliente, UN_Validador;

type
  [TestFixture]
  TTestValidador = class
  private
    function ClienteValido: TCliente;
  public
    [Test] procedure ClienteValido_NaoTemErros;
    [Test] procedure NomeVazio_GeraErro;
    [Test] procedure IdadeZero_GeraErro;
    [Test] procedure PesoZero_GeraErro;
    [Test] procedure ClienteVazio_GeraTresErros;
    [Test] procedure ListaDeErrosEhLimpaAntesDeValidar;
  end;

implementation

function TTestValidador.ClienteValido: TCliente;
begin
  Result := TCliente.Create;
  Result.Codigo := 1;
  Result.Nome   := 'Ana';
  Result.Idade  := 30;
  Result.Peso   := 60;
end;

procedure TTestValidador.ClienteValido_NaoTemErros;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := ClienteValido;
  Erros := TStringList.Create;
  try
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(0, Erros.Count);
  finally
    Erros.Free;
    C.Free;
  end;
end;

procedure TTestValidador.NomeVazio_GeraErro;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := ClienteValido;
  Erros := TStringList.Create;
  try
    C.Nome := '';
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(1, Erros.Count);
    Assert.IsTrue(Erros[0].Contains('NOME'));
  finally
    Erros.Free;
    C.Free;
  end;
end;

procedure TTestValidador.IdadeZero_GeraErro;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := ClienteValido;
  Erros := TStringList.Create;
  try
    C.Idade := 0;
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(1, Erros.Count);
    Assert.IsTrue(Erros[0].Contains('IDADE'));
  finally
    Erros.Free;
    C.Free;
  end;
end;

procedure TTestValidador.PesoZero_GeraErro;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := ClienteValido;
  Erros := TStringList.Create;
  try
    C.Peso := 0;
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(1, Erros.Count);
    Assert.IsTrue(Erros[0].Contains('PESO'));
  finally
    Erros.Free;
    C.Free;
  end;
end;

procedure TTestValidador.ClienteVazio_GeraTresErros;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := TCliente.Create;
  Erros := TStringList.Create;
  try
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(3, Erros.Count);
  finally
    Erros.Free;
    C.Free;
  end;
end;

procedure TTestValidador.ListaDeErrosEhLimpaAntesDeValidar;
var
  C: TCliente;
  Erros: TStringList;
begin
  C := ClienteValido;
  Erros := TStringList.Create;
  try
    Erros.Add('erro antigo');
    TValidador.validarClasse(C, Erros);
    Assert.AreEqual(0, Erros.Count);
  finally
    Erros.Free;
    C.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestValidador);

end.
