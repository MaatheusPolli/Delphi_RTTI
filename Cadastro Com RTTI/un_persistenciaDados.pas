unit un_persistenciaDados;

interface

uses
  DB, System.Classes, System.Rtti, sysUtils,  Data.SqlExpr,
  System.Generics.Collections,
  Un_Helper.RTTI,
  Un_CustomAttributes,
  Generics.Collections;

Type
  TPersistencia = class
  private
    FConnection: TSQLConnection;
    FIndices: String;
    FSQL: string;
    FSqlQry: TSQLQuery;
    FTabela: String;
    RttiContexto : TRttiContext;

    function GetPKField(Classe: TObject): TRttiProperty;
    function GetNomeTabela(Classe: TObject): String;
    function GetIndice(Classe: TObject): String;
    function GetCampos(Classe: TObject): String;
    function GetValores(Classe: TObject): String;
    function GetCampoValor(Classe: TObject): String;
    function GetValueFromProp(value: TValue): String;


    //// --------- Teste para usar DATASET -------------------------------------//
    //Apenas montada p teste RTTI + DataSet
    procedure AcaoEdit(DataSet: TDataSet; classe: TObject);
    procedure SetFieldsDataSet(DataSet: TDataSet; classe: TObject);
    procedure GetValoresFromDataset(Dataset: TDataSet; classe: TObject);

    // usando, constructor para instanciar internamento o objeto
    procedure GetListDoDataSet<T: class, constructor>(Dataset: TDataSet; lista: TList<T>);
    ////------------------------------------------------------------------------//
  public
    constructor Create(Connection: TSQLConnection);
    procedure Insert(Classe: TObject);
    procedure Edit(Classe: TObject);
    procedure Delete(Classe: TObject);
    procedure GetListDaBase<T: class, constructor>(out lista: TList<T>; CondicaoSQL: String = '');
   end;

implementation

{ TPersistenciaClass }

var
  RttiTipo     : TRttiType;
  RttiProp     : TRttiProperty;
  Atributo     : TCustomAttribute;

procedure TPersistencia.AcaoEdit(DataSet: TDataSet; classe: TObject);
begin
  DataSet.First;
  //Fun��o pra procurar qual propriedade est� com Custom de PK(APK)
  RttiProp := GetPKField(Classe);

  {//Note que � getAttribute(eu quem criei) n�o � GetAttributes
  Locate normal (NomeCampo,Valor)
  ACampo() = Cast pra recuperar Nome do campo}

  if DataSet.Locate(ACampo(RttiProp.getAttribute(ACampo)).NomeDB,
                           RttiProp.GetValue(Classe).AsInteger,[]) then
  begin
    DataSet.Edit;
    //Preencho os campos  Field por Field usando a classe
    SetFieldsDataSet(DataSet, Classe);
    DataSet.Post;
  end;
end;

constructor TPersistencia.Create(Connection: TSQLConnection);
begin
  FConnection := Connection;
  FSqlQry     := TSQLQuery.Create(FConnection.Owner);

  FSqlQry.SQLConnection := FConnection;
  RttiContexto          := TRttiContext.Create;
end;

procedure TPersistencia.insert(Classe: TObject);
var
  Campos: string;
  Valores: string;
begin
  {Captura Tabela, Campo e os Valores que ser�o passados no parametro de Insert}
  FTabela := GetNomeTabela(Classe);
  Campos  := GetCampos(Classe);
  valores := GetValores(Classe);

  FSQL    := '';
  {Faz SQL pra adicionar no banco}
  FSQL    := Format('INSERT INTO %s(%s) VALUES (%s);',[FTabela,Campos,valores]);

  FConnection.ExecuteDirect(FSQL);
end;

procedure TPersistencia.edit(Classe: TObject);
var
  Campos: string;
  Valores: string;
begin
  FTabela  := GetNomeTabela(Classe);
  valores  := GetCampoValor(Classe);
  FIndices := GetIndice(Classe);

  FSQL     := '';

  FSQL:=Format('UPDATE %s SET %s WHERE %s;',[FTabela,Valores,FIndices]);
  FConnection.ExecuteDirect(FSQL);
