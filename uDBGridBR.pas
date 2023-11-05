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

unit uDBGridBR;

interface

uses
  SysUtils, Classes, Types,
  Controls, Grids, DBGrids, Graphics,
  Dialogs, Forms, Menus,
  Windows, DB,
  uConfigBR;

type

  TDBGridBR = class(TDBGrid)
  private
    FConfigBR: TConfigBR;
    LPesquisa: string;
    LPesquisaColuna: string;
    function GetConfigBR: TConfigBR;
    procedure SetConfigBR(Value: TConfigBR);
    procedure Filtrar;
    procedure Localizar;
    procedure CriarPopUp;
    procedure PopZebrarClick(Sender: TObject);
    procedure PopFiltrarClick(Sender: TObject);
    procedure PopLocalizarClick(Sender: TObject);
    procedure PopExportarCSVClick(Sender: TObject);
  protected
    procedure Loaded; override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    procedure ExportarCSV;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property ConfigBR: TConfigBR read GetConfigBR write SetConfigBR;
    { Published declarations }
  end;

procedure Register;

implementation

{ TDBGridBR }

constructor TDBGridBR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfigBR := TConfigBR.Create(Self);
end;

destructor TDBGridBR.Destroy;
var
  i: integer;
begin
  FConfigBR.Free;

  if Assigned(Self.PopupMenu) then
    Self.PopupMenu.Free;

  inherited;
end;

function TDBGridBR.GetConfigBR: TConfigBR;
begin
  Result := TConfigBR(FConfigBR);
end;

procedure TDBGridBR.SetConfigBR(Value: TConfigBR);
begin
  inherited;
  FConfigBR := Value;
end;

procedure TDBGridBR.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); //override;
var
  ARow: integer;
begin
  inherited;

  if Self.GetConfigBR.Zebrar then
  begin
    if Odd(Self.DataSource.DataSet.RecNo) then
      Self.Canvas.Brush.Color := Self.GetConfigBR.ZebrarCor1
    else
      Self.Canvas.Brush.Color := Self.GetConfigBR.ZebrarCor2;

    Self.Canvas.FillRect(Rect);
    Self.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;

  if Self.GetConfigBR.DestacarLinha then
  begin
    ARow := Self.DataSource.DataSet.RecNo;

    if ((Self.Row) = ARow) then
      Self.Canvas.Brush.Color := Self.GetConfigBR.DestacarLinhaCor;

    Self.Canvas.FillRect(Rect);
    Self.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;

  if Self.GetConfigBR.DestacarCelula then
  begin
    if (gdSelected in State) then
      Self.Canvas.Brush.Color := Self.GetConfigBR.DestacarCelulaCor;

    Self.Canvas.FillRect(Rect);
    Self.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

procedure TDBGridBR.KeyPress(var Key: Char); //override;
begin
  inherited;
end;

procedure TDBGridBR.KeyDown(var Key: Word; Shift: TShiftState); //override;
begin
  inherited;

  case Key of
    VK_F3: Filtrar();
    VK_F4: Localizar();
  end;
end;

procedure TDBGridBR.Filtrar;
var
  LCampo: string;
  LFiltro: string;
