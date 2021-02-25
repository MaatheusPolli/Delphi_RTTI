unit UnitClass.Helper.RTTI;

interface

uses
  RTTI;

type
  TCustomAttributeClass = class of TCustomAttribute;

  TRttiPropertyMelhorado = class helper for TRttiProperty
  public
    function getAttribute(CustomAttribute: TCustomAttributeClass): TCustomAttribute;
  end;

  TRttiTypeMelhorado = class helper for TRttiType
  public
    function getAttribute(CustomAttribute: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

{ TRttiPropertyMelhorado }

function TRttiPropertyMelhorado.getAttribute( CustomAttribute: TCustomAttributeClass): TCustomAttribute;
var
  atributo: TCustomAttribute;
begin
  result:=nil;
  for atributo in GetAttributes do
  begin
    if atributo is CustomAttribute then
      exit(atributo)
  end;
end;

{ TRttiTypeMelhorado }

function TRttiTypeMelhorado.getAttribute(CustomAttribute: TCustomAttributeClass): TCustomAttribute;
var
  atributo: TCustomAttribute;
begin
  result:=nil;
  for atributo in GetAttributes do
  begin
    if atributo is CustomAttribute then
      exit(atributo)
  end;

end;

end.
