unit un_principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, un_TCliente,

  //Precisa Adicionar para usar RTTI \/
  RTTI, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  Tfrm_principal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    btnValidarCustom: TButton;
    memo: TMemo;
    btnDescricaoClasse: TButton;
    btnDescricaoBotao: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDescricaoClasseClick(Sender: TObject);
    procedure btnDescricaoBotaoClick(Sender: TObject);
    procedure btnValidarCustomClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
  private
    { Private declarations }
    ObjetoClasseCliente : TClasseCliente;
    Contexto : TRTTIContext;
    Tipo     : TRTTIType;
    Proper   : TRTTIproperty;
    Metod    : TRTTiMethod;
    procedure PreencherClienteDinamico;

  public
    { Public declarations }
  end;

var
  frm_principal: Tfrm_principal;

implementation

uses
  un_cliente.factory, Un_validaCustom;

{$R *.dfm}

procedure Tfrm_principal.btnDescricaoBotaoClick(Sender: TObject);
var
  Proper: TRTTIproperty;
begin
  memo.Lines.Clear;
  //Cria contexto (formCreate)
  //Tipo = qual contexto/valor temos em (Tipo de Classe)

  {Sender = Classe do Botão}
  Tipo := Contexto.GetType(Sender.ClassType);

  //Adicionamos o Nome da classe
  memo.Lines.Add('Classe :' + Tipo.Name);
  memo.Lines.Add('');
  memo.Lines.Add('');

  {Tipo.GetProperties = Retorna as propriedades(campos) dispostos na classe Tipo;
   TIPO = Recebeu Cliente.ClassType, sendo assim TIPo fica refletindo o objeto Cliente(ObjetoClasseCliente)}

  //For in para rodar tds propriedades da Classe Cliente adicionaodo seus valores no memeo
  for Proper in Tipo.GetProperties do
    memo.Lines.Add(' Propriedade(Nome): ' + Proper.Name +
                   ' -  Valor:'    + Proper.GetValue(Sender).ToString);
  {Proper.Name reflete a mesma coisa que = Classe.NomeDaPropriedade}

  Proper.Free;
end;

procedure Tfrm_principal.btnDescricaoClasseClick(Sender: TObject);
var
  Proper: TRTTIproperty;
begin
  memo.Lines.Clear;

  PreencherClienteDinamico; //prenche objeto cliente
  Proper              := TRTTIproperty.Create;

  //Cria contexto (formCreate)
  //Tipo = qual contexto/valor temos em (Tipo de Classe)
  Tipo := Contexto.GetType(ObjetoClasseCliente.ClassType);

  //Adicionamos o Nome da classe
  memo.Lines.Add('Classe :' + Tipo.Name);
  memo.Lines.Add('');
  memo.Lines.Add('');

  {Tipo.GetProperties = Retorna as propriedades(campos) dispostos na classe Tipo;
   TIPO = Recebeu Cliente.ClassType, sendo assim TIPo fica refletindo o objeto Cliente(ObjetoClasseCliente)}

  //For in para rodar tds propriedades da Classe Cliente adicionaodo seus valores no memeo
  for Proper in Tipo.GetProperties do
    memo.Lines.Add(' Propriedade(Nome): ' + Proper.Name +
                   ' -  Valor:'    + Proper.GetValue(ObjetoClasseCliente).ToString);
  {Proper.Name reflete a mesma coisa que = Classe.NomeDaPropriedade}
  {Proper.MethodName reflete todos nome de metodos contidos na classe}

  Proper.Free;
end;

procedure Tfrm_principal.btnValidarCustomClick(Sender: TObject);
var
  //Criado pra usar no ForIn
  Cliente : TClasseCliente;
  //lista pra ser preenchida com os clientes
  ListaClientes : TListaClientes;
  //StringList para armazenar erros
  sList  : TStringList;
begin
  sList := TStringList.Create;

  //Instanciar Lista de Clientes
  ListaClientes := TClienteFactory.PreencherListagemDeClientes;

  for Cliente in ListaClientes do
    TValidadorCustom.ValidarClasse(Cliente,sList);
    //Passo a Classe que será validad e uma list pra capturar os retornos(msg)

  {Listbox vai apresentar a listagem de erros/problemas do stringlist usado
  armazenar;}
  ListBox1.Items := sList;
end;

procedure Tfrm_principal.FormDestroy(Sender: TObject);
begin
   ObjetoClasseCliente.Free;
   Contexto.Free;
   Tipo.Free;
   Metod.Free;
end;

procedure Tfrm_principal.FormShow(Sender: TObject);
begin
   ObjetoClasseCliente := TClasseCliente.Create;

   //TRTTIContext > Busca Contexto para fazer a ponte entre classe e metodos disponiveis
   Contexto            := TRTTIContext.Create;

   //TRTTIType > Libera acessos a diversos métodos a classe reletida
   Tipo                := TRTTIType.Create;

   //Para ter acesso as Proporiedades do Objeto
//   Proper              := TRTTIproperty.Create;

   //Para ter acesso as Métodos do Objeto
   Metod               := TRTTiMethod.Create;
end;

procedure Tfrm_principal.PreencherClienteDinamico;
begin
   ObjetoClasseCliente.Nome  :=  'Matheus';
   ObjetoClasseCliente.Idade :=  26;
   ObjetoClasseCliente.Peso  :=  80.5;
end;

end.
