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
    procedure btAdicionarContatoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TfVAgenda.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

end.
