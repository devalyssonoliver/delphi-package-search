unit uSearchMoreReg;

interface

uses
  DesignIntf, DBReg;

procedure register;

implementation

uses
  uSearchMore, System.SysUtils, System.classes;

procedure Register;
begin
  RegisterComponents('ZPackage', [TMore]);
  RegisterPropertyEditor(TypeInfo(string), TMore, 'PesquisaIndexConsulta', TDataFieldProperty);
end;

end.

