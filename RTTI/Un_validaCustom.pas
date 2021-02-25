unit Un_validaCustom;

interface

uses
  RTTI, System.Classes;

type
  TValidadorCustom = class
    class procedure ValidarClasse(Classe : TObject; e : TStringList);
  end;

implementation

uses
  un_CustomAttributes;
{ TValidadorCustom }

class procedure TValidadorCustom.ValidarClasse(Classe: TObject; e: TStringList);
var
  Contexto: TRTTIContext;
  Tipo    : TRTTIType;

  // pra usar for in
  Proper  : TRTTIproperty;
  Atributo : TObject;
begin
  Contexto := TRTTIContext.Create;
  //Descobre qual é a classe/tipo
  Tipo     := Contexto.GetType(Classe.ClassType);

  e.Add(tipo.Name);
  e.Add('-------------------------------------');

  //Tipo acessa a classe, e getProperties acessa todas propriedades da classe passada pra tipo
  for Proper in Tipo.GetProperties do
  begin
    //Nome da Propriedade = Seu valor
    e.Add('Propriedade: ' + Proper.Name +' = '+ Proper.GetValue(Classe).ToString);


    {Após pegar a propriedade posso acessar seus atributos, é onde será
    validado os CustomAtt;}
    for Atributo in Proper.GetAttributes do
    begin
      if Atributo.ClassType = CampoObrigatorio then
      begin
        if (Proper.GetValue(Classe).ToString = '') or
           (Proper.GetValue(Classe).ToString = '0') then
          e.Add('       *Campo Obrigatório* - Resultado: Não informado')
        else
          e.Add('       *Campo Obrigatório* - Resultado: Informado');
      end;

      if Atributo.ClassType = DefineIntervaloAceito then
      begin
        if (Proper.GetValue(Classe).ToString <> '') then
        begin
          if Proper.GetValue(Classe).AsExtended > DefineIntervaloAceito(Atributo).LimiteMaximo then
            e.Add('       *Campo DefineIntervaloAceito* - Resultado: Maior que o Limite');

          if Proper.GetValue(Classe).AsExtended < DefineIntervaloAceito(Atributo).LimiteMinimo then
            e.Add('       *Campo DefineIntervaloAceito* - Resultado: Menor que o Limite')
        end;
      end;
    end;
  end;
  e.Add('-------------------------------------');
  e.Add('');
  e.Add('');
end;

end.