begin
  if (not Self.ConfigBR.Filtrar) then
    exit;

  if (Self.DataSource.DataSet.Filter.IsEmpty) then
  begin
    LPesquisa := '';
    LPesquisaColuna := '';
  end;

  LCampo := Self.Columns[Self.SelectedIndex].FieldName;

  if (not LPesquisaColuna.IsEmpty) and (LPesquisaColuna <> LCampo) then
  begin
    if (MessageDlg('Filtro atual:' + sLineBreak +
                   'Campo: ' + LPesquisaColuna + sLineBreak +
                   'Filtro: ' + LPesquisa + sLineBreak + sLineBreak +
                   'Deseja realizar um novo filtro ?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes) then
    begin
      exit;
    end;
  end;

  if InputQuery('Filtrar campo: ' + LCampo, 'Valor: ', LPesquisa) then
  begin
    if (LPesquisa.IsEmpty) then
      LFiltro := ''
    else
    begin
      if (LPesquisa.StartsWith('*') or LPesquisa.EndsWith('*')) then
        LFiltro := LCampo + ' LIKE ' + QuotedStr(LPesquisa.Replace('*', '%'))
      else if (LPesquisa.StartsWith('%') or LPesquisa.EndsWith('%')) then
        LFiltro := LCampo + ' LIKE ' + QuotedStr(LPesquisa)
      else
        LFiltro := LCampo + ' = ' + QuotedStr(LPesquisa);
    end;

    //Self.DataSource.DataSet.Filtered := False;
    LPesquisaColuna := LCampo;
    Self.DataSource.DataSet.Filter := LFiltro;
    Self.ConfigBR.SetFiltrarFiltro(LFiltro);
    Self.DataSource.DataSet.Filtered := (not LFiltro.IsEmpty);
  end;
end;

procedure TDBGridBR.Localizar;
var
  LCampo: string;
  LLocalizar: string;
begin
  if (not Self.ConfigBR.Localizar) then
    exit;

  LCampo := Self.Columns[Self.SelectedIndex].FieldName;

  if InputQuery('Localizar no campo: ' + LCampo, 'Valor: ', LLocalizar) then
    Self.DataSource.DataSet.Locate(LCampo, LLocalizar, [loCaseInsensitive, loPartialKey]);
end;

procedure TDBGridBR.ExportarCSV;
var
  _csv: TStringList;
  _reg: integer;
  _linha: string;
  _coluna: integer;
  _saveDialog: TSaveDialog;
begin
  if (Self.DataSource.DataSet.IsEmpty) then
  begin
    MessageDlg('Não existem registros para gerar o arquivo CSV', mtWarning, [mbOK], 0);
    exit;
  end;

  _reg := Self.DataSource.DataSet.RecNo;
  _csv := TStringList.Create();
  try
    try
      Self.DataSource.DataSet.DisableControls;

      {$REGION'CABECALHO'}

      _linha := '';
      for _coluna := 0 to Self.Columns.Count -1 do
      begin
        if _linha <> '' then
          _linha := _linha + ';';

        _linha := _linha + Self.Columns[_coluna].Title.Caption;
      end;
      _csv.Add(_linha);

      {$endregion}

      {$REGION'REGISTROS'}

      Self.DataSource.DataSet.First;
      while not Self.DataSource.DataSet.Eof do
      begin
        _linha := '';
        for _coluna := 0 to Self.Columns.Count -1 do
        begin
          if _linha <> '' then
            _linha := _linha + ';';

          try
            _linha := _linha + Self.DataSource.DataSet.FieldByName(Self.Columns[_coluna].FieldName).AsString;
          except
            _linha := _linha + ';';
          end;
        end;

        _csv.Add(_linha);

        Self.DataSource.DataSet.Next;
      end;

      {$ENDREGION}

    finally
      Self.DataSource.DataSet.EnableControls;
    end;

    try
      Self.DataSource.DataSet.Recno := _reg;
    except
    end;

    if (_csv.Count > 0) then // Salva...
    begin
      try
        _saveDialog := TSaveDialog.Create(Self);
        _saveDialog.Title := 'Salvar CSV';
        _saveDialog.DefaultExt := 'csv';
        _saveDialog.Filter := '*.csv';
        _saveDialog.InitialDir := ExtractFilePath(Application.ExeName);

        if _saveDialog.Execute then
          _csv.SaveToFile(_saveDialog.FileName);
      except
        on e:exception do
        begin
          MessageDlg('Ocorreu um erro ao salvar o arquivo CSV' + sLineBreak + 'Erro: ' + e.Message, mtWarning, [mbOK], 0);
          exit;
        end;
      end;
    end;
  finally
    _csv.Free;
  end;
end;

procedure TDBGridBR.Loaded;
begin
  inherited;

  //se está em tempo de design não deve personalizar a UI
  if (csDesigning in ComponentState) then
    Exit;

  CriarPopUp;
end;

{$region 'PopUp'}

procedure TDBGridBR.CriarPopUp;
  procedure CriaItem(ACaption: string; AOnClick: TNotifyEvent; AChecked: Boolean);
  var
    AMenuItem: TMenuItem;
  begin
    AMenuItem         := TMenuItem.Create(Self.PopupMenu);
    AMenuItem.Caption := ACaption;
    AMenuItem.OnClick := AOnClick;
    AMenuItem.Name    := 'popGridMenuItem' + IntToStr(Self.PopupMenu.Items.Count);
    AMenuItem.Checked := AChecked;
    Self.PopupMenu.Items.Add(AMenuItem);
  end;
begin
  if (Self.PopupMenu <> nil) then
    CriaItem('-', nil, False)
  else
    Self.PopupMenu := TPopUpMenu.Create(Self);

  CriaItem('Zebrar', @PopZebrarClick, Self.ConfigBR.Zebrar);
  CriaItem('Filtrar', @PopFiltrarClick, False);
  CriaItem('Localizar', @PopLocalizarClick, False);
  CriaItem('Exportar para CSV', @PopExportarCSVClick, False);
end;

procedure TDBGridBR.PopZebrarClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := (not (Sender as TMenuItem).Checked);
  Self.ConfigBR.Zebrar := (Sender as TMenuItem).Checked;
  Self.Repaint;
end;

procedure TDBGridBR.PopFiltrarClick(Sender: TObject);
begin
  Filtrar();
end;

procedure TDBGridBR.PopLocalizarClick(Sender: TObject);
begin
  Localizar();
end;

procedure TDBGridBR.PopExportarCSVClick(Sender: TObject);
begin
  ExportarCSV;
end;

{$endregion}

procedure Register;
begin
  RegisterComponents('pkgBR', [TDBGridBR]);
end;


(*

-- checkbox - modo 1

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
const
  IS_CHECK : Array[Boolean] of Integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);
var
  Check : Integer;
  R     : TRect;
begin
  with DBGrid1 do
  begin
    if AnsiLowerCase(Column.FieldName) = 'selecionado' then
    begin
      Canvas.FillRect(Rect);
      Check := IS_CHECK[Column.Field.AsBoolean];
      R := Rect;
      InflateRect(R,-2,-2); //aqui manipula o tamanho do checkBox
      DrawFrameControl(Canvas.Handle,rect,DFC_BUTTON,Check)
    end;
  end;
end;

-- checkbox - modo 2

var
  nMarcar: word;
  oRetangulo: TRect;
begin
  if UpperCase(Column.FieldName) = 'ATIVO' then
  begin
    DBGrid.Canvas.FillRect(Rect);

    if Column.Field.AsString = 'S' then
      nMarcar := DFCS_CHECKED
    else
      nMarcar := DFCS_BUTTONCHECK;

    // ajusta o tamanho do CheckBox
    oRetangulo := Rect;
    InflateRect(oRetangulo, -2, -2);

    // desenha o CheckBox conforme a condição acima
    DrawFrameControl(DBGrid.Canvas.Handle, oRetangulo, DFC_BUTTON, nMarcar);
  end;
end;


-- combobox
with Dbgrid1.Columns[2].PickList do //coluna referente ao cargo
begin
  Clear;
  Add('GERENTE');
  Add('REPRESENTANTE');
  Add('ENCANADOR');
  Add('VENDEDOR');
end;

Legal, porém, há um problema: o ComboBox só é exibido quando clicamos duas vezes na coluna, prejudicando a usabilidade. Como alternativa, utilize o evento OnColEnter da DBGrid e habilite a propriedade EditorMode para essa coluna:

if UpperCase(DBGrid.SelectedField.FieldName) = 'CIDADE' then
  DBGrid.EditorMode := True;

Faça o mesmo para o evento OnCellClick para permitir a exibição do ComboBox ao alterar de linha:

if AnsiUpperCase(Column.FieldName) = 'CIDADE' then
    DBGrid.EditorMode := True;

--- imagem na celula

OnDrawColumnCell da DBGrid:

var
  nIndiceImagem: byte;
begin
  if UpperCase(Column.Field.FieldName) = 'ATIVO' then
  begin
    DBGrid.Canvas.FillRect(Rect);

    if Column.Field.AsString = 'N' then
      nIndiceImagem := 0 -> em uma imagelist
    else
      nIndiceImagem := 1;

    // desenha a imagem conforme a condição acima
    ImageList.Draw(DBGrid.Canvas, Rect.Left + 24, Rect.Top + 1, nIndiceImagem);
  end;
end;


-----------

- dbgrid com footer e source -> http://www.scalabium.com/smdbgrid.htm

ultra
- Ordenação ascendente/descendente
- Adicionar/remover coluna
- renomear coluna (title)
- editar formatação (displayformat)
- salvar personalização da grid
- checkbox (basta informar o fieldname e o valor marcado/desmarcado)
- restaurar grid ao original (descartar personalização) -

- imprimir
- gerar grafico
- procurar campos
- legenda (cor da linha ou celular) conforme condição
-



*)


end.
