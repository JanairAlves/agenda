unit uVInformacoesContatoPai;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient;

type
  TProc = procedure of object;
  TfVInformacoesContatoPai = class(TForm)
    pnCampos: TPanel;
    pnBotoes: TPanel;
    btAdicionar: TButton;
    btCancelar: TButton;
    btLimpar: TButton;
    btExibir: TButton;
    btFechar: TButton;
    pnGridDadosContato: TPanel;
    dbGridDadosContato: TDBGrid;
    pnCentral: TPanel;
    FcdsDadosContato: TClientDataSet;
    FdsDadosContato: TDataSource;
    procedure btFecharClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btExibirClick(Sender: TObject);
    procedure dbGridDadosContatoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FSetCamposDBGDadosContato: TProc;
    function GetPnGridVisible: boolean;
    procedure SetColunasDBGrid;
    procedure SetPnGridVisibleTrue;
    procedure ExibirGridDadosContato;
    procedure SetPnGridVisibleFalse;
    procedure OcultarGridDadosContato;
    procedure CarregarDadosDataSetDBGrid;
  public
    { Public declarations }
  protected
    procedure LimparCampos; virtual; abstract;
    Property SetCamposDBGDadosContato: TProc read FSetCamposDBGDadosContato;
    procedure TravarEscritaTPLinhaDBG(var Key: Char; NomeCampo: string);
  end;

var
  fVInformacoesContatoPai: TfVInformacoesContatoPai;

implementation

uses
  System.UITypes;

const
  FFormSemGrid = 175;
  FFormComGrid = 270;

{$R *.dfm}

procedure TfVInformacoesContatoPai.btLimparClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TfVInformacoesContatoPai.CarregarDadosDataSetDBGrid;
begin
  FdsDadosContato.DataSet := FcdsDadosContato;
  dbGridDadosContato.DataSource := FdsDadosContato;
end;

procedure TfVInformacoesContatoPai.dbGridDadosContatoKeyPress(Sender: TObject;
  var Key: Char);
begin
  TravarEscritaTPLinhaDBG(Key, 'IdTelefone');
end;

procedure TfVInformacoesContatoPai.OcultarGridDadosContato;
begin
  Self.Height := FFormSemGrid;
end;

procedure TfVInformacoesContatoPai.ExibirGridDadosContato;
begin
  Self.Height := FFormComGrid
end;

procedure TfVInformacoesContatoPai.FormCreate(Sender: TObject);
begin
  FcdsDadosContato := TClientDataSet.Create(nil);
  FSetCamposDBGDadosContato := SetColunasDBGrid;
  Self.Height := FFormSemGrid;
end;

procedure TfVInformacoesContatoPai.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FcdsDadosContato);
end;

function TfVInformacoesContatoPai.GetPnGridVisible: boolean;
begin
  result := pnGridDadosContato.Visible;
end;

procedure TfVInformacoesContatoPai.SetColunasDBGrid;
var
  i: integer;
  tamanhoColuna: integer;
  dbGridColumn: TColumn;
begin
  dbGridDadosContato.Columns.Clear;
  tamanhoColuna := trunc(dbGridDadosContato.Width / (FcdsDadosContato.FieldCount -1));

    dbGridColumn := dbGridDadosContato.Columns.Add;
    dbGridColumn.FieldName := FcdsDadosContato.Fields[0].FieldName;
    dbGridColumn.Title.Caption := FcdsDadosContato.Fields[0].DisplayName;
    dbGridColumn.Width := 30;

  for i := 1 to FcdsDadosContato.FieldCount -1 do
  begin
    dbGridColumn := dbGridDadosContato.Columns.Add;
    dbGridColumn.FieldName := FcdsDadosContato.Fields[i].FieldName;
    dbGridColumn.Title.Caption := FcdsDadosContato.Fields[i].DisplayName;
    dbGridColumn.Width := tamanhoColuna -20;
  end;
end;

procedure TfVInformacoesContatoPai.SetPnGridVisibleFalse;
begin
  pnGridDadosContato.Visible := False;
  OcultarGridDadosContato;
end;

procedure TfVInformacoesContatoPai.SetPnGridVisibleTrue;
begin
  CarregarDadosDataSetDBGrid;
  pnGridDadosContato.Visible := True;
  dbGridDadosContato.Width := pnGridDadosContato.Width;
  dbGridDadosContato.Height := pnGridDadosContato.Height;
  ExibirGridDadosContato;
end;

procedure TfVInformacoesContatoPai.TravarEscritaTPLinhaDBG(var Key: Char;
  NomeCampo: string);
var
  column: TColumn;
begin
  column := dbGridDadosContato.Columns[dbGridDadosContato.SelectedIndex];
  if assigned(column) and (column.FieldName = NomeCampo) then
    if not CharInSet(Key, [#8, #9, #13, #27]) then
      Key := #0;
end;

procedure TfVInformacoesContatoPai.btAdicionarClick(Sender: TObject);
begin
  btCancelar.Enabled := True;
  
  if pnGridDadosContato.Visible =  true then
    CarregarDadosDataSetDBGrid;
end;

procedure TfVInformacoesContatoPai.btCancelarClick(Sender: TObject);
begin
  if MessageBox(Handle, 'As informações gravadas serão perdidas. Deseja continuar?',
              'Confirmação', MB_YESNO + MB_ICONQUESTION) = IDNO
  then
    exit;

  FcdsDadosContato.EmptyDataSet;
  LimparCampos;
  SetPnGridVisibleFalse;
  btCancelar.Enabled := False;
  Close;
end;

procedure TfVInformacoesContatoPai.btExibirClick(Sender: TObject);
begin
  if GetPnGridVisible then
    SetPnGridVisibleFalse
  else
    SetPnGridVisibleTrue;
end;

procedure TfVInformacoesContatoPai.btFecharClick(Sender: TObject);
begin
  LimparCampos;
  SetPnGridVisibleFalse;
  Close;
end;

end.
