unit un_CustomAttributes;

interface

type
  CampoObrigatorio = class(TCustomAttribute)
  end;

  DefineIntervaloAceito = class(TCustomAttribute)
    private
      FLimiteMax: Integer;
      FLImiteMin: Integer;
    public
      property LimiteMaximo: Integer read FLimiteMax write FLimiteMax;
      property LimiteMinimo: Integer read FLImiteMin write FLImiteMin;

      //Cria Construtor para hora que passar o Custom definir os valores
      constructor Create (ValorMinimo,ValorMaximo : Integer);
  end;

implementation

{ LimiteIdade }

constructor DefineIntervaloAceito.Create(ValorMinimo,ValorMaximo : Integer);
begin
  FLimiteMax:= ValorMaximo;
  FLImiteMin:= ValorMinimo;
end;

end.
