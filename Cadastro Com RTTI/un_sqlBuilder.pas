unit un_sqlBuilder;

interface

uses
  System.Rtti, System.SysUtils, System.Generics.Collections,
  Un_CustomAttributes, Un_Helper.RTTI;

type
  // Um parametro do SQL: Nome (usado como :Nome no texto) e Valor
  TParametroSQL = record
    Nome: String;
    Valor: TValue;
  end;

  TParametrosSQL = TArray<TParametroSQL>;

  // Gera SQL parametrizado a partir dos atributos da classe.
  // Os valores nunca entram no texto do SQL: vao sempre como parametro.
  // So nomes de tabela e coluna entram no texto, e sao validados.
  TSQLBuilder = class
  private
    class function TipoDe(Classe: TObject): TRttiType; static;
    class function NomeTabela(Tipo: TRttiType): String; static;
    class function NomeColuna(Prop: TRttiProperty): String; static;
    class function PropriedadePK(Tipo: TRttiType): TRttiProperty; static;
    class function ParametrosDe(Classe: TObject): TParametrosSQL; static;
    class procedure ValidarIdentificador(const Nome: String); static;
    class function Juntar(Lista: TList<String>): String; static;
  public
    class function Insert(Classe: TObject; out Params: TParametrosSQL): String; static;
    class function Update(Classe: TObject; out Params: TParametrosSQL): String; static;
    class function Delete(Classe: TObject; out Params: TParametrosSQL): String; static;
    // Condicao e um trecho de WHERE escrito pelo desenvolvedor (nunca texto do usuario)
    class function Select(Classe: TObject; const Condicao: String = ''): String; static;
  end;

implementation

class function TSQLBuilder.TipoDe(Classe: TObject): TRttiType;
var
  Ctx: TRttiContext;
begin
  Ctx := TRttiContext.Create;
  Result := Ctx.GetType(Classe.ClassType);
end;

class procedure TSQLBuilder.ValidarIdentificador(const Nome: String);
var
  i: Integer;
  ok: Boolean;
begin
  ok := (Nome <> '') and (Nome[1] in ['A'..'Z', 'a'..'z', '_']);
  for i := 2 to Length(Nome) do
    if not (Nome[i] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
      ok := False;

  if not ok then
    raise EArgumentException.CreateFmt('Identificador invalido: "%s"', [Nome]);
end;

class function TSQLBuilder.NomeTabela(Tipo: TRttiType): String;
var
  Attr: TCustomAttribute;
begin
  Attr := Tipo.getAttribute(ATabela);
  if Attr = nil then
    raise EInvalidOperation.CreateFmt('Classe %s sem atributo [ATabela]', [Tipo.Name]);

  Result := ATabela(Attr).NomeTabela;
  ValidarIdentificador(Result);
end;

class function TSQLBuilder.NomeColuna(Prop: TRttiProperty): String;
begin
  Result := ACampo(Prop.getAttribute(ACampo)).NomeDB;
  ValidarIdentificador(Result);
end;

class function TSQLBuilder.PropriedadePK(Tipo: TRttiType): TRttiProperty;
var
  Prop: TRttiProperty;
begin
  for Prop in Tipo.GetProperties do
    if Prop.getAttribute(APK) <> nil then
      Exit(Prop);

  raise EInvalidOperation.CreateFmt('Classe %s sem propriedade [APK]', [Tipo.Name]);
end;

class function TSQLBuilder.ParametrosDe(Classe: TObject): TParametrosSQL;
var
  Tipo: TRttiType;
  Prop: TRttiProperty;
  Lista: TList<TParametroSQL>;
  Parametro: TParametroSQL;
begin
  Tipo := TipoDe(Classe);
  Lista := TList<TParametroSQL>.Create;
  try
    // So entra no SQL propriedade mapeada com [ACampo]
    for Prop in Tipo.GetProperties do
    begin
      if Prop.getAttribute(ACampo) = nil then
        Continue;

      Parametro.Nome  := NomeColuna(Prop);
      Parametro.Valor := Prop.GetValue(Classe);
      Lista.Add(Parametro);
    end;
    Result := Lista.ToArray;
  finally
    Lista.Free;
  end;
end;

class function TSQLBuilder.Juntar(Lista: TList<String>): String;
begin
  Result := String.Join(',', Lista.ToArray);
end;

class function TSQLBuilder.Insert(Classe: TObject; out Params: TParametrosSQL): String;
var
  Tipo: TRttiType;
  Colunas, Marcadores: TList<String>;
  P: TParametroSQL;
begin
  Tipo := TipoDe(Classe);
  Params := ParametrosDe(Classe);

  Colunas := TList<String>.Create;
  Marcadores := TList<String>.Create;
  try
    for P in Params do
    begin
      Colunas.Add(P.Nome);
      Marcadores.Add(':' + P.Nome);
    end;

    Result := Format('INSERT INTO %s(%s) VALUES (%s);',
      [NomeTabela(Tipo), Juntar(Colunas), Juntar(Marcadores)]);
  finally
    Colunas.Free;
    Marcadores.Free;
  end;
end;

class function TSQLBuilder.Update(Classe: TObject; out Params: TParametrosSQL): String;
var
  Tipo: TRttiType;
  Pk: TRttiProperty;
  Sets: TList<String>;
  P: TParametroSQL;
  PkNome: String;
begin
  Tipo := TipoDe(Classe);
  Pk := PropriedadePK(Tipo);
  PkNome := NomeColuna(Pk);
  Params := ParametrosDe(Classe);

  Sets := TList<String>.Create;
  try
    for P in Params do
      Sets.Add(P.Nome + '=:' + P.Nome);

    Result := Format('UPDATE %s SET %s WHERE %s=:%s;',
      [NomeTabela(Tipo), Juntar(Sets), PkNome, PkNome]);
  finally
    Sets.Free;
  end;
end;

class function TSQLBuilder.Delete(Classe: TObject; out Params: TParametrosSQL): String;
var
  Tipo: TRttiType;
  Pk: TRttiProperty;
  PkNome: String;
begin
  Tipo := TipoDe(Classe);
  Pk := PropriedadePK(Tipo);
  PkNome := NomeColuna(Pk);

  // Para o DELETE so o valor da chave primaria e necessario
  SetLength(Params, 1);
  Params[0].Nome  := PkNome;
  Params[0].Valor := Pk.GetValue(Classe);

  Result := Format('DELETE FROM %s WHERE %s=:%s;', [NomeTabela(Tipo), PkNome, PkNome]);
end;

class function TSQLBuilder.Select(Classe: TObject; const Condicao: String): String;
begin
  Result := Format('SELECT * FROM %s', [NomeTabela(TipoDe(Classe))]);
  if Condicao <> '' then
    Result := Result + ' WHERE ' + Condicao;
end;

end.
