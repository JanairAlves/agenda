unit uVAgenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  uVContato;

type
  TfVAgenda = class(TForm)
    pnAgendaContatos: TPanel;
    pnCentral: TPanel;
    btAdicionarContato: TButton;
    btFechar: TButton;
    procedure btAdicionarContatoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fVAgenda: TfVAgenda;

implementation

{$R *.dfm}

procedure TfVAgenda.btAdicionarContatoClick(Sender: TObject);
begin
  fVContato.ShowModal;
end;

procedure TfVAgenda.btFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfVAgenda.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

end.
