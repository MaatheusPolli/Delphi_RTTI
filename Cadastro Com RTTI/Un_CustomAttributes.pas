unit Un_CustomAttributes;

interface

uses
  RTTI, System.TypInfo;

type
  ATabela = class(TCustomAttribute)
  private
    FNomeTabela: String;
  public
    constructor Create(nomeTabela: String);
    property NomeTabela: String read FNomeTabela write FNomeTabela;
  end;

  ACampo = class(TCustomAttribute)
  private
    FNomeDB: String;
    FNomeDisplay: String;
  public
    constructor Create(nomeDB: String);
    property NomeDB: String read FNomeDB write FNomeDB;
  end;

  APK = class(TCustomAttribute)
  end;

  ANotNull = class(TCustomAttribute)
  end;

implementation

{ ACampo }

constructor ACampo.Create(nomeDB: String);
begin
  FNomeDB := nomeDB;
end;

{ ATabela }

constructor ATabela.Create(nomeTabela: String);
begin
  FNomeTabela := nomeTabela;
end;

end.