end;

procedure TPersistencia.Delete(classe: TObject);
begin
  FTabela  := GetNomeTabela(classe);
  FIndices := GetIndice(classe);

  FSQL     := '';

  FSQL:=Format('DELETE FROM %s WHERE %s;',[FTabela,FIndices]);
  FConnection.ExecuteDirect(FSQL);
end;

procedure TPersistencia.getListDaBase<T>(out lista: TList<T>; CondicaoSQL: String = '');
var
  Objeto: T;
begin
  Lista.Clear;
  FSqlQry.Close;
  FSqlQry.SQL.Clear;

  Objeto:=T.Create;
  FTabela := GetNomeTabela(objeto);

  if not condicaoSQL.IsEmpty then
    CondicaoSQL := 'WHERE ' + CondicaoSQL;

  FSQL     := '';
  FSQL := Format('SELECT * FROM %s %S',[FTabela, CondicaoSQL]);
  FSqlQry.SQL.Add(FSQL);
  FSqlQry.Open;

  while not FSqlQry.Eof do
  begin
    Objeto := T.Create;
    GetValoresFromDataset(FSqlQry, objeto);
    Lista.Add(Objeto);
    FSqlQry.Next;
  end;
end;

procedure TPersistencia.GetListDoDataSet<T>(Dataset: TDataSet; lista: TList<T>);
var
  //Crio objeto generico
  Objeto : T;
begin
  Lista.Clear;
  DataSet.First;

  while not dataset.Eof do
  begin
    {Navego criando objeto do tipo passado e pegando retorno do
     dataset e adicionando na lista}
    Objeto := T.Create;
    GetValoresFromDataset(DataSet,Objeto);
    lista.Add(Objeto);
    DataSet.Next
  end;
end;

function TPersistencia.getPKField(classe: TObject): TRttiProperty;
begin
  RttiTipo  := RttiContexto.GetType(Classe.ClassType);
  Result    := nil;

  for RttiProp in RttiTipo.GetProperties do
  begin
    if RttiProp.getAttribute(APK)<>nil then
      exit(RttiProp)
  end;

end;

function TPersistencia.getValueFromProp(value: TValue): String;
var
  f: TFormatSettings;
begin
  case Value.Kind of
    tkUString: Result := Value.ToString.QuotedString;
    tkInteger: Result := Value.ToString;

    tkFloat  :
      begin
          f := TFormatSettings.Create();
          f.DecimalSeparator := '.';
          Result := Value.AsExtended.ToString(f);
      end;
  end;
end;

function TPersistencia.getValores(classe: TObject): String;
var
  s: TStringList;
  f: TFormatSettings;
begin
  s := TStringList.Create;
  RttiTipo := RttiContexto.GetType(Classe.ClassType);

  for RttiProp in RttiTipo.GetProperties do
    s.Add(getValueFromProp(rttiProp.GetValue(Classe)));

  s.StrictDelimiter := True;
  s.Delimiter       := ',';
  Result            := s.DelimitedText;
end;

procedure TPersistencia.SetFieldsDataSet(DataSet: TDataSet; classe: TObject);
var
  nomeField: string;
begin
  RttiContexto := TRttiContext.Create;
  RttiTipo     := RttiContexto.GetType(Classe.ClassType);

  //Roda todas propriedades
  for RttiProp in RttiTipo.GetProperties do
  begin
    Atributo  := RttiProp.getAttribute(ACampo);
    //Pega o noem dos atributos pelo cast NomeDB
    nomeField := ACampo(Atributo).NomeDB;

    //Valida o TIipo
    case RttiProp.GetValue(classe).Kind of
                 //Localiza o Campo Data set = Atribui Valor
      tkUString: DataSet.FieldByName(nomeField).AsString  := RttiProp.GetValue(classe).AsString;
      tkInteger: DataSet.FieldByName(nomeField).AsInteger := RttiProp.GetValue(classe).AsInteger;
      tkFloat:
      begin
        if RttiProp.GetValue(classe).TypeInfo=TypeInfo(real) then
          DataSet.FieldByName(nomeField).AsFloat := RttiProp.GetValue(classe).AsExtended;

        if RttiProp.GetValue(classe).TypeInfo=TypeInfo(TDate) then
          DataSet.FieldByName(nomeField).AsDateTime := RttiProp.GetValue(classe).AsExtended;
      end;
    end
  end;
