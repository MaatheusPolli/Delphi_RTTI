program ProjetoEstudoRTTI;

uses
  Vcl.Forms,
  un_principal in 'un_principal.pas' {frm_principal},
  un_TCliente in 'un_TCliente.pas',
  un_CustomAttributes in 'un_CustomAttributes.pas',
  un_cliente.factory in 'un_cliente.factory.pas',
  Un_validaCustom in 'Un_validaCustom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_principal, frm_principal);
  Application.Run;
end.
