program CadastroRTTI;

uses
  Vcl.Forms,
  un_frmCadRTTI in 'un_frmCadRTTI.pas' {frm_principal_cadRTTI},
  un_cliente in 'un_cliente.pas',
  un_funcoes in 'un_funcoes.pas' {$R *.res},
  Un_CustomAttributes in 'Un_CustomAttributes.pas',
  Un_Helper.RTTI in 'Un_Helper.RTTI.pas',
  Un_Validador in 'Un_Validador.pas',
  un_persistenciaDados in 'un_persistenciaDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_principal_cadRTTI, frm_principal_cadRTTI);
  Application.Run;
end.
