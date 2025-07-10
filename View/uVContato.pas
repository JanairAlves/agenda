unit uVContato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uCContato,
  Datasnap.DBClient, Vcl.Mask, uVTelefone;

type
  TfVContato = class(TForm)
    edtNome: TEdit;
    lbNome: TLabel;
    lbSobrenome: TLabel;
    edtSobrenome: TEdit;
    edtApelido: TEdit;
    lbApelido: TLabel;
    lbNascimento: TLabel;
    btEndereco: TButton;
    btTelefone: TButton;
    btRedeSocial: TButton;
    cbRelacao: TComboBox;
    lbRelacao: TLabel;
    pnRodape: TPanel;
    pnCentral: TPanel;
    pnBotoesAcoes: TPanel;
    btSalvar: TButton;
    btLimpar: TButton;
    btFechar: TButton;
    edtNascimento: TMaskEdit;
    btNovo: TButton;
    procedure btLimparClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btTelefoneClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCContato: TCContato;
    FVTelefone: TfVTelefone;
    procedure LimparCampos;
    procedure AtribuirValoresContato(var poCdsContato: TClientDataSet);
    function MontarDataSetContato: Olevariant;
    procedure ExibirMensagem(pMensagem: string);
    procedure GetRelacoesComboBox;
    procedure InicializarCadastroContato;
    procedure DesabilitarCadastroContato;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fVContato: TfVContato;

implementation

uses
  System.SysUtils, System.Generics.Collections, Data.DB;

{$R *.dfm}

{ TfrmViewContato }

procedure TfVContato.AtribuirValoresContato(var poCdsContato: TClientDataSet);
  function ConverteData(eHData: boolean; dataDefault, data: string): TDate;
  begin
    if eHData then
      result := StrToDate(dataDefault)
    else
      result := StrToDate(data);
  end;
begin
  poCdsContato.Append;
  poCdsContato.FieldByName('Nome').AsString := Trim(edtNome.Text);
  poCdsContato.FieldByName('Sobrenome').AsString := Trim(edtSobrenome.Text);
  poCdsContato.FieldByName('Apelido').AsString := Trim(edtApelido.Text);
  poCdsContato.FieldByName('Nascimento').AsDateTime :=
    ConverteData(Trim(edtNascimento.Text) = '/  /', '01/01/1999', Trim(edtNascimento.Text));
  poCdsContato.FieldByName('Relacao').AsString := Trim(cbRelacao.Text);
  poCdsContato.Post;
end;

procedure TfVContato.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfVContato.btLimparClick(Sender: TObject);
begin
  LimparCampos;
  DesabilitarCadastroContato;
end;

procedure TfVContato.btNovoClick(Sender: TObject);
begin
  InicializarCadastroContato;
end;

procedure TfVContato.InicializarCadastroContato;
begin
  btSalvar.Enabled := true;
  btLimpar.Enabled := true;
  btEndereco.Enabled := true;
  btTelefone.Enabled := true;
  btRedeSocial.Enabled := true;
  btNovo.Enabled := false;

  edtNome.Enabled := true;
  edtSobrenome.Enabled := true;
  edtApelido.Enabled := true;
  edtNascimento.Enabled := true;
  cbRelacao.Enabled := true;
end;

procedure TfVContato.DesabilitarCadastroContato;
begin
  btSalvar.Enabled := false;
  btLimpar.Enabled := false;
  btEndereco.Enabled := false;
  btTelefone.Enabled := false;
  btRedeSocial.Enabled := false;
  btNovo.Enabled := true;

  edtNome.Enabled := false;
  edtSobrenome.Enabled := false;
  edtApelido.Enabled := false;
  edtNascimento.Enabled := false;
  cbRelacao.Enabled := false;
end;

procedure TfVContato.btSalvarClick(Sender: TObject);
var
  ocdsContato: TClientDataSet;
begin
  ocdsContato := TClientDataSet.Create(nil);
  try
    ocdsContato.Data := MontarDataSetContato;
    AtribuirValoresContato(ocdsContato);
    FCContato.SalvarContato(ocdsContato, FVTelefone.FcdsDadosContato);
  finally
    LimparCampos;
    DesabilitarCadastroContato;
    FreeAndNil(ocdsContato);
    FVTelefone.FcdsDadosContato.EmptyDataSet;
  end;
end;

procedure TfVContato.btTelefoneClick(Sender: TObject);
begin
  FVTelefone.ShowModal;
end;

constructor TfVContato.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCContato := TCContato.Create(ExibirMensagem);
  FVTelefone := TfVTelefone.Create(nil);

  GetRelacoesComboBox;
end;

function TfVContato.MontarDataSetContato: Olevariant;
var
  cdsTemp: TClientDataSet;
begin
  cdsTemp := TClientDataSet.Create(nil);
  try
    cdsTemp.Close;
    cdsTemp.FieldDefs.Clear;
    cdsTemp.FieldDefs.Add('Nome', ftString, 50);
    cdsTemp.FieldDefs.Add('Sobrenome', ftString, 100);
    cdsTemp.FieldDefs.Add('Apelido', ftString, 50);
    cdsTemp.FieldDefs.Add('Nascimento', ftDate);
    cdsTemp.FieldDefs.Add('Relacao', ftString, 10);

    cdsTemp.CreateDataSet;
    result := cdsTemp.Data;
  finally
    FreeAndNil(cdsTemp);
  end;
end;

destructor TfVContato.Destroy;
begin
  inherited;
  FreeAndNil(FCContato);
  FreeAndNil(FVTelefone);
end;

procedure TfVContato.ExibirMensagem(pMensagem: string);
begin
  ShowMessage('Erro: ' + pMensagem);
  FVTelefone.FcdsDadosContato.EmptyDataSet;
  LimparCampos;
end;

procedure TfVContato.FormCreate(Sender: TObject);
begin
  DesabilitarCadastroContato;
end;

procedure TfVContato.GetRelacoesComboBox;
begin
  cbRelacao.Clear;
  cbRelacao.Items.CommaText := TCContato.GetRelacoesContato;
  cbRelacao.ItemIndex := 0;
end;

procedure TfVContato.LimparCampos;
begin
  edtNome.Text := '';
  edtNome.SetFocus;
  edtSobrenome.Text := '';
  edtApelido.Text := '';
  edtNascimento.Text := '';
  cbRelacao.ItemIndex := 0;
end;

end.
