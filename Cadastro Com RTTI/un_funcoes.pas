unit un_funcoes;

interface

uses
   Vcl.Forms, DB, System.Classes, System.Rtti, sysUtils, Vcl.StdCtrls;

type
  TFuncoes = class
    private
      class function RetornarTextoDoComponente(Componente: TComponent): string;
    public
      class procedure RetornarClasseDoForm(Formulario: TForm; Classe: Tobject);
      class procedure setFormFromClasse(Form: TForm; classe: TObject);

  end;

var
  RttiContexto : TRttiContext;
  RttiTipo   : TRttiType;
  RttiProp   : TRttiProperty;
  Componente : TComponent;
  Value      : TValue;
  I          : Integer;

implementation

{ TFuncoes }

class procedure TFuncoes.RetornarClasseDoForm(Formulario: TForm;
  Classe: Tobject);
begin
  RttiContexto:=TRttiContext.Create;

  //Captura Classe do parametro
  RttiTipo    :=RttiContexto.GetType(Classe.ClassType);

  //Corre todas propriedades da classe capturada
  for RttiProp in RttiTipo.GetProperties do
  begin
    for I:=0 to formulario.ComponentCount-1 do
    begin
      //Captura formulario passado no parametro
      componente:=Formulario.Components[I];
      if String(componente.Name).Contains(RttiProp.Name) then
      begin
        //valida qual tipo � pra obter retorno
        case RttiProp.GetValue(classe).Kind of
          tkUString: Value:= RetornarTextoDoComponente(componente);
          tkInteger: Value:= StrToInt(RetornarTextoDoComponente(componente));
          tkFloat:   Value:= StrToFloat(RetornarTextoDoComponente(componente));
        end;
        //List1 t� com propriedade ReadOnly
        if RttiProp.IsWritable then
          RttiProp.SetValue(Classe, Value);
      end;
    end;
  end;
end;

class function TFuncoes.RetornarTextoDoComponente(
  Componente: TComponent): string;
begin
  if componente is TEdit then
  begin
    if (componente as TEdit).NumbersOnly and ((componente as TEdit).Text='') then
      Exit('0')
    else
      Exit((componente as TEdit).Text);
  end;

  if componente is TComboBox then
    Exit((componente as TComboBox).Text);
end;

class procedure TFuncoes.setFormFromClasse(Form: TForm; classe: TObject);
begin
  RttiContexto := TRttiContext.Create;
  RttiTipo     := RttiContexto.GetType(Classe.ClassType);

  for RttiProp in RttiTipo.GetProperties do
  begin
    for I:=0 to Form.ComponentCount-1 do
    begin
      Componente := Form.Components[I];

      if String(Componente.Name).Contains(RttiProp.Name) then
      begin
        if Componente is TEdit then
          (Componente as TEdit).Text := RttiProp.GetValue(Classe).ToString;
      end;
    end;
  end;
end;

end.
