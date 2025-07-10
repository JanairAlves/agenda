unit uVTelefone;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uVInformacoesContatoPai,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Datasnap.DBClient, Data.DB,
  Vcl.DBGrids, Vcl.Grids;

type
  TfVTelefone = class(TfVInformacoesContatoPai)
    edtTelefone: TMaskEdit;
    edtOperadora: TEdit;
    cbTPLinha: TComboBox;
    lbTelefone: TLabel;
    lbTPLinha: TLabel;
    lbOperadora: TLabel;
    procedure btAdicionarClick(Sender: TObject);
    procedure btExibirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbGridDadosContatoKeyPress(Sender: TObject; var Key: Char);
  private
    procedure GetTPLinhaComboBox;
    procedure AtribuirValoresTelefone;
    procedure MontarDataSetTelefones;
  public
    { Public declarations }
    procedure LimparCampos; override;
  end;

var
  fVTelefone: TfVTelefone;

implementation

uses
  uCContato, System.UITypes;

{$R *.dfm}

{ TfVTelefone }

procedure TfVTelefone.AtribuirValoresTelefone;
begin
  FcdsDadosContato.Append;
  FcdsDadosContato.FieldByName('IdTelefone').AsInteger := FcdsDadosContato.RecordCount + 1;
  FcdsDadosContato.FieldByName('NuTelefone').AsString := Trim(edtTelefone.Text);
  FcdsDadosContato.FieldByName('TPLinha').AsString := Trim(cbTPLinha.Text);
  FcdsDadosContato.FieldByName('Operadora').AsString := Trim(edtOperadora.Text);
  FcdsDadosContato.Post;
end;

procedure TfVTelefone.btAdicionarClick(Sender: TObject);
begin
  AtribuirValoresTelefone;
  LimparCampos;
  inherited;
end;

procedure TfVTelefone.btExibirClick(Sender: TObject);
begin
  inherited;
  edtTelefone.SetFocus;
end;

procedure TfVTelefone.dbGridDadosContatoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  TravarEscritaTPLinhaDBG(Key, 'TPLinha');
end;

procedure TfVTelefone.FormCreate(Sender: TObject);
var
  column: TColumn;
  item: TCollectionItem;
begin
  inherited;
  GetTPLinhaComboBox;
  MontarDataSetTelefones;

  if assigned(SetCamposDBGDadosContato) then
    SetCamposDBGDadosContato;

  for item in dbGridDadosContato.Columns do
  begin
    column := TColumn(item);

    if not SameText(column.FieldName, 'TPLinha') then
      continue;

    column.PickList.Clear;
    column.PickList.CommaText := TCContato.GetTPLinha;
    column.ButtonStyle := cbsAuto;
    break;
  end;
end;

procedure TfVTelefone.FormShow(Sender: TObject);
begin
  inherited;
  edtTelefone.SetFocus;
end;

procedure TfVTelefone.GetTPLinhaComboBox;
begin
  cbTPLinha.Clear;
  cbTPLinha.Items.CommaText := TCContato.GetTPLinha;
  cbTPLinha.ItemIndex := 0;
end;

procedure TfVTelefone.LimparCampos;
begin
  inherited;
  edtTelefone.Clear;
  edtTelefone.SetFocus;
  cbTPLinha.ItemIndex := 0;
  edtOperadora.Clear;
end;

procedure TfVTelefone.MontarDataSetTelefones;
begin
  FcdsDadosContato.Close;
  FcdsDadosContato.FieldDefs.Clear;
  FcdsDadosContato.FieldDefs.Add('IdTelefone', ftInteger);
  FcdsDadosContato.FieldDefs.Add('NuTelefone', ftString, 16);
  FcdsDadosContato.FieldDefs.Add('TPLinha', ftString, 10);
  FcdsDadosContato.FieldDefs.Add('Operadora', ftString, 10);
  FcdsDadosContato.CreateDataSet;

  FcdsDadosContato.FieldByName('IdTelefone').DisplayLabel := 'Seq';
  FcdsDadosContato.FieldByName('NuTelefone').DisplayLabel := 'Número telefone';
  FcdsDadosContato.FieldByName('TPLinha').DisplayLabel := 'Tipo linha';
  FcdsDadosContato.FieldByName('Operadora').DisplayLabel := 'Operadora';
end;

end.
