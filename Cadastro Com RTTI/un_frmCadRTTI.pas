unit un_frmCadRTTI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Data.DB, Vcl.StdCtrls, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Comp.Client,
  FireDAC.Phys.MySQL, System.IniFiles,

  un_cliente,
  un_funcoes,
  un_persistenciaDados,
  Generics.Collections;

type
  Tfrm_principal_cadRTTI = class(TForm)
    Panel1: TPanel;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnEditar: TButton;
    btnCancelar: TButton;
    ListBox1: TListBox;
    Nome: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    SQLConn: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    Peso: TEdit;
    Idade: TEdit;
    StringGrid: TStringGrid;
    Codigo: TEdit;
    btnNovo: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnNovoClick(Sender: TObject);
  private
    FEditando : Boolean;
    //Lista declarada na Unit do Cliente
    FClientes : TClientes;

    TDados   : TPersistencia<TCliente>;
    procedure FormDestroy(Sender: TObject);
    procedure atualizaGrid(selRow: integer  = 1);
    function  getRegistroFromClienteList(LinhaGrid: Integer): TCliente;
    procedure LimparTela;
    procedure ControleDeBotoes(bNavegando: Boolean = false);
  public
    { Public declarations }
    property Clientes: TClientes read FClientes write FClientes;
  end;

var
  frm_principal_cadRTTI: Tfrm_principal_cadRTTI;

implementation

uses
  UN_Validador;

{$R *.dfm}

procedure Tfrm_principal_cadRTTI.btnSalvarClick(Sender: TObject);
var
  Cliente :  TCliente;
begin
  try
    //Obtenho Classe do Form passados
    Cliente := TCliente.Create;

    if Peso.Text = '' then
      Cliente.Peso  := 0;

    if Idade.Text = '' then
      Cliente.Idade := 0;
    TFuncoes.RetornarClasseDoForm(frm_principal_cadRTTI, Cliente);

    //Validar Preenchimento (Classe a ser validada, Listbox Capturar erros se tiver)
    TValidador.validarClasse(Cliente, ListBox1.Items);

    if ListBox1.Items.Count > 0 then
      raise Exception.Create('Erros na Validação foram encontrados');

    //Comando Insert
    if not FEditando then
      TDados.Insert(Cliente)
    else
      TDados.Edit(Cliente);

    TDados.GetListDaBase(FClientes);
    atualizaGrid;

    ShowMessage('Gravado com Sucesso!');
    LimparTela;
  except
    ShowMessage('Não foi possível Gravar...');
    Cliente.Free;
  end;
end;

procedure Tfrm_principal_cadRTTI.ControleDeBotoes(bNavegando: Boolean = false);
begin
  if bNavegando then
  begin
    btnSalvar.Enabled   := False;
    btnExcluir.Enabled  := True;
    btnEditar.Enabled   := True;
    btnCancelar.Enabled := False;
    btnNovo.Enabled     := True;
  end
  else
  begin
    btnSalvar.Enabled   := True;
    btnExcluir.Enabled  := True;
    btnEditar.Enabled   := True;
    btnCancelar.Enabled := True;
    btnNovo.Enabled     := True;
  end;
end;

procedure Tfrm_principal_cadRTTI.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  //Conexao configurada em config.ini (ao lado do executavel, nao versionado)
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    SQLConn.Params.Server   := Ini.ReadString('MySQL', 'Host', 'localhost');
    SQLConn.Params.Database := Ini.ReadString('MySQL', 'Database', 'banco_rtti');
    SQLConn.Params.UserName := Ini.ReadString('MySQL', 'Usuario', 'root');
    SQLConn.Params.Password := Ini.ReadString('MySQL', 'Senha', '');
  finally
    Ini.Free;
  end;

  //Crio Lista de Clientes
  FClientes := TClientes.Create;
  TDados    := TPersistencia<TCliente>.Create(SQLConn);
  FEditando := False;
end;

procedure Tfrm_principal_cadRTTI.FormDestroy(Sender: TObject);
var
  c: TCliente;
begin
  TDados.Free;
  //A lista e dona dos objetos clientes: libera cada um antes da lista
  for c in FClientes do
    c.Free;
  FClientes.Free;
