unit un_persistenciaDados;

interface

uses
  System.SysUtils, System.Rtti, System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client,
  Un_CustomAttributes,
  Un_Helper.RTTI,
  un_sqlBuilder;

type
  // Persistencia generica: T e qualquer classe anotada com [ATabela], [ACampo] e [APK]
  TPersistencia<T: class, constructor> = class
  private
    FConexao: TFDConnection;
    FQuery: TFDQuery;

    procedure Executa(const SQL: String; const Params: TParametrosSQL);
    procedure PreencheObjeto(Dataset: TDataSet; Obj: T);
  public
    constructor Create(Conexao: TFDConnection);
    destructor Destroy; override;

    procedure Insert(Obj: T);
    procedure Edit(Obj: T);
    procedure Delete(Obj: T);
    // Lista e criada se for nil, senao e limpa e preenchida.
    // Condicao e um trecho de WHERE escrito pelo desenvolvedor.
    procedure GetListDaBase(var Lista: TList<T>; const Condicao: String = '');
  end;

implementation

{ TPersistencia<T> }

constructor TPersistencia<T>.Create(Conexao: TFDConnection);
begin
  inherited Create;
  FConexao := Conexao;
  FQuery   := TFDQuery.Create(nil);
  FQuery.Connection := FConexao;
end;

destructor TPersistencia<T>.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TPersistencia<T>.Executa(const SQL: String; const Params: TParametrosSQL);
var
  P: TParametroSQL;
begin
  FQuery.Close;
  FQuery.SQL.Text := SQL;

  for P in Params do
    FQuery.ParamByName(P.Nome).Value := P.Valor.AsVariant;

  FQuery.ExecSQL;
end;

procedure TPersistencia<T>.Insert(Obj: T);
var
  Params: TParametrosSQL;
  SQL: String;
begin
  SQL := TSQLBuilder.Insert(Obj, Params);
  Executa(SQL, Params);
end;

procedure TPersistencia<T>.Edit(Obj: T);
var
  Params: TParametrosSQL;
  SQL: String;
begin
  SQL := TSQLBuilder.Update(Obj, Params);
  Executa(SQL, Params);
end;

procedure TPersistencia<T>.Delete(Obj: T);
var
  Params: TParametrosSQL;
  SQL: String;
begin
  SQL := TSQLBuilder.Delete(Obj, Params);
  Executa(SQL, Params);
end;

procedure TPersistencia<T>.PreencheObjeto(Dataset: TDataSet; Obj: T);
var
  Ctx: TRttiContext;
  Prop: TRttiProperty;
  Campo: TField;
begin
  Ctx := TRttiContext.Create;

  for Prop in Ctx.GetType(Obj.ClassType).GetProperties do
  begin
    if Prop.getAttribute(ACampo) = nil then
      Continue;

    Campo := Dataset.FindField(ACampo(Prop.getAttribute(ACampo)).NomeDB);
    if (Campo = nil) or Campo.IsNull then
      Continue;

    case Prop.PropertyType.TypeKind of
      tkUString, tkString, tkLString, tkWString:
        Prop.SetValue(Obj, Campo.AsString);
      tkInteger:
        Prop.SetValue(Obj, Campo.AsInteger);
      tkInt64:
        Prop.SetValue(Obj, Campo.AsLargeInt);
      tkFloat:
        Prop.SetValue(Obj, Campo.AsFloat);
    end;
  end;
end;

procedure TPersistencia<T>.GetListDaBase(var Lista: TList<T>; const Condicao: String);
var
  Modelo, Obj: T;
  SQL: String;
begin
  if Lista = nil then
    Lista := TList<T>.Create
  else
    Lista.Clear;

  // Instancia so para o SQL conhecer tabela e colunas pelos atributos
  Modelo := T.Create;
  try
    SQL := TSQLBuilder.Select(Modelo, Condicao);
  finally
    Modelo.Free;
  end;

  FQuery.Close;
  FQuery.SQL.Text := SQL;
  FQuery.Open;
  try
    while not FQuery.Eof do
    begin
      Obj := T.Create;
      PreencheObjeto(FQuery, Obj);
      Lista.Add(Obj);
      FQuery.Next;
    end;
  finally
    FQuery.Close;
  end;
end;

end.
