unit uVContato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uCContato,
  Datasnap.DBClient, Vcl.Mask;

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
    procedure btLimparClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FCContato: TCContato;
    procedure LimparCampos;
    procedure AtribuirValoresContato(var ocdsContato: TClientDataSet);
    function MontarDataSetContato: Olevariant;
    procedure ExibirMensagem(mensagem: string);
    procedure GetRelacoesComboBox;
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

procedure TfVContato.AtribuirValoresContato(var ocdsContato: TClientDataSet);
begin
  ocdsContato.Edit;
  ocdsContato.FieldByName('Nome').AsString := edtNome.Text;
  ocdsContato.FieldByName('Sobrenome').AsString := edtSobrenome.Text;
  ocdsContato.FieldByName('Apelido').AsString := edtApelido.Text;
  ocdsContato.FieldByName('Nascimento').AsDateTime := StrToDate(edtNascimento.Text);
  ocdsContato.FieldByName('Relacao').AsString := cbRelacao.Text;
  ocdsContato.Post;
end;

procedure TfVContato.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfVContato.btLimparClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TfVContato.btSalvarClick(Sender: TObject);
var
  ocdsContato: TClientDataSet;
begin
  ocdsContato := TClientDataSet.Create(nil);
  try
    ocdsContato.Data := MontarDataSetContato;
    AtribuirValoresContato(ocdsContato);
    FCContato.SalvarContato(ocdsContato);
  finally
    LimparCampos;
    FreeAndNil(ocdsContato);
  end;
end;

constructor TfVContato.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if not assigned(FCContato) then
    FCContato := TCContato.Create(ExibirMensagem);

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
end;

procedure TfVContato.ExibirMensagem(mensagem: string);
begin
  ShowMessage('Erro: ' + mensagem);
  LimparCampos;
end;

procedure TfVContato.GetRelacoesComboBox;
begin
  cbRelacao.Clear;
  cbRelacao.Items.CommaText := FCContato.GetRelacoesContato;
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