end;

procedure Tfrm_principal_cadRTTI.FormShow(Sender: TObject);
begin
  TDados.GetListDaBase(FClientes);
  atualizaGrid;
  ControleDeBotoes;

  StringGrid.ColWidths[0] := 50;
  StringGrid.ColWidths[1] := 150;
  StringGrid.ColWidths[2] := 50;
  StringGrid.ColWidths[3] := 50;
end;

function Tfrm_principal_cadRTTI.getRegistroFromClienteList(
  LinhaGrid: Integer): TCliente;
begin
  Result := TCliente.Create;
  //Cast para obter o objeto da linha selecionda
  Result := TCliente(stringGrid.Objects[0, LinhaGrid]);
end;

procedure Tfrm_principal_cadRTTI.btnExcluirClick(Sender: TObject);
var
  c: TCliente;
  i: integer;
begin
  i := StringGrid.Row;
  c := GetRegistroFromClienteList(i);

  TDados.Delete(c);
  //Remove da lista de Objetos
  FClientes.Remove(c);
  c.Free;
  atualizaGrid(i);
end;

procedure Tfrm_principal_cadRTTI.btnNovoClick(Sender: TObject);
begin
  LimparTela;

  btnCancelar.Enabled := True;
  btnSalvar.Enabled   := True;
  btnExcluir.Enabled  := False;
  btnEditar.Enabled   := False;
  btnNovo.Enabled     := False;

  Codigo.Text := '0';
  Nome.SetFocus;
end;

procedure Tfrm_principal_cadRTTI.btnEditarClick(Sender: TObject);
begin
  FEditando := True;
  btnSalvarClick(Sender);

  Nome.SetFocus;
  Nome.SelectAll;
end;

procedure Tfrm_principal_cadRTTI.atualizaGrid(selRow: integer);
var
  c: TCliente;
begin
  StringGrid.RowCount := Clientes.Count+1;

  StringGrid.Cols[0].Clear;
  StringGrid.Cols[1].Clear;
  StringGrid.Cols[2].Clear;
  StringGrid.Cols[3].Clear;

  //Titulos Colunas
  StringGrid.Rows[0].Add('Código');
  StringGrid.Rows[0].Add('Nome');
  StringGrid.Rows[0].Add('Idade');
  StringGrid.Rows[0].Add('Peso');

  //Preencher Grid
  for c in FClientes do
  begin
    //Passa AddObject pra adicionar valor e linha, asism cada linha vai ter um objeto
    StringGrid.Cols[0].AddObject(c.Codigo.ToString, c);
    StringGrid.Cols[1].Add(c.Nome);
    StringGrid.Cols[2].Add(FloatToStr(c.Idade));
    StringGrid.Cols[3].Add(FloatToStr(c.Peso));
  end;

  if selRow >= StringGrid.RowCount then
    selrow := StringGrid.RowCount-1;

  StringGrid.Row := selRow;

  //Obter Objetos em tela, p alimentar os edits e usar no EDITAR
  if FClientes.Count > 0 then         //GET PARA RETORNAR O OBJETO DA LINHA SELECIONADA
    TFuncoes.setFormFromClasse(Self, getRegistroFromClienteList(selRow));
end;

procedure Tfrm_principal_cadRTTI.btnCancelarClick(Sender: TObject);
begin
  LimparTela;

  btnCancelar.Enabled := True;
  btnSalvar.Enabled   := True;
  btnExcluir.Enabled  := True;
  btnEditar.Enabled   := True;
  btnNovo.Enabled     := True;
end;

procedure Tfrm_principal_cadRTTI.LimparTela;
begin
  Nome.Text   := '';
  Peso.Text   := '';
  Idade.Text  := '';
  ListBox1.Clear;
end;

procedure Tfrm_principal_cadRTTI.StringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  //Obter Objetos em tela, p alimentar os edits e usar no EDITAR
  if ARow > 0 then         //GET PARA RETORNAR O OBJETO DA LINHA SELECIONADA
    TFuncoes.setFormFromClasse(Self, getRegistroFromClienteList(ARow));

   ControleDeBotoes(True);
end;

end.
