unit uSearchMore;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Buttons, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  Vcl.StdCtrls, Vcl.DBCtrls, DesignIntf, dbreg;

type
  TMore = class(TBitBtn)
  private
    FTitulo: string;
    FLargura: Integer;
    FAltura: Integer;
    FDataLink: TFieldDataLink;
    FStyleForm: string;
    procedure ExibirPesquisa;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure OnDbClick(Sender: TObject);
    procedure OnChangeEdt(Sender: TObject);
    procedure SetPesquisaIndexConsulta(const Value: string);
    function GetPesquisaIndexConsulta: string;
  protected
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Titulo: string read FTitulo write FTitulo;
    property StyleForm: string read FStyleForm write FStyleForm;
    property Largura: Integer read FLargura write FLargura;
    property Altura: Integer read FAltura write FAltura;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property PesquisaIndexConsulta: string read GetPesquisaIndexConsulta write SetPesquisaIndexConsulta;

  end;

implementation


{ TMore }

constructor TMore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := '...';
  Width := 25;
  Height := 25;
  FLargura := 640;
  FAltura := 480;
  FDataLink := TFieldDataLink.Create;
end;

destructor TMore.Destroy;
begin
  if Assigned(FDataLink) then
    FDataLink.Free;
  inherited Destroy;
end;

procedure TMore.Click;
begin
  inherited Click;
  ExibirPesquisa;
end;

procedure TMore.ExibirPesquisa;
var
  FormPesquisa: TForm;
  Cabecalho, Rodape: TPanel;
  GridResultados: TDBGrid;
  CampoBusca: TMaskEdit;
  aLbl: TLabel;
  BotaoIncluir, BotaoOk, BotaoCancelar: TBitBtn;
  Margem, CentroVertical: Integer;
begin
  FormPesquisa := TForm.Create(nil);
  try
    Margem := 10;
    FormPesquisa.BorderStyle := bsDialog;
    FormPesquisa.Position := poScreenCenter;
    FormPesquisa.Font.Name := 'Tahoma';
    FormPesquisa.Font.Size := 8;
    FormPesquisa.Caption := FTitulo;
    FormPesquisa.Height := FAltura;
    FormPesquisa.Width := FLargura;
    FormPesquisa.StyleName := StyleForm;

    Cabecalho := TPanel.Create(FormPesquisa);
    Cabecalho.Parent := FormPesquisa;
    Cabecalho.Align := alTop;
    Cabecalho.Height := 50;

    aLbl := TLabel.Create(FormPesquisa);
    aLbl.Parent := Cabecalho;
    aLbl.Align := alTop;
    aLbl.AlignWithMargins := True;
    aLbl.Margins.Left := 5;

    aLbl.Caption := 'Pesquisar por...';

    CampoBusca := TMaskEdit.Create(FormPesquisa);
    CampoBusca.Parent := Cabecalho;
    CampoBusca.Top := (Margem + Cabecalho.Height - CampoBusca.Height) div 2;
    CampoBusca.Left := 5;
    CampoBusca.Width := FLargura - 25;
    CampoBusca.TextHint := 'Campo de Busca';
    CampoBusca.OnChange := OnChangeEdt;

    GridResultados := TDBGrid.Create(FormPesquisa);
    GridResultados.Parent := FormPesquisa;
    GridResultados.Align := alClient;
    GridResultados.Name := 'grdResultados';
    GridResultados.BorderStyle := bsNone;
    GridResultados.DataSource := GetDataSource;
    GridResultados.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack];
    GridResultados.OnDblClick := OnDbClick;

    Rodape := TPanel.Create(FormPesquisa);
    Rodape.Parent := FormPesquisa;
    Rodape.Align := alBottom;
    Rodape.Height := 40;
    Rodape.BevelOuter := bvNone;

    // Botão Incluir
    BotaoIncluir := TBitBtn.Create(FormPesquisa);
    BotaoIncluir.Parent := Rodape;
    BotaoIncluir.Caption := 'Incluir';
    BotaoIncluir.Left := Margem;
    BotaoIncluir.Top := (Rodape.Height - BotaoIncluir.Height) div 2;
    // Botão Confirmar
    BotaoOk := TBitBtn.Create(FormPesquisa);
    BotaoOk.Parent := Rodape;
    BotaoOk.Kind := bkOK;
    BotaoOk.Caption := 'Confirmar';
    BotaoOk.Left := BotaoIncluir.Left + BotaoIncluir.Width + Margem;
    BotaoOk.Top := BotaoIncluir.Top;
    BotaoOk.Name := 'btnConfirmar';

    // Botão Cancelar
    BotaoCancelar := TBitBtn.Create(FormPesquisa);
    BotaoCancelar.Parent := Rodape;
    BotaoCancelar.Kind := bkCancel;
    BotaoCancelar.Caption := 'Cancelar';
    BotaoCancelar.Left := Rodape.Width - BotaoCancelar.Width - Margem;
    BotaoCancelar.Anchors := [akRight];
    BotaoCancelar.Top := BotaoIncluir.Top;

    FormPesquisa.ShowModal;
  finally
    FormPesquisa.Release;
  end;
end;

function TMore.GetDataSource: TDataSource;
begin
  Result := FDataLink.Datasource;
end;

function TMore.GetPesquisaIndexConsulta: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TMore.OnDbClick(Sender: TObject);
var
  aForm: TCustomForm;
  i: Integer;
begin
  aForm := GetParentForm(TForm(TDBGrid(Sender).Parent));
  for i := 0 to aForm.ComponentCount - 1 do
  begin
    if aForm.Components[i] is TBitBtn then
    begin
      if (aForm.Components[i].Name = 'btnConfirmar') then
      begin
        TBitBtn(aForm.Components[i]).Click;
        Break;
      end;

    end;
  end;

end;

procedure TMore.SetDataSource(const Value: TDataSource);
begin
  FDataLink.Datasource := Value;
end;

procedure TMore.SetPesquisaIndexConsulta(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TMore.OnChangeEdt(Sender: TObject);
var
  aForm: TCustomForm;
  i: Integer;
begin
  aForm := GetParentForm(TForm(TPanel(TMaskEdit(Sender).Parent).Parent));
  for i := 0 to aForm.ComponentCount - 1 do
  begin
    if (aForm.Components[i] is TDBGrid) then
    begin
      if (aForm.Components[i].Name = 'grdResultados') then
      begin
        TDBGrid(aForm.Components[i]).DataSource.DataSet.Locate(GetPesquisaIndexConsulta, TMaskEdit(Sender).Text, [loCaseInsensitive, loPartialKey]);
        Break;
      end;

    end;

  end;

end;

end.