end;

function TPersistencia.getCampos(classe: TObject): String;
var
  s: TStringList;
begin
  s := TStringList.Create;
  RttiTipo := RttiContexto.GetType(classe.ClassType);

  //Captura os campos(propertys) da Classe
  for RttiProp in RttiTipo.GetProperties do
    s.Add(ACampo(RttiProp.getAttribute(ACampo)).NomeDB);

  //Delimita eles pra usar no SQL  (por isso usar stringlist)
  s.StrictDelimiter := True;
  s.Delimiter       := ',';
  Result            := s.DelimitedText;
end;

function TPersistencia.getCampoValor(classe: TObject): String;
var
  s: TStringList;
  f: TFormatSettings;
  campo, valor: string;
begin
  s:=TStringList.Create;
  RttiTipo:=RttiContexto.GetType(classe.ClassType);

  for RttiProp in RttiTipo.GetProperties do
  begin
    Campo := ACampo(RttiProp.getAttribute(ACampo)).NomeDB;
    Valor := GetValueFromProp(RttiProp.GetValue(classe));
    //Cria chave CAMPO = SEU VALOR p/ depois delimitar
    s.Add(campo + '=' + valor);
  end;

  s.StrictDelimiter := True;
  s.Delimiter       := ',';
  Result            := s.DelimitedText;
end;

function TPersistencia.getIndice(classe: TObject): String;
var
  s: TStringList;
  nome, valor: String;
begin
  s        := TStringList.Create;
  //Procura qual chave � PK
  RttiProp := GetPKField(Classe);
  //Retorno o nome do Campo
  nome     := ACampo(RttiProp.getAttribute(ACampo)).NomeDB;
  //Retorno seu valor
  Valor    := RttiProp.GetValue(Classe).ToString;
  //Devolve chave
  Result   := nome + '=' + Valor;
end;

function TPersistencia.getNomeTabela(classe: TObject): String;
begin
  //Instanciar Tipo atrav�s da Classe que est� sendo usada
  RttiTipo := RTTIContexto.GetType(Classe.ClassType);
  //Acessar o CustomAtrib NomeTabela, informado na Un_cliente antes de instanciar o objeto cliente
  Result   := ATabela(RttiTipo.getAttribute(ATabela)).NomeTabela;
end;

procedure TPersistencia.GetValoresFromDataset(Dataset: TDataSet; classe: TObject);
var
  RttiContexto: TRttiContext;
  RttiTipo: TRttiType;
  RttiProp: TRttiProperty;
  Atributo: TCustomAttribute;
  Value   : TValue;
  nomeField: String;
begin
  RttiContexto:= TRttiContext.Create;
  RttiTipo    := RttiContexto.GetType(classe.classType);

  for RttiProp in RttiTipo.GetProperties do
  begin
    Atributo  := RttiProp.getAttribute(ACampo);
    nomeField := ACampo(Atributo).NomeDB;

    //Instancio o Record Value, pra poder usar cast e funcoes;
    Value := RttiProp.GetValue(classe);

    case Value.Kind of
      //Verifico qual o tipo e acesso o valor da propriedade do dataset
      tkUString: Value := DataSet.FieldByName(nomeField).AsString;
      tkInteger: Value := DataSet.FieldByName(nomeField).AsInteger;
      tkFloat:
      begin
        if Value.TypeInfo=TypeInfo(Real) then
          Value := DataSet.FieldByName(nomeField).AsExtended;

        if Value.TypeInfo=TypeInfo(Double) then
          Value := DataSet.FieldByName(nomeField).AsExtended;

        if Value.TypeInfo=TypeInfo(TDate) then
          Value := DataSet.FieldByName(nomeField).AsFloat;
      end;
    end;
    //Seto valor
    RttiProp.SetValue(Classe,Value);
  end;
end;

end.

