{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pkgBR;

{$warn 5023 off : no warning about unused units}
interface

uses
  uConfigBR, uDBGridBR, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('uDBGridBR', @uDBGridBR.Register);
end;

initialization
  RegisterPackage('pkgBR', @Register);
end.
