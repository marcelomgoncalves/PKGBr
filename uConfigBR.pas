//---------------------------------------------------------------------------//
// Projeto: pkgBR
// Biblioteca de componentes para Delphi
//
// Direitos Autorais Reservados (c) 2018 Marcos R. Weimer
//
// Você pode obter a última versão desse arquivo no BitBucket
// URL: https://bitbucket.org/marcosweimer/pkgbr
//
// Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la
// sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela
// Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)
// qualquer versão posterior.
//
// Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM
// NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU
// ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral
// Menor do GNU para mais detalhes.
//
// Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto
// com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,
// no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.
// Você também pode obter uma copia da licença em:
// http://www.opensource.org/licenses/lgpl-license.php
//
// Marcos R. Weimer - marcosweimer@gmail.com
//---------------------------------------------------------------------------//

unit uConfigBR;

interface

uses
  SysUtils, Classes, Types,
  Controls, Grids, DBGrids, Graphics;


type
  TConfigBR = class(TPersistent)
  private
    FOwner: TPersistent;
    FZebrar: Boolean;
    FZebrarCor1: TColor;
    FZebrarCor2: TColor;
    FDestacarCelula: Boolean;
    FDestacarCelulaCor: TColor;
    FDestacarLinha: Boolean;
    FDestacarLinhaCor: TColor;
    FFiltrar: Boolean;
    FFiltrarFiltro: string;
    FLocalizar: Boolean;
    procedure SetZebrar(Value: Boolean);
    procedure SetZebrarCor1(Value: TColor);
    procedure SetZebrarCor2(Value: TColor);
    procedure SetDestacarCelula(Value: Boolean);
    procedure SetDestacarCelulaCor(Value: TColor);
    procedure SetDestacarLinha(Value: Boolean);
    procedure SetDestacarLinhaCor(Value: TColor);
    procedure SetFiltrar(Value: Boolean);
    procedure SetLocalizar(Value: Boolean);
  protected
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetOwner: TPersistent; override;
    function GetZebrar: Boolean;
    function GetZebrarCor1: TColor;
    function GetZebrarCor2: TColor;
    function GetDestacarCelula: Boolean;
    function GetDestacarCelulaCor: TColor;
    function GetDestacarLinha: Boolean;
    function GetDestacarLinhaCor: TColor;
    function GetFiltrar: Boolean;
    function GetFiltrarFiltro: string;
    procedure SetFiltrarFiltro(Value: string);
    function GetLocalizar: Boolean;
  published
    property Zebrar: Boolean read GetZebrar write SetZebrar;
    property ZebrarCor1: TColor read GetZebrarCor1 write SetZebrarCor1;
    property ZebrarCor2: TColor read GetZebrarCor2 write SetZebrarCor2;
    property DestacarCelula: Boolean read GetDestacarCelula write SetDestacarCelula;
    property DestacarCelulaCor: TColor read GetDestacarCelulaCor write SetDestacarCelulaCor;
    property DestacarLinha: Boolean read GetDestacarLinha write SetDestacarLinha;
    property DestacarLinhaCor: TColor read GetDestacarLinhaCor write SetDestacarLinhaCor;
    property Filtrar: Boolean read GetFiltrar write SetFiltrar;
    property Localizar: Boolean read GetLocalizar write SetLocalizar;
  end;


implementation

constructor TConfigBR.Create(AOwner: TPersistent);
 begin
   inherited Create;
   FOwner := AOwner;
   FZebrar := False;
   FZebrarCor1 := clSilver;
   FZebrarCor2 := clMoneyGreen;
   FDestacarCelulaCor := clRed;
   FDestacarLinhaCor := clYellow;
   FFiltrar := True;
   FFiltrarFiltro := '';
   FLocalizar := True;
 end;

destructor TConfigBR.Destroy;
begin
  inherited Destroy;
end;

procedure TConfigBR.Assign(Source: TPersistent);
begin
  if Source is TConfigBR then
    with TConfigBR(Source) do
    begin
      Self.Zebrar := Zebrar;
    end
    else
      inherited;
end;

function TConfigBR.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TConfigBR.GetZebrar: Boolean;
begin
  Result := FZebrar;
end;

procedure TConfigBR.SetZebrar(Value: Boolean);
begin
  FZebrar := Value;
end;

function TConfigBR.GetZebrarCor1: TColor;
begin
  Result := FZebrarCor1;
end;

procedure TConfigBR.SetZebrarCor1(Value: TColor);
begin
  FZebrarCor1 := Value;
end;

function TConfigBR.GetZebrarCor2: TColor;
begin
  Result := FZebrarCor2;
end;

procedure TConfigBR.SetZebrarCor2(Value: TColor);
begin
  FZebrarCor2 := Value;
end;

function TConfigBR.GetDestacarCelula: Boolean;
begin
  Result := FDestacarCelula;
end;

procedure TConfigBR.SetDestacarCelula(Value: Boolean);
begin
  FDestacarCelula := Value;
end;

function TConfigBR.GetDestacarCelulaCor: TColor;
begin
  Result := FDestacarCelulaCor;
end;

procedure TConfigBR.SetDestacarCelulaCor(Value: TColor);
begin
  FDestacarCelulaCor := Value;
end;

function TConfigBR.GetDestacarLinha: Boolean;
begin
  Result := FDestacarLinha;
end;

procedure TConfigBR.SetDestacarLinha(Value: Boolean);
begin
  FDestacarLinha := Value;
end;

function TConfigBR.GetDestacarLinhaCor: TColor;
begin
  Result := FDestacarLinhaCor;
end;

procedure TConfigBR.SetDestacarLinhaCor(Value: TColor);
begin
  FDestacarLinhaCor := Value;
end;

function TConfigBR.GetFiltrar: Boolean;
begin
  Result := FFiltrar;
end;

procedure TConfigBR.SetFiltrar(Value: Boolean);
begin
  FFiltrar := Value;
end;

function TConfigBR.GetFiltrarFiltro: string;
begin
  Result := FFiltrarFiltro;
end;

procedure TConfigBR.SetFiltrarFiltro(Value: string);
begin
  FFiltrarFiltro := Value;
end;

function TConfigBR.GetLocalizar: Boolean;
begin
  Result := FLocalizar;
end;

procedure TConfigBR.SetLocalizar(Value: Boolean);
begin
  FLocalizar := Value;
end;



end.
